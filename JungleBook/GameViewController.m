//
//  GameViewController.m
//  JungleBook
//
//  Created by Jo on 13.03.17.
//  Copyright © 2017 Johannes. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "MenuScene.h"
#import "LevelScene.h"

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
    SKView *menuView = (SKView *) self.view;

  
    
    if(!menuView.scene){
        //Create and configure the scene
        SKScene *menu  = [MenuScene sceneWithSize:menuView.bounds.size];
        menu.scaleMode = SKSceneScaleModeAspectFill;
    
        //Present the Scene
        [menuView presentScene: menu];
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
