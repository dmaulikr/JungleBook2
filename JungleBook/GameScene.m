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


@interface GameScene()
@property BOOL isStarted;
@property BOOL isGameOver;
@end

@implementation GameScene {
    Mowgli *mowgli;
    SKNode *world;
    MLWorldGenerator *generator;
    
}

static NSString *GAME_FONT = @"AmericanTypewriter-Bold";

-(id)initWithSize:(CGSize)size {
    if(self = [super initWithSize:size]) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.physicsWorld.contactDelegate = self;
        [self createContent];
        
    }
    return self;
}

-(void)createContent
{
    //Attaching World
    
    self.backgroundColor = [SKColor colorWithRed:0.54 green:0.7853 blue:1.0 alpha:1.0];
    
    world = [SKNode node];
    [self addChild: world];
    
    generator = [MLWorldGenerator generatorWithWorld:world];
    [self addChild:generator];
    [generator populate];
    
    [self loadScoreLabels];
    
    SKLabelNode *tapToBeginLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    tapToBeginLabel.name = @"tapToBeginLabel";
    tapToBeginLabel.text = @"Tap to begin";
    tapToBeginLabel.fontSize = 20.0;
    [self addChild:tapToBeginLabel];
    [self animateWithPulse:tapToBeginLabel];
    
    [self loadClouds];

}

-(void)loadScoreLabels
{
    MLPointLabel *pointsLabel =[MLPointLabel pointsLabelWithFontNamed:GAME_FONT];
    pointsLabel.name = @"pointsLabel";
    pointsLabel.position = CGPointMake(-200, 100);
    [self addChild:pointsLabel];
    
    GameData *data = [GameData data];
    [data load];
    
    MLPointLabel *highscoreLabel =[MLPointLabel pointsLabelWithFontNamed:GAME_FONT];
    highscoreLabel.name = @"highscoreLabel";
    highscoreLabel.position = CGPointMake(200, 100);
    [highscoreLabel setPoints:data.highscore];
    [self addChild:highscoreLabel];
    
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

-(void)loadClouds
{
    SKShapeNode *cloud1 = [SKShapeNode node];
    cloud1.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 65, 100, 40)].CGPath;
    cloud1.fillColor =[SKColor whiteColor];
    [world addChild:cloud1];
}

-(void)handleGeneration
{
    [world enumerateChildNodesWithName: @"obstacle" usingBlock:^(SKNode *node, BOOL *stop) {
        if(node.position.x < mowgli.position.x){
            node.name=@"obstacle_cancelled";
            [generator generate];
        }
    }];
}

-(void)handlePoints
{
    [world enumerateChildNodesWithName: @"obstacle" usingBlock:^(SKNode *node, BOOL *stop) {
        if(node.position.x < mowgli.position.x){
            MLPointLabel *pointsLabel = (MLPointLabel *)[self childNodeWithName:@"pointsLabel"];
            [pointsLabel increment];
        }
    }];
}


-(void)handleCleanup
{
    [world enumerateChildNodesWithName:@"ground" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if(node.position.x < mowgli.position.x -self.frame.size.width/2 - node.frame.size.width/2){
            [node removeFromParent];
        }
            }];
    
    [world enumerateChildNodesWithName:@"obstacle_cancelled" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        if(node.position.x < mowgli.position.x -self.frame.size.width/2 - node.frame.size.width/2){
            [node removeFromParent];
        }
    }];
}

-(void)centerOnNode:(SKNode *)node
{
    CGPoint positionInScene = [self convertPoint:node.position fromNode:node.parent];
    world.position = CGPointMake(world.position.x - positionInScene.x, world.position.y);
}

-(void) addGround:(CGSize)size {

}

-(void) addGrass:(CGSize)size {

}

-(void) start {
    self.isStarted = YES;
    [[self childNodeWithName:@"tapToBeginLabel"] removeFromParent];
    mowgli = [Mowgli mowgli];
    [world addChild:mowgli];
    [mowgli start];
}

-(void) clear
{
    GameScene *scene = [[GameScene alloc] initWithSize:self.frame.size];
    [self.view presentScene:scene];
}

-(void) gameOver
{
    self.isGameOver = YES;
    [mowgli stop];

    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    gameOverLabel.text = @"Game Over";
    gameOverLabel.position = CGPointMake(0, 60);
    [self addChild:gameOverLabel];
    
    SKLabelNode *tapToResetLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    tapToResetLabel.name = @"tapToResetLabel";
    tapToResetLabel.text = @"Tap to reset";
    tapToResetLabel.fontSize = 20.0;
    [self addChild:tapToResetLabel];
    [self animateWithPulse:tapToResetLabel];
    
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
    MLPointLabel *pointsLabel = (MLPointLabel *) [self childNodeWithName:@"pointsLabel"];
    MLPointLabel *highscoreLabel = (MLPointLabel *) [self childNodeWithName:@"highscoreLabel"];

    if(pointsLabel.number > highscoreLabel.number){
        [highscoreLabel setPoints: pointsLabel.number];
        GameData *data = [GameData data];
        data.highscore = pointsLabel.number;
        [data save];
    }
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if(!self.isStarted)
        [self start];
    else if([node.name isEqualToString:@"tapToMenuLabel"]){
        MenuScene *menuScene = [[MenuScene alloc] initWithSize:self.size];
        SKTransition *transition = [SKTransition doorsCloseHorizontalWithDuration:1.5];
        [self.view presentScene:menuScene transition:transition];

    }
    else if (self.isGameOver)
        [self clear];
    else
        [mowgli jump];
    
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    if([contact.bodyA.node.name isEqualToString: @"ground"] || [contact.bodyB.node.name isEqualToString: @"ground"]){
        [mowgli land];
    }else {
        [self gameOver];
    }
}

-(void)animateWithPulse:(SKNode *)node
{
    SKAction *disappear = [SKAction fadeAlphaTo:0.0 duration:0.6];
    SKAction *appear = [SKAction fadeAlphaTo:1.0 duration:0.6];
    SKAction *pulse = [SKAction sequence:@[disappear, appear]];
    [node runAction:[SKAction repeatActionForever:pulse]];
}

@end
