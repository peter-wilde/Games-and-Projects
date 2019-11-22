//
//  EndScene.h
//  Break Rush
//
//  Created by Peter Wilde on 9/8/14.
//  Copyright (c) 2014 Wild Thing Studios. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AppDelegate.h"

@interface EndScene : SKScene
{
    NSInteger highScoreNumber;
    AppDelegate *appDelegate;
    dispatch_queue_t myQueue;
    UIFont *customFont;
}

@property (nonatomic) BOOL high;


@end
