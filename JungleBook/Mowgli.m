//
//  Mowgli.m
//  JungleBook
//
//  Created by Jo on 14.03.17.
//  Copyright © 2017 Johannes. All rights reserved.
//

#import "Mowgli.h"

@implementation Mowgli

+ (id)mowgli
{
    Mowgli *mowgli = [Mowgli spriteNodeWithImageNamed:@"mowgli_0000"];
    mowgli.name = @"mowgli";
    mowgli.xScale = 0.2;
    mowgli.yScale = 0.2;
   // mowgli.position = CGPointMake(0, mowgli.size.height/2 + 52);
    
    mowgli.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:mowgli.size];
    
    //reference atlas
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"mowgli"];
    
    //name of files
    NSArray *listOfFiles = [atlas textureNames];
    
    //sortieren
    NSArray *sortedNames = [listOfFiles sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    //array to hold image textures
    NSMutableArray *mowgliTextures = [NSMutableArray array];
    
    for(NSString *filename in sortedNames){
        SKTexture *texture = [atlas textureNamed:filename];
        [mowgliTextures addObject:texture];
    }
    SKAction *step = [SKAction moveByX:40 y:0 duration:0.2];
    //SKAction *moveRight = [SKAction repeatActionForever:step];
    SKAction *run =[SKAction animateWithTextures:mowgliTextures timePerFrame:0.05];
    SKAction *repeater = [SKAction repeatActionForever:run];

    SKAction *actions = [SKAction group:@[repeater,
                                             moveRight]];
    
    [mowgli runAction:actions];

    return mowgli;
}

-(void)jump{
    [self.physicsBody applyImpulse:CGVectorMake(0, 150)];
}

@end
