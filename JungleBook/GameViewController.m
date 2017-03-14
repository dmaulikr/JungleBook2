//
//  GameViewController.m
//  JungleBook
//
//  Created by Jo on 13.03.17.
//  Copyright © 2017 Johannes. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}


-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    //Configure the View
    SKView *gameView = (SKView *) self.view;
    gameView.showsDrawCount = YES;
    gameView.showsNodeCount = YES;
    gameView.showsFPS = YES;
    
    if(!gameView.scene){
        //Create and configure the scene
        SKScene *game = [GameScene sceneWithSize:gameView.bounds.size];
        game.scaleMode = SKSceneScaleModeAspectFill;
    
        //Present the Scene
        [gameView presentScene: game];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
