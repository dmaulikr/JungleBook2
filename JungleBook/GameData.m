//
//  GameData.m
//  JungleBook
//
//  Created by Jo on 15.03.17.
//  Copyright © 2017 Johannes. All rights reserved.
//

#import "GameData.h"

@interface GameData ()
@property NSString *filePath;
@end

@implementation GameData

+(id)data
{
    GameData *data = [GameData new];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = @"archive.data";
    data.filePath = [path stringByAppendingString:fileName];
    return data;
}

-(void)save
{
    NSNumber *highscoreObject = [NSNumber numberWithInt:self.highscore];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:highscoreObject];
    [data writeToFile:self.filePath atomically:YES];
}

-(void)load
{
    NSData *data = [NSData dataWithContentsOfFile:self.filePath];
    NSNumber *highscoreObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.highscore = highscoreObject.intValue;
}

@end
