//
//  InstructionsScene.m
//  Break Rush
//
//  Created by Peter Wilde on 9/16/14.
//  Copyright (c) 2014 Wild Thing Studios. All rights reserved.
//

#import "InstructionsScene.h"
#import "MenuScreen.h"

@implementation InstructionsScene


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.physicsWorld.speed = 0.85;
        
        appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        if (![appDelegate.highScoreUserDefault boolForKey:@"TenStarsSaved"]) {
            self.backgroundColor = [SKColor whiteColor];
        }
        if ([appDelegate.highScoreUserDefault boolForKey:@"TenStarsSaved"]) {
            self.backgroundColor = [SKColor blackColor];
        }
        
        //CMMotion code
        motionManager = [[CMMotionManager alloc] init];
        motionManager.accelerometerUpdateInterval  = 1.0/10.0; // Update at 10Hz
        if (motionManager.accelerometerAvailable) {
            NSLog(@"Accelerometer avaliable");
            queue = [NSOperationQueue currentQueue];
            [motionManager startAccelerometerUpdatesToQueue:queue                                            withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                            CMAcceleration acceleration = accelerometerData.acceleration;
                                                if (abs(acceleration.x) <= 1)accelX = acceleration.x;}];
        }
        
        // add a physics body to the scene to create edges
        // to see Apple reference on SKPhysicsBody class, see https://developer.apple.com/library/ios/documentation/SpriteKit/Reference/SKPhysicsBody_Ref/Reference/Reference.html#//apple_ref/occ/clm/SKPhysicsBody/bodyWithBodies:
        
        [self addPlayer:size];
        [self addIntro:size];
        
    }
    return self;
}

-(void) addPlayer:(CGSize)size {
    // set paddle component part sizes
    CGSize paddleSize = CGSizeMake(114/2, 22);
    CGSize smallPaddleSize = CGSizeMake(114/4, 22);
    SKColor *paddleColor;
    if (![appDelegate.highScoreUserDefault boolForKey:@"TenStarsSaved"]) {
        paddleColor = [SKColor blueColor];
    }
    if ([appDelegate.highScoreUserDefault boolForKey:@"TenStarsSaved"]) {
        paddleColor = [SKColor cyanColor];
    }
    
    SKSpriteNode *paddleLeft;
    SKSpriteNode *paddleRight;
    
    self.paddle = [SKSpriteNode spriteNodeWithColor:paddleColor size:CGSizeMake(paddleSize.width+2,paddleSize.height)];   // graphic is one pixel wider one each side to visually overlap with paddleLeft and paddleRight for seamless paddle
    self.paddle.position = CGPointMake(self.size.width/2, (self.size.height/2-55));
    self.paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(paddleSize.width, paddleSize.height)];   // physicsBody is original unaltered size
    self.paddle.physicsBody.dynamic = NO;
    self.paddle.physicsBody.friction = 0.0;
    [self addChild:self.paddle];
    
    paddleLeft = [SKSpriteNode spriteNodeWithColor:paddleColor size:smallPaddleSize];
    paddleLeft.position = CGPointMake(-(self.paddle.size.width/2 + smallPaddleSize.width/2),0);
    paddleLeft.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:smallPaddleSize];
    paddleLeft.physicsBody.dynamic = NO;
    paddleLeft.physicsBody.friction = 0.0;
    [self.paddle addChild:paddleLeft];
    
    paddleRight = [SKSpriteNode spriteNodeWithColor:paddleColor size:smallPaddleSize];
    paddleRight.position = CGPointMake((self.paddle.size.width/2 + smallPaddleSize.width/2),0);
    paddleRight.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:smallPaddleSize];
    paddleRight.physicsBody.dynamic = NO;
    paddleRight.physicsBody.friction = 0.0;
    [self.paddle addChild:paddleRight];
}

-(void)addIntro:(CGSize)size {
    SKColor *textColor;
    if (![appDelegate.highScoreUserDefault boolForKey:@"TenStarsSaved"]) {
        textColor = [SKColor blackColor];
    }
    if ([appDelegate.highScoreUserDefault boolForKey:@"TenStarsSaved"]) {
        textColor = [SKColor whiteColor];
    }
    
    self.instructionBackDrop = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:self.size];
    self.instructionBackDrop.position = CGPointMake(self.size.width/2, self.size.height/2);
    self.instructionBackDrop.alpha = 0.8;
    [self addChild:self.instructionBackDrop];
    NSInteger labelNodeCount = 12;
    SKLabelNode *labelNode[labelNodeCount];
    
    for (int i = 0; i < labelNodeCount; i++) {
        labelNode[i] = [SKLabelNode labelNodeWithFontNamed:[UIFont fontWithName:@"Alpha Beta BRK" size:12].fontName];
        labelNode[i].fontSize = 16;
        labelNode[i].fontColor = textColor;
        labelNode[i].horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        labelNode[i].position = CGPointMake(10, self.size.height-(i+2)*20);
    }
    labelNode[0].text = [NSString stringWithFormat:@"1. Hold phone relatively flat"];
    labelNode[1].text = [NSString stringWithFormat:@"2. Tilt phone left to move paddle left"];
    labelNode[2].text = [NSString stringWithFormat:@"3. Tilt phone right to move paddle right"];
    labelNode[3].text = [NSString stringWithFormat:@"4. Break the bricks with the ball"];
    labelNode[4].text = [NSString stringWithFormat:@"5. Keep the ball from hitting the"];
    labelNode[5].position = CGPointMake(20,labelNode[5].position.y);
    labelNode[5].text = [NSString stringWithFormat:@"bottom of the screen"];
    labelNode[6].text = [NSString stringWithFormat:@"6. Collect stars as you make"];
    labelNode[7].position = CGPointMake(20,labelNode[7].position.y);
    labelNode[7].text = [NSString stringWithFormat:@"new high scores"];
    labelNode[8].text = [NSString stringWithFormat:@"7. Collect 10 stars to unlock more"];
    labelNode[9].position = CGPointMake(20,labelNode[9].position.y);
    labelNode[9].text = [NSString stringWithFormat:@"color schemes"];
    labelNode[10].text = [NSString stringWithFormat:@"8. That's it! Good luck!"];
    labelNode[11].position = CGPointMake(self.size.width/2, 100);
    labelNode[11].horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    labelNode[11].text = [NSString stringWithFormat:@"touch screen to return to menu"];
    // Animate flicker in and out labelNode "touch screen to return"
    SKAction *fadeInLabel = [SKAction fadeInWithDuration:.0001];   // simply appear
    SKAction *fadeOutLabel = [SKAction fadeOutWithDuration:.0001];   // simply disappear
    SKAction *wait = [SKAction waitForDuration:1];
    SKAction *fadeInOut = [SKAction sequence:@[wait,fadeOutLabel,wait,fadeInLabel]];   // flash in and out
    SKAction *repeatFade = [SKAction repeatActionForever:fadeInOut];
    [labelNode[11] runAction:repeatFade];
    
    for (int i = 0; i < labelNodeCount; i++) {
        [self addChild:labelNode[i]];
    }
    
}

-(void)movePaddle:(CGSize)size {
    CGPoint newPosition = CGPointMake(self.paddle.position.x+(accelX*28),self.size.height/2-55);   // left and right x position only
    // stop the paddle from going too far left by checking for a position less than half of the width of the paddle
    if (newPosition.x < self.paddle.size.width * (3 / 2)) {
        newPosition.x = self.paddle.size.width * (3 / 2);
    }
    // stop the paddle from going too far right by checking for a position any further right than MyScene's width minus half of paddle's width
    if (newPosition.x > self.size.width - (self.paddle.size.width * (3 / 2))) {
        newPosition.x = self.size.width - (self.paddle.size.width * (3 / 2));
    }
    
    self.paddle.position = newPosition;
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    [self movePaddle:self.size];
    // update the paddle's x-position
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    MenuScreen *menu = [MenuScreen sceneWithSize:self.size];
    [self.view presentScene:menu];
    
}


@end
