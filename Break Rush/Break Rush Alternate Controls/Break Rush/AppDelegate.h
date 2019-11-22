//
//  AppDelegate.h
//  Break Rush
//
//  Created by Peter Wilde on 9/8/14.
//  Copyright (c) 2014 Wild Thing Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger oldHighScore;       
@property (nonatomic) NSUserDefaults *highScoreUserDefault;
@property (nonatomic) BOOL didCollectTenStars;
//@property (nonatomic) NSUserDefaults *didCollectTenStars;
@property (nonatomic) NSInteger adBannerSize;
@end
