//
//  GameData.h
//  JungleBook
//
//  Created by Jo on 15.03.17.
//  Copyright © 2017 Johannes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject
@property int highscore;

+(id)data;
-(void)save;
-(void)load;
@end
