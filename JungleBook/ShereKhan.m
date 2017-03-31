//
//  ShereKhan.m
//  JungleBook
//
//  Created by Johannes  Kimmeyer on 21.03.17.
//  Copyright © 2017 Johannes. All rights reserved.
//

#import "ShereKhan.h"

@implementation ShereKhan
+ (id)tiger
{
    ShereKhan *tiger = [ShereKhan spriteNodeWithImageNamed:@"yxcyxc_0000"];
    tiger.name = @"tiger";
    tiger.xScale = 0.2;
    tiger.yScale = 0.2;    
    [tiger run];    
    return tiger;
}


-(void)start
{
    SKAction *stepRight = [SKAction moveByX:1.0 y:0 duration:0.0029];
    SKAction *moveRight = [SKAction repeatActionForever:stepRight];
    [self runAction:moveRight];
}

-(void)stop{
    [self removeAllActions];
}


//ANimations

-(void) run{
    //reference atlas
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"sherekhan"];
    
    //name of files
    NSArray *listOfFiles = [atlas textureNames];
    
    //sortieren
    NSArray *sortedNames = [listOfFiles sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    //array to hold image textures
    NSMutableArray *sherekhanTextures = [NSMutableArray array];
    
    for(NSString *filename in sortedNames){
        SKTexture *texture = [atlas textureNamed:filename];
        [sherekhanTextures addObject:texture];
    }
    
    SKAction *run =[SKAction animateWithTextures:sherekhanTextures timePerFrame:0.1];
    SKAction *repeater = [SKAction repeatActionForever:run];
    [self runAction:repeater];
    
}
@end

