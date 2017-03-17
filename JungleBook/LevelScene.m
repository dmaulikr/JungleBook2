//
//  LevelScene.m
//  JungleBook
//
//  Created by Jo on 17.03.17.
//  Copyright © 2017 Johannes. All rights reserved.
//

#import "LevelScene.h"
#import "MenuScene.h"

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
    
    // if next button touched, start transition to next scene
    if ([node.name isEqualToString:@"easyLevel"]) {
        [self chosen:node];
    } else if([node.name isEqualToString:@"normalLevel"]){
        [self chosen:node];
    } else if([node.name isEqualToString:@"hardLevel"]){
        [self chosen:node];
    } else if([node.name isEqualToString:@"back"]){
        MenuScene *menuScene = [[MenuScene alloc] initWithSize:self.size];
        SKTransition *transition = [SKTransition doorsCloseHorizontalWithDuration:1.5];
        [self.view presentScene:menuScene transition:transition];
}
}


-(void)chosen: (SKNode *) node{
    SKAction *choose = [SKAction scaleTo:2.0 duration:0.5];
    SKAction *after = [SKAction scaleTo:1.0 duration:0.5];
    SKAction *sequence = [SKAction sequence:@[choose, after]];
    [node runAction:sequence];
}

@end
