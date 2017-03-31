//
//  Mowgli.m
//  JungleBook
//
//  Created by Jo on 14.03.17.
//  Copyright © 2017 Johannes. All rights reserved.
//

#import "Mowgli.h"

@interface Mowgli()
@property BOOL canJump;
@property int jumpLimit;

@end

@implementation Mowgli

//Durch bitweises Shiften, einfachere Schreibweise
static const uint32_t mowgliCategory = 0x1 <<0;
static const uint32_t obstacleCategory = 0x1 <<1;
static const uint32_t groundCategory = 0x1 <<2;

+ (id)mowgli
{
    //Mowgli Instanzierung
    Mowgli *mowgli = [Mowgli spriteNodeWithImageNamed:@"mowgli_0000"];
    mowgli.name = @"mowgli";
    mowgli.xScale = 0.2;
    mowgli.yScale = 0.2;
    
    mowgli.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:mowgli.size];
    mowgli.physicsBody.allowsRotation = NO;
    mowgli.physicsBody.categoryBitMask = mowgliCategory;
    
    //Testet auf Kontakt mit der Obstacle und Ground Category
    mowgli.physicsBody.contactTestBitMask = obstacleCategory | groundCategory;
    
    [mowgli run];
    return mowgli;
}

-(void)jump{
    
    //Mowgli soll zweimal jumpen können, also einen Doppelsprung ausführen können, allerdings etwas verbuggt
        if(_jumpLimit <2){
            [self.physicsBody applyImpulse:CGVectorMake(0, 160)];
            _jumpLimit++;
        }
}

//wenn Mowgli wieder auf dem Boden gelandet ist, darf dieser wieder Springen
-(void)land{
    _jumpLimit = 0;
}

-(void)start
{
    //bewegt sich nach Rechts
    SKAction *stepRight = [SKAction moveByX:1.0 y:0 duration:0.0029];
    SKAction *moveRight = [SKAction repeatActionForever:stepRight];
    [self runAction:moveRight];
}

-(void)crouch{
   //TO IMPLEMENT
}

//Mowgli bleibt stehen
-(void)stop{
    [self removeAllActions];
}

//ANimations

-(void) run{
    
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
    
    SKAction *run =[SKAction animateWithTextures:mowgliTextures timePerFrame:0.1];
    SKAction *repeater = [SKAction repeatActionForever:run];
    [self runAction:repeater];

}

@end
