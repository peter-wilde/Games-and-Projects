//
//  AppDelegate.m
//  Break Rush
//
//  Created by Peter Wilde on 9/8/14.
//  Copyright (c) 2014 Wild Thing Studios. All rights reserved.
//

#import "AppDelegate.h"
#import "Appirater.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.highScoreUserDefault = [NSUserDefaults standardUserDefaults];
    //self.didCollectTenStars = [NSUserDefaults standardUserDefaults];
    self.score = 0;
    self.oldHighScore = [self.highScoreUserDefault integerForKey:@"HighScoreSaved"];
    self.didCollectTenStars = [self.highScoreUserDefault boolForKey:@"TenStarsSaved"];
    self.adBannerSize = 50;   // standardized banner height for Apple iphone in portrait mode
    
    [Appirater setAppId:@"919057241"];     // <<- your apps id here
    [Appirater setDaysUntilPrompt:7];
    [Appirater setUsesUntilPrompt:3];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];                      // <<- set to yes to test it
    [Appirater appLaunched:YES];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end