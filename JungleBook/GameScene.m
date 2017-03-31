//
//  GameScene.m
//  JungleBook
//
//  Created by Jo on 13.03.17.
//  Copyright © 2017 Johannes. All rights reserved.
//

#import "GameScene.h"
#import "Mowgli.h"
#import "MLWorldGenerator.h"
#import "MLPointLabel.h"
#import "GameData.h"
#import "MenuScene.h"
#import "ShereKhan.h"
#import "LevelScene.h"


@interface GameScene()
@property BOOL isStarted;
@property BOOL isGameOver;
@property int lowestScore;
@property int oneContact;

@end

@implementation GameScene {
    Mowgli *mowgli;
    ShereKhan *tiger;
    SKNode *world;
    MLWorldGenerator *generator;
    
}

static NSString *GAME_FONT = @"AmericanTypewriter-Bold";

-(id)initWithSize:(CGSize)size {
    if(self = [super initWithSize:size]) {
        //setzt den Ankerpunkt in die Mitte des Views
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.physicsWorld.contactDelegate = self;
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        //Welt wird erstellt
        world = [SKNode node];
        [self addChild: world];
        
        //Hintergrund
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed: @"background"];
        background.size = CGSizeMake(self.size.width, self.size.height);
        background.name=@"background";
        background.zPosition = -2;
        
        [world addChild:background];

        //Inhalte werden in die Welt gesetzt
        [self createContent];
        
    }
    return self;
}

-(void)createContent
{

    NSLog(@"CONTENT GENERATED");
    
    //Generieren der Interaktionsobjekte der Welt
    generator = [MLWorldGenerator generatorWithWorld:world];
    [self addChild:generator];
    [generator populate];
    
    //Score Labels
    [self loadScoreLabels];
    
    //Info and Animation Game Startscreen
    SKLabelNode *tapToBeginLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    tapToBeginLabel.name = @"tapToBeginLabel";
    tapToBeginLabel.text = @"Tap to begin";
    tapToBeginLabel.fontSize = 20.0;
    [self addChild:tapToBeginLabel];
    [self animateWithPulse:tapToBeginLabel];
    
}

-(void)loadScoreLabels
{
    //PunkteLabel
    MLPointLabel *pointsLabel =[MLPointLabel pointsLabelWithFontNamed:GAME_FONT];
    pointsLabel.name = @"pointsLabel";
    pointsLabel.position = CGPointMake(-200, 100);
    [self addChild:pointsLabel];
    
    //Persistente Daten werden geladen
    GameData *data = [GameData data];
    [data load];
    
    //Wird gesetzt, um unrelevante Scores zu verwerfen
    self.lowestScore = data.lowestScore;
    
    //Highscore-Label
    MLPointLabel *highscoreLabel =[MLPointLabel pointsLabelWithFontNamed:GAME_FONT];
    highscoreLabel.name = @"highscoreLabel";
    highscoreLabel.position = CGPointMake(200, 100);
    [highscoreLabel setPoints:data.highscore];
    [self addChild:highscoreLabel];
    
    //Text-Label für Highscore
    SKLabelNode *bestLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    bestLabel.text = @"Best";
    bestLabel.fontSize= 16.0;
    bestLabel.position = CGPointMake(-38, 0);
    [highscoreLabel addChild:bestLabel];
    
}

-(void)didSimulatePhysics
{
    [self centerOnNode:mowgli];
    [self handlePoints];
    [self handleGeneration];
    [self handleCleanup];
}


-(void)handleGeneration
{
    //Generiert jedes mal neue Objekte, wenn Mowgli einen Ground übersprungen hat
    [world enumerateChildNodesWithName: @"ground" usingBlock:^(SKNode *node, BOOL *stop) {
        if(node.position.x < mowgli.position.x){
            [generator generate];
        }
    }];
    
   //Setzt den Namen "Obstacle Cancelled", wenn Mowgli diese überwunden hat
    [world enumerateChildNodesWithName: @"obstacle" usingBlock:^(SKNode *node, BOOL *stop) {
        if(node.position.x < mowgli.position.x){
            node.name=@"obstacle_cancelled";
        }
    }];
    
    //Wenn der Tiger Mowgli einholt --> Game Over
    if(mowgli.position.x < tiger.position.x){
        [self gameOver];
    }
    
}

-(void)handlePoints
{
    
    //Nach Überwinden eines Obstacles --> Punkte um 1 erhöht
    [world enumerateChildNodesWithName: @"obstacle" usingBlock:^(SKNode *node, BOOL *stop) {
        if(node.position.x < mowgli.position.x){
            MLPointLabel *pointsLabel = (MLPointLabel *)[self childNodeWithName:@"pointsLabel"];
            [pointsLabel increment];
        }
    }];
}


-(void)handleCleanup
{
    //entfernt Objekte mit dem Namen "Ground" , welche nicht mehr zu sehen sind
    [world enumerateChildNodesWithName:@"ground" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if(node.position.x < mowgli.position.x -self.frame.size.width/2 - node.frame.size.width/2){
            [node removeFromParent];
        }
            }];
    
    //entfernt Objekte mit dem Namen "obstacle_cancelled" , welche nicht mehr zu sehen sind
    [world enumerateChildNodesWithName:@"obstacle_cancelled" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if(node.position.x < mowgli.position.x -self.frame.size.width/2 - node.frame.size.width/2){
            [node removeFromParent];
        }
    }];
}

-(void)centerOnNode:(SKNode *)node
{
    //Zentriert die Welt immer auf ein Node(Mowgli) und bewegt den Hintergrund mit auf der X-Position des Nodes(Mowgli)
    CGPoint positionInScene = [self convertPoint:node.position fromNode:node.parent];
    world.position = CGPointMake(world.position.x - positionInScene.x, world.position.y);
    [world childNodeWithName:@"background"].position = CGPointMake(node.position.x,0);
}

-(void) start {
    
    self.isStarted = YES;
    [[self childNodeWithName:@"tapToBeginLabel"] removeFromParent];
    
    //erzeugt Instanz von Mowgli und lässt diese loslaufen
    mowgli = [Mowgli mowgli];
    [world addChild:mowgli];
    [mowgli start];
    
    
    GameData *data = [GameData data];
    [data load];
    
   if(data.highscore <10){
        //ADD EASY SCENARIO
    }
    else if(data.highscore >10 && data.highscore <30){
        //Wenn der Score zwischen 10 und 29 liegt, wird Shere Khan als Verfolger gespawnt
        tiger = [ShereKhan tiger];
        tiger.position = CGPointMake(-self.frame.size.width - 20, -self.frame.size.height/2 + 50 + tiger.frame.size.height/2);
        [world addChild:tiger];
        [tiger start];
    }
    else if(data.highscore >=30){
        //ADD HARD SCENARIO
    }
}

-(void) clear
{
    GameScene *scene = [[GameScene alloc] initWithSize:self.frame.size];
    [self.view presentScene:scene];
}

-(void) gameOver
{
    //Stoppt die Bewegung von Mowgli und dem Tiger
    self.isGameOver = YES;
    [mowgli stop];
    [tiger stop];

    //Text-Label Game Over
    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    gameOverLabel.text = @"Game Over";
    gameOverLabel.position = CGPointMake(0, 60);
    [self addChild:gameOverLabel];
    
    //Text-Label Reset Button

    SKLabelNode *tapToResetLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    tapToResetLabel.name = @"tapToResetLabel";
    tapToResetLabel.text = @"Tap to reset";
    tapToResetLabel.fontSize = 20.0;
    [self addChild:tapToResetLabel];
    [self animateWithPulse:tapToResetLabel];
    
    //Text-Label Menu

    SKLabelNode *tapToMenuLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    tapToMenuLabel.name = @"tapToMenuLabel";
    tapToMenuLabel.text = @"Menu";
    tapToMenuLabel.fontSize = 30.0;
    tapToMenuLabel.position = CGPointMake(-150, 150);
    [self addChild:tapToMenuLabel];
    
    [self updateHighscore];
    
}


-(void)updateHighscore
{
    //Pointer auf Label gesetzt
    MLPointLabel *pointsLabel = (MLPointLabel *) [self childNodeWithName:@"pointsLabel"];
    MLPointLabel *highscoreLabel = (MLPointLabel *) [self childNodeWithName:@"highscoreLabel"];

    GameData *data = [GameData data];
    [data load];
    
    //neu erreichter Score
    data.newNumber = pointsLabel.number;
    
    //Muss der neue Score eingetragen werden?
    if(data.newNumber > data.lowestScore && !data.valuesSaved){
        [data save];
    }
    
    //Muss die Highscore Anzeige aktualisiert werden?
    if(pointsLabel.number > highscoreLabel.number){
        [highscoreLabel setPoints: pointsLabel.number];
    }
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //wurde ein Node berührt?
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    
    if(!self.isStarted){
        _oneContact=0;
        [self start];
    }
    else if([node.name isEqualToString:@"tapToMenuLabel"]){
        //Übergang ins Menü
        MenuScene *menuScene = [[MenuScene alloc] initWithSize:self.size];
        SKTransition *transition = [SKTransition doorsCloseHorizontalWithDuration:1.5];
        [self.view presentScene:menuScene transition:transition];

    }
    //Reset des Spiels
    else if (self.isGameOver)
        [self clear];
    else
        //Standard-Aktion ingame
        [mowgli jump];
    
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    //Überprüft, ob Mowgli Kontakt mit legaler Spielfläche hat, sonst Game Over
    if([contact.bodyA.node.name isEqualToString: @"ground"] || [contact.bodyB.node.name isEqualToString: @"ground"] || [contact.bodyA.node.name isEqualToString: @"platform"] || [contact.bodyB.node.name isEqualToString: @"platform"]){
        [mowgli land];
    }
    else{
        
        //In dieser Form aufrufen, damit nur einmal gameOver gegeben wird und der Highscore nur einmal gespeichert wird
        for(_oneContact; _oneContact < 1; ++_oneContact) {
            NSLog(@"Calledausgeführt");
            [self gameOver];
        }
        
    }
}


//Animations Text Labels
-(void)animateWithPulse:(SKNode *)node
{
    SKAction *disappear = [SKAction fadeAlphaTo:0.0 duration:0.6];
    SKAction *appear = [SKAction fadeAlphaTo:1.0 duration:0.6];
    SKAction *pulse = [SKAction sequence:@[disappear, appear]];
    [node runAction:[SKAction repeatActionForever:pulse]];
}

@end
