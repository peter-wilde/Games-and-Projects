//
//  MenuScreen.h
//  Break Rush
//
//  Created by Peter Wilde on 9/8/14.
//  Copyright (c) 2014 Wild Thing Studios. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AppDelegate.h"

@interface MenuScreen : SKScene <SKPhysicsContactDelegate>
{
    NSInteger highScoreNumber;
    BOOL gameBegan;
    BOOL ballGoingUp;
    BOOL ballGoingDown;
    BOOL ballGoingSideways;
    NSInteger brickCount;
    double level;
    CGFloat levelMultiplier;
    
    SKSpriteNode *startButtonArea;
    SKSpriteNode *instructionsButtonArea;
    
    AppDelegate *appDelegate;
    
    //AppDelegate *appDelegate;    // maybe unnecessary
}

@property (nonatomic) SKSpriteNode *paddle;   // introduce property "paddle" to MyScene
@property (nonatomic) SKAction *playPaddleSFX;   // declare an SKAction property to play paddle sfx. See init method for initialization
@property (nonatomic) SKAction *playEdgeSFX;
@property (nonatomic) SKAction *playBrickSFX;
@property (nonatomic) SKSpriteNode *ball;
@property (nonatomic) CGVector ballVector;
@property (nonatomic) SKLabelNode *scoreLabel;
@property (nonatomic) SKSpriteNode *instructionBackDrop;

@end
