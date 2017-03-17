//
//  MLWorldGenerator.m
//  JungleBook
//
//  Created by Jo on 15.03.17.
//  Copyright © 2017 Johannes. All rights reserved.
//

#import "MLWorldGenerator.h"

@interface MLWorldGenerator()
@property double currentGroundX;
@property double currentObstacleX;
@property SKNode *world;
@end

@implementation MLWorldGenerator

static const uint32_t obstacleCategory = 0x1 <<1;
static const uint32_t groundCategory = 0x1 <<2;


+(id)generatorWithWorld:(SKNode *) world
{
    MLWorldGenerator *generator = [MLWorldGenerator node];
    generator.currentGroundX = 0;
    generator.currentObstacleX = 400;
    generator.world = world;
    return generator;
}


-(void) populate
{
    for(int i=0; i<3; i++){
        [self generate];

    }
}

-(void) generate
{
    //Making Ground
    SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"torch"];
    ground.name=@"ground";
    ground.size = CGSizeMake(self.scene.frame.size.width, 50);
    ground.position = CGPointMake(self.currentGroundX, -self.scene.frame.size.height/2 + ground.frame.size.height/2);
    
    ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.size];
    ground.physicsBody.dynamic = NO;
    
    SKSpriteNode *grass = [SKSpriteNode spriteNodeWithImageNamed:@"green"];
    
    grass.size = CGSizeMake(self.scene.frame.size.width, 15);
    grass.name=@"ground";

    grass.position = CGPointMake(self.currentGroundX, -self.scene.frame.size.height/2+grass.frame.size.height/2 + 50);
    
    grass.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: grass.frame.size];
    grass.physicsBody.dynamic = NO;
    grass.physicsBody.categoryBitMask = groundCategory;

    
    //Add to World
    [self.world addChild:ground];
    
    [self.world addChild:grass];
    
    self.currentGroundX += ground.frame.size.width;
    
    
    //SKSpriteNode *obstacle = [SKSpriteNode spriteNodeWithImageNamed:@"stone"];
    SKSpriteNode *obstacle = [self getRandomObstacle];
    obstacle.name = @"obstacle";
    obstacle.position = CGPointMake(self.currentObstacleX, ground.position.y + ground.frame.size.height/2 +grass.frame.size.height  +obstacle.size.height/2 - 10);
    obstacle.physicsBody = [SKPhysicsBody bodyWithTexture: obstacle.texture size: obstacle.texture.size];
    obstacle.physicsBody.dynamic = NO;
    obstacle.physicsBody.categoryBitMask = obstacleCategory;
    
    
    [self.world addChild: obstacle];
    
    
    self.currentObstacleX += arc4random_uniform(400) +400;
    
}

-(SKSpriteNode *)getRandomObstacle
{
    int rand = arc4random_uniform(2);
    SKTexture *stump =[SKTexture textureWithImageNamed:@"stump"];
    SKTexture *stone =[SKTexture textureWithImageNamed:@"stone"];

    
    SKSpriteNode *randObstacle;
    switch(rand) {
        case 0:
            randObstacle =[SKSpriteNode spriteNodeWithTexture: stump];
            break;
        case 1:
            randObstacle =[SKSpriteNode spriteNodeWithTexture: stone];
            break;
        case 2:
            randObstacle =[SKSpriteNode spriteNodeWithTexture: stump];
            break;
        case 3:
            randObstacle =[SKSpriteNode spriteNodeWithTexture: stone ];
            break;
        case 4:
            randObstacle =[SKSpriteNode spriteNodeWithTexture: stump];
            break;
        case 5:
            randObstacle =[SKSpriteNode spriteNodeWithTexture: stone];

            break;
        default:
            break;
    }
    return randObstacle;
}


-(void)createTextures
{
}

@end
