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
@property NSString *extraDist;
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

-(void)populate{
            [self generate];
}

-(void) generate
{
    //Eventuell muss eine ExtraDistanz je nach Obstacle gegeben werden, um Spielbarkeit zu garantieren
    if([_extraDist isEqualToString: @"Obstacles"]){
        _currentObstacleX += 400;
    }else if([_extraDist isEqualToString: @"Ground and Obstacles"]){
        _currentObstacleX += 200;
    }else if([_extraDist isEqualToString: @"Snake"]){
        _currentObstacleX +=500;
    }
    //Making Ground
    SKSpriteNode* ground = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
    ground.name=@"ground";
    ground.size = CGSizeMake(self.scene.frame.size.width, 50);
    ground.position = CGPointMake(self.currentGroundX, -self.scene.frame.size.height/2 + ground.frame.size.height/2);
    ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.size];
    ground.physicsBody.dynamic = NO;
    ground.physicsBody.categoryBitMask = groundCategory;
    
    
    
    SKSpriteNode *obstacle = [self addRandomObstacle];
    
    //für Hindernisse, welche kein SpriteNode sind, wird ein unsichtbares SpriteNode erzeugt, um Spielbarkeit zu erhalten
    if(obstacle == NULL){
        obstacle = [SKSpriteNode spriteNodeWithImageNamed: @"stone"];
        obstacle.name = @"obstacle";
        obstacle.position = CGPointMake(_currentObstacleX,-500);
        obstacle.scale = 0.1;
        _currentGroundX +=200;
        [self.world addChild: obstacle];
    }else{
    
    obstacle.name = @"obstacle";
    obstacle.position = CGPointMake(_currentObstacleX, -self.scene.frame.size.height/2 +ground.frame.size.height + obstacle.frame.size.height/2 -10);
    obstacle.physicsBody = [SKPhysicsBody bodyWithTexture: obstacle.texture size: obstacle.texture.size];
    obstacle.physicsBody.dynamic = NO;
    obstacle.physicsBody.categoryBitMask = obstacleCategory;
    obstacle.zPosition = 3;
    [self.world addChild: obstacle];
    }
    
    //nächstes Obstacle wird in zufälligem Abstand gespawnt
    self.currentObstacleX += arc4random_uniform(400) +400;
    self.currentGroundX += ground.frame.size.width;

    [self.world addChild:ground];
}


-(void)generatePlattforms{
    //Generiert Plattforms zum Springen
    SKSpriteNode* platform = [SKSpriteNode spriteNodeWithImageNamed:@"jump"];
    platform.name=@"platform";
    platform.size = CGSizeMake(210, 50);
    
    platform.position = CGPointMake(self.currentGroundX, -50);
    platform.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:platform.size];
    platform.physicsBody.dynamic = NO;
    [self.world addChild:platform];
}


-(SKSpriteNode *)addRandomObstacle
{
    int rand = arc4random_uniform(6);
    SKTexture *stump =[SKTexture textureWithImageNamed:@"stump"];
    SKTexture *stone =[SKTexture textureWithImageNamed:@"stone"];
    SKTexture *snake =[SKTexture textureWithImageNamed:@"1"];

    SKSpriteNode *randObstacle;
    switch(rand) {
        case 0:
            randObstacle =[SKSpriteNode spriteNodeWithTexture: stump];
            _extraDist= @"NO";
            break;
        case 1:
            randObstacle =[SKSpriteNode spriteNodeWithTexture: stone];
            _extraDist=@"NO";
            break;
        case 2:
            randObstacle =NULL;
            _extraDist=@"Obstacles";
            break;
        case 3:
            randObstacle =NULL;
            [self generatePlattforms];
            _extraDist=@"Obstacles";
            break;
        case 4:
            randObstacle =[SKSpriteNode spriteNodeWithTexture: snake];
            _currentObstacleX += 400;
            _extraDist=@"Snake";
            [self move:randObstacle];
            break;
        case 5:
            randObstacle =[SKSpriteNode spriteNodeWithTexture: stone];
            _extraDist=@"NO";
            break;
        default:
            break;
    }
    return randObstacle;
}

//Animation und Bewegung für Snake 
-(void) move:(SKSpriteNode*) node{
    //reference atlas
    SKTextureAtlas *snake = [SKTextureAtlas atlasNamed:@"snake"];
    
    //name of files
    NSArray *listOfFiles = [snake textureNames];
    
    //sortieren
    NSArray *sortedNames = [listOfFiles sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    //array to hold image textures
    NSMutableArray *snakeTextures = [NSMutableArray array];
    
    for(NSString *filename in sortedNames){
        SKTexture *texture = [snake textureNamed:filename];
        [snakeTextures addObject:texture];
    }
    
    SKAction *run =[SKAction animateWithTextures:snakeTextures timePerFrame:0.3];
    SKAction *move = [SKAction moveByX:-150 y:node.position.y duration:2.0];
    SKAction *sequence = [SKAction group:@[move, run]];
    SKAction *repeater = [SKAction repeatActionForever:sequence];
    [node runAction:repeater];
    [node runAction: move];
}

@end

