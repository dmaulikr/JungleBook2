//
//  MenuScene.m
//  JungleBook
//
//  Created by Jo on 17.03.17.
//  Copyright © 2017 Johannes. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"
#import "LevelScene.h"
#import "ScoreScene.h"


@interface MenuScene()

@end

@implementation MenuScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.anchorPoint = CGPointMake(0.5, 0.5);
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background.jpg"];
        background.position = CGPointMake(0,0);
        [self addChild:background];

        SKSpriteNode *playButton =[SKSpriteNode spriteNodeWithImageNamed:@"play_button"];
        playButton.size = CGSizeMake(230, 63.702);
        playButton.position = CGPointMake(0,-20);
        playButton.name = @"playButton";
        [self addChild:playButton];
        
        SKSpriteNode *levelButton = [SKSpriteNode spriteNodeWithImageNamed:@"difficulty_button"];
        levelButton.size = CGSizeMake(230, 63.702);
        levelButton.position = CGPointMake(-150, -100);
        levelButton.name = @"levelButton";
        [self addChild:levelButton];
        
        SKSpriteNode *highscoreButton = [SKSpriteNode spriteNodeWithImageNamed:@"highscore_button"];
        highscoreButton.size = CGSizeMake(230, 63.702);
        highscoreButton.position = CGPointMake(150, -100);
        highscoreButton.name = @"highscoreButton";
        [self addChild:highscoreButton];
        
        SKLabelNode *title = [SKLabelNode labelNodeWithText:@"Mogli Run"];
        title.position = CGPointMake(0, 130);
        title.fontSize = 42.0;
        [self addChild:title];
        
        SKAction *repeater = [SKAction repeatActionForever:[SKAction playSoundFileNamed:@"rainforest.caf" waitForCompletion:YES]];
        [self runAction:repeater];

        

    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    // if next button touched, start transition to next scene
    if ([node.name isEqualToString:@"playButton"]) {
        SKScene *gameScene = [[GameScene alloc] initWithSize:self.size];
        SKTransition *transition = [SKTransition doorsOpenHorizontalWithDuration:1.5];
        [self.view presentScene:gameScene transition:transition];
    } else if([node.name isEqualToString:@"levelButton"]){
        LevelScene *levelScene = (LevelScene *)[SKScene nodeWithFileNamed:@"LevelMenu"];
        SKTransition *transition = [SKTransition doorsOpenHorizontalWithDuration:0.8];
        [self.view presentScene:levelScene transition:transition];

    } else if([node.name isEqualToString:@"highscoreButton"]){
        SKScene *scoreScene = (ScoreScene *)[SKScene nodeWithFileNamed:@"ScoresMenu"];
        SKTransition *transition = [SKTransition doorsOpenHorizontalWithDuration:0.8];
        [self.view presentScene:scoreScene transition:transition];
    }
}

@end

