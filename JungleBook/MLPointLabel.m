//
//  MLPointLabel.m
//  JungleBook
//
//  Created by Jo on 15.03.17.
//  Copyright © 2017 Johannes. All rights reserved.
//

#import "MLPointLabel.h"

@implementation MLPointLabel

+(id)pointsLabelWithFontNamed:(NSString *)fontName
{
    MLPointLabel *pointsLabel = [MLPointLabel labelNodeWithFontNamed:fontName];
    pointsLabel.text = @"0";
    pointsLabel.number = 0;
    return pointsLabel;
}

-(void)increment{
    self.number += 1;
    self.text =[NSString stringWithFormat:@"%i", self.number];
}

-(void)setPoints:(int)points
{
    self.number = points;
    self.text = [NSString stringWithFormat:@"%i", self.number];
}

-(void)reset
{
    self.number = 0;
    self.text = @"0";
}

@end
