//
//  LevelScene.m
//  JungleBook
//
//  Created by Jo on 17.03.17.
//  Copyright © 2017 Johannes. All rights reserved.
//

#import "LevelScene.h"
#import "MenuScene.h"
#import "GameViewController.h"

@interface LevelScene()
@end

@implementation LevelScene

-(id)initWithSize:(CGSize)size
{

    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    int Difficulty = 2;

    
    // if next button touched, start transition to next scene
    if ([node.name isEqualToString:@"easyLevel"]) {
        [self chosen:node];
        Difficulty = 1;
    } else if([node.name isEqualToString:@"normalLevel"]){
        [self chosen:node];
        Difficulty = 2;
    } else if([node.name isEqualToString:@"hardLevel"]){
        [self chosen:node];
        Difficulty = 3;
    } else if([node.name isEqualToString:@"back"]){
        MenuScene *menuScene = [[MenuScene alloc] initWithSize:self.size];
        SKTransition *transition = [SKTransition doorsCloseHorizontalWithDuration:1.5];
        [self.view presentScene:menuScene transition:transition];
}
}


-(void)chosen: (SKNode *) node{
    
    NSArray *buttons = [[node parent] children];
    
    for (SKNode *button in buttons) {
        [button runAction:[SKAction scaleTo:0.7 duration:0.2]];
    }
    
    SKAction *scaleBy = [SKAction scaleTo:1.0 duration:1.0];
    [node runAction:scaleBy];
    
}

@end
