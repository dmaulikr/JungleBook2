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
@property int lowestScore;
@property int middleScore;
@property int newNumber;
@property BOOL valuesSaved;
@property NSMutableArray *topScores;

+(id)data;
-(void)save;
-(void)load;
-(void)deleteAll;
@end
