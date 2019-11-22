//
//  ViewController.m
//  Break Rush
//
//  Created by Peter Wilde on 9/8/14.
//  Copyright (c) 2014 Wild Thing Studios. All rights reserved.
//

#import "ViewController.h"
#import "MenuScreen.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    skView.showsPhysics = NO;
    // Create and configure the scene.
    SKScene * scene = [MenuScreen sceneWithSize:CGSizeMake(skView.frame.size.width, skView.frame.size.height)];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    
    adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    [adView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    adView.frame = CGRectOffset(adView.frame, 0, self.view.frame.size.height);
    adView.delegate = self;
    iadsBannerIsVisible = NO;
    [self.view addSubview:adView];
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

// iAd methods
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    NSLog(@"Banner view is beginning an ad action");
    BOOL shouldExecuteAction = YES; // your app implements this method
    if (!willLeave && shouldExecuteAction){
    // insert code here to suspend any services that might conflict with the advertisement, for example, you might pause the game with an NSNotification like this...
        
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PauseScene" object:nil]; //optional
        SKView *skView = (SKView *)self.view;
        skView.scene.paused = YES;
    }
    return shouldExecuteAction;
}

-(void) bannerViewActionDidFinish:(ADBannerView *)banner {
    NSLog(@"banner is done being fullscreen");
    //Unpause the game if you paused it previously.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UnPauseScene" object:nil]; //optional
    SKView *skView = (SKView *)self.view;
    skView.scene.paused = NO;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {   // when an iAd loads
    // Add a visible iAd banner
    
    if(!iadsBannerIsVisible) {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // banner is invisible now and moved out of the screen on 50 px
        banner.frame = CGRectOffset(banner.frame, 0, 0-banner.frame.size.height);
        [UIView commitAnimations];
        iadsBannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (iadsBannerIsVisible == YES) {
        
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // Assumes the banner view is placed at the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        [UIView commitAnimations];
        iadsBannerIsVisible = NO;
        
        NSLog(@"banner unavailable");
    }
}

@end
