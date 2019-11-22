//
//  AppDelegate.h
//  Flappy Yoshi
//
//  Created by Peter Wilde on 4/30/14.
//  Copyright (c) 2014 Peter Wilde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, AVAudioPlayerDelegate>
{
    AVAudioPlayer *audioPlayer1;
}

@property (strong, nonatomic) UIWindow *window;

@end
