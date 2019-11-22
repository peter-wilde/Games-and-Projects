//
//  InstructionsScene.h
//  Break Rush
//
//  Created by Peter Wilde on 9/16/14.
//  Copyright (c) 2014 Wild Thing Studios. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>
#import "AppDelegate.h"

@interface InstructionsScene : SKScene {

    CMMotionManager *motionManager;
    NSOperationQueue *queue;
    float accelX;
    AppDelegate *appDelegate;
}

@property (nonatomic) SKSpriteNode *paddle;
@property (nonatomic) SKSpriteNode *instructionBackDrop;

@end
