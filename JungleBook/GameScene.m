//
//  GameScene.m
//  JungleBook
//
//  Created by Jo on 13.03.17.
//  Copyright © 2017 Johannes. All rights reserved.
//

#import "GameScene.h"
#import "Mowgli.h"

@interface GameScene()

@end

@implementation GameScene {
    Mowgli *mowgli;
    SKNode *world;
    
}

-(id)initWithSize:(CGSize)size {
    if(self = [super initWithSize:size]) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.backgroundColor = [SKColor colorWithRed:0.5 green:0.9 blue:0.9 alpha:1.0];
        
        //Attaching World
        world = [SKNode node];
        [self addChild: world];
        
        //Making Ground
        SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"torch"];
        
        ground.size = CGSizeMake(size.width, 50);
        ground.position = CGPointMake(0, -self.frame.size.height/2 + ground.frame.size.height/2);
        
        ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.size];
        ground.physicsBody.dynamic = NO;
        
        SKSpriteNode *grass = [SKSpriteNode spriteNodeWithImageNamed:@"green"];
        
        grass.size = CGSizeMake(size.width, 15);
        
        grass.position = CGPointMake(0, -self.frame.size.height/2+grass.frame.size.height/2 + 50);
        
        grass.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: grass.frame.size];
        grass.physicsBody.dynamic = NO;
        
        //Add to World
        [world addChild:ground];
        
        [world addChild:grass];
        
        mowgli = [Mowgli mowgli];
        [world addChild:mowgli];
    }
    return self;
}

-(void)didSimulatePhysics
{
   [self centerOnNode:mowgli];
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


-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [mowgli jump];
    
}


@end
