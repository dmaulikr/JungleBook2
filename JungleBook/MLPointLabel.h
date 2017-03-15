//
//  MLPointLabel.h
//  JungleBook
//
//  Created by Jo on 15.03.17.
//  Copyright © 2017 Johannes. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MLPointLabel : SKLabelNode
@property int number;
+(id)pointsLabelWithFontNamed:(NSString *)fontName;
-(void)increment;
-(void)setPoints:(int)points;
-(void)reset;

@end
