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
@property NSMutableArray *objects;
@end

@implementation GameData

+(id)data
{
    GameData *data = [GameData new];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = @"/mowglirun2.data";
    data.filePath = [path stringByAppendingString:fileName];
    return data;
}
-(void)save
{
    _valuesSaved=YES;
    //lädt zunächst die Alten Daten
    [self load];
    if(self.newNumber > self.highscore){
        //Highscore
        NSLog(@"ausgeführt1");
        self.lowestScore = self.middleScore;
        self.middleScore = self.highscore;
        self.highscore = self.newNumber;
    }else{
        if(self.middleScore < _newNumber && self.highscore >= self.newNumber){
        NSLog(@"ausgeführt2");
//Mitte
            self.lowestScore = self.middleScore;
            self.middleScore = _newNumber;
        }
        else{
            if(_newNumber <= _middleScore){
                    NSLog(@"ausgeführt3");
                    self.lowestScore = _newNumber;
            }
        }
    }
    //Neues Array
    NSNumber *highScore= [NSNumber numberWithInteger: self.highscore];
    NSNumber *middleScore = [NSNumber numberWithInteger: self.middleScore];
    NSNumber *lowestScore = [NSNumber numberWithInteger: self.lowestScore];
    
    //Speichern des Arrays
    NSMutableArray *newObjects = [NSMutableArray arrayWithObjects:highScore,middleScore,lowestScore, nil];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:newObjects];
    [data writeToFile:self.filePath atomically:YES];
    
}

-(void)load
{
    
    //Daten werden in highscoreObjects geladen
    NSData *data2 = [NSData dataWithContentsOfFile:self.filePath];
    NSMutableArray *highscoreObjects = [NSKeyedUnarchiver unarchiveObjectWithData:data2];

    
    NSNumber *highScore= highscoreObjects[0];
    NSNumber *middleScore = highscoreObjects[1];
    NSNumber *lowestScore = highscoreObjects[2];

    //Typecast zum intValue
    self.highscore =  highScore.intValue;
    self.middleScore = middleScore.intValue;
    self.lowestScore = lowestScore.intValue;
}

-(void)deleteAll{
    NSNumber *highScore= [NSNumber numberWithInteger: 0];
    NSNumber *middleScore = [NSNumber numberWithInteger: 0];
    NSNumber *lowestScore = [NSNumber numberWithInteger: 0];
    
    //Setzen des Default-Arrays[0,0,0] 
    NSMutableArray *newObjects = [NSMutableArray arrayWithObjects:highScore,middleScore,lowestScore, nil];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:newObjects];
    [data writeToFile:self.filePath atomically:YES];

}

@end
