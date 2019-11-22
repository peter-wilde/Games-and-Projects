//
//  ViewController.h
//  Break Rush
//

//  Copyright (c) 2014 Wild Thing Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>
#import "AppDelegate.h"

@interface ViewController : UIViewController <ADBannerViewDelegate> {
    ADBannerView *adView;
    bool adOnTop;
    bool iadsBannerIsVisible;
    AppDelegate *appDelegate;
}

@end
