//
//  MLWorldGenerator.h
//  JungleBook
//
//  Created by Jo on 15.03.17.
//  Copyright © 2017 Johannes. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MLWorldGenerator : SKNode
+(id)generatorWithWorld:(SKNode *) world;
-(void)generate;
-(void)populate;
@end
