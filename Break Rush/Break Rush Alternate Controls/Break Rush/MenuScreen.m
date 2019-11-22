//
//  MenuScreen.m
//  Break Rush
//
//  Created by Peter Wilde on 9/8/14.
//  Copyright (c) 2014 Wild Thing Studios. All rights reserved.
//


#import "MenuScreen.h"
#import "MyScene.h"
#import "AppDelegate.h"
#import "InstructionsScene.h"


// Declare categories for bitmasking, unsigned ints are official type used for BitMask properties on SKPhysicsBody object
static const uint32_t ballCategory      = 1;        // position 00000000000000000000000000000001
static const uint32_t brickCategory     = 2;        // position 00000000000000000000000000000010
static const uint32_t paddleCategory    = 4;        // position 00000000000000000000000000000100
static const uint32_t edgeCategory      = 8;        // position 00000000000000000000000000001000
static const uint32_t bottomEdgeCategory    = 16;   // position 00000000000000000000000000010000
static const uint32_t outsideEdgeCategory   = 32;
static const uint32_t paddleLeftCategory    = 64;
static const uint32_t paddleRightCategory   = 128;


@implementation MenuScreen
-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        if (![appDelegate.highScoreUserDefault boolForKey:@"TenStarsSaved"]) {
            self.backgroundColor = [SKColor whiteColor];
        }
        if ([appDelegate.highScoreUserDefault boolForKey:@"TenStarsSaved"]) {
            self.backgroundColor = [SKColor blackColor];
        }
        // Copy finalized myScene logic for demo to play in background
        [self beginBackgroundAnim];
        [self drawLabelsAndButtons:size];
        }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // if user touched button, change scene
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    // if Start button touched, start transition to MyScene (the game)
    if ([node.name isEqualToString:@"startButtonArea"]) {
        NSLog(@"startButton pressed");
        MyScene *gameScene = [MyScene sceneWithSize:self.size];
        [self.view presentScene:gameScene];
    }
    
    // if instructions button touhed, change scene to InstructionScene
    if ([node.name isEqualToString:@"instructionsButtonArea"]) {
        NSLog(@"instructionsButton pressed");
        InstructionsScene *instructions = [InstructionsScene sceneWithSize:self.size];
        [self.view presentScene:instructions];
        NSLog(@"TRANSITION CODE TO INSTRUCTIONS SCENE");
    }
}

-(void)drawLabelsAndButtons:(CGSize)size {
    UIFont *customFont = [UIFont fontWithName:@"Alpha Beta BRK" size:12];
    SKColor *textColor;
    
    if (![appDelegate.highScoreUserDefault boolForKey:@"TenStarsSaved"]) {
        textColor = [SKColor blackColor];
    }
    if ([appDelegate.highScoreUserDefault boolForKey:@"TenStarsSaved"]) {
        textColor = [SKColor whiteColor];
    }

    SKLabelNode *title = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    title.text = @"BREAK RUSH";
    title.fontColor = textColor;
    title.fontSize = 44;
    title.position = CGPointMake (CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [self addChild:title];
    
    // high score label
    highScoreNumber = appDelegate.oldHighScore;
    SKLabelNode *highScoreLabel = [SKLabelNode labelNodeWithFontNamed:customFont.fontName];
    highScoreLabel.text = [NSString stringWithFormat:@"HighScore: %li", (long)highScoreNumber];
    highScoreLabel.fontSize = 20;
    highScoreLabel.fontColor = textColor;
    highScoreLabel.position = CGPointMake(self.size.width/2, 150);
    [self addChild:highScoreLabel];
    
    
    // Buttons
    SKSpriteNode *startButton = [SKSpriteNode spriteNodeWithImageNamed:@"Button"];
    startButton.scale = .7;
    startButton.position = CGPointMake(self.size.width/3, self.size.height/2-35);
    startButton.size = CGSizeMake(70, 30);
    startButtonArea = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(120, 100)];
    startButtonArea.name = [NSString stringWithFormat:@"startButtonArea"];
    SKLabelNode *startButtonLabel = [SKLabelNode labelNodeWithFontNamed:customFont.fontName];
    startButtonLabel.text = [NSString stringWithFormat:@"START"];
    startButtonLabel.fontSize = 16;
    startButtonLabel.fontColor = [SKColor blackColor];
    startButtonLabel.position = CGPointMake(0, -5);
    [self addChild:startButton];
    [startButton addChild:startButtonLabel];
    [startButton addChild:startButtonArea];
    
    SKSpriteNode *instructionsButton = [SKSpriteNode spriteNodeWithImageNamed:@"Button"];
    instructionsButton.name = [NSString stringWithFormat:@"instructionsButton"];
    instructionsButton.scale = .7;
    instructionsButton.position = CGPointMake(self.size.width*2/3, self.size.height/2-35);
    instructionsButton.size = CGSizeMake(100, 30);
    instructionsButtonArea = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(150, 100)];
    instructionsButtonArea.name = [NSString stringWithFormat:@"instructionsButtonArea"];
    SKLabelNode *instructionsButtonLabel = [SKLabelNode labelNodeWithFontNamed:customFont.fontName];
    instructionsButtonLabel.text = [NSString stringWithFormat:@"INSTRUCTIONS"];
    instructionsButtonLabel.fontSize = 16;
    instructionsButtonLabel.fontColor = [SKColor blackColor];
    instructionsButtonLabel.position = CGPointMake(0, -5);
    [self addChild:instructionsButton];
    [instructionsButton addChild:instructionsButtonLabel];
    [instructionsButton addChild:instructionsButtonArea];
    
    // Stars (based on high score: 10 points = 1 star, max 20 stars
    NSInteger numberStars = highScoreNumber/10;
    SKSpriteNode *stars[numberStars];
    for (int i = 0; i < numberStars; i++) {
        stars[i] = [SKSpriteNode spriteNodeWithImageNamed:@"GoldStar"];
        stars[i].scale = .176;
        if (i <= 9) {
            stars[i].position = CGPointMake((i+1)*29, self.size.height-16);
        }
        if (i > 9 && i < 20){
            stars[i].position = CGPointMake((i-9)*29, self.size.height-36);
        }
        [self addChild:stars[i]];
    }

}

/********************************************
 * The Background Game Logic                *
 * Copied directly from MyScene with        *
 * with:                                    *
 * - initial impulse set randomly           *
 * - no score                               *
 * - default level 1                        *
 * - no sound                               *
 * - no game over logic, only level repeat  *
 * - paddle follows x-position of ball      *
 ********************************************/


// contact has bodies and bitMasks contained as properties of itself, so they can be altered
-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    // degree to increase ball velocity
    float push = 0.1;
    
    // create a placeholder reference for the "non ball" object"
    SKPhysicsBody *notTheBall;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        notTheBall = contact.bodyB;
    } else {
        notTheBall = contact.bodyA;
    }
    if (notTheBall.categoryBitMask == brickCategory) {
        //[self runAction:_playBrickSFX];
        [notTheBall.node removeFromParent];
        brickCount = brickCount - 1;
        //appDelegate.score = appDelegate.score+1;
        //[self updateScore:self.size withSKColor:self.scoreLabel.fontColor];
    }
    
    if (notTheBall.categoryBitMask == paddleCategory){
         // apply small push upward
        [self.ball.physicsBody applyImpulse:CGVectorMake(0,2*push)];
    }
    if (notTheBall.categoryBitMask == paddleLeftCategory) {
        // if ball contacts the left part of the paddle, apply impulse leftwards
        [self runAction:_playPaddleSFX];
        [self.ball.physicsBody applyImpulse:CGVectorMake(-10*push,0)];
    }
    if (notTheBall.categoryBitMask == paddleRightCategory) {
        // if ball contacts the right part of the paddle, apply impulse rightwards
        [self runAction:_playPaddleSFX];
        [self.ball.physicsBody applyImpulse:CGVectorMake(10*push,0)];
    }
    if (notTheBall.categoryBitMask == bottomEdgeCategory | notTheBall.categoryBitMask == outsideEdgeCategory) {
        brickCount = 0;   // artificially repeat level by zeroing brickCount, forcing update method to repeat level
     }
    
    if (notTheBall.categoryBitMask == edgeCategory) {
        if (ballGoingUp && self.ballVector.dx > 0) {
            // if ball hits wall going right and up, push the ball upwards (and left a little), includes top wall
            [self.ball.physicsBody applyImpulse:CGVectorMake(-push/2,2*push)];
        }
        if (ballGoingUp && self.ballVector.dx < 0) {
            // if ball hits wall going left and up, push the ball upwards (and right a little), include top wall
            [self.ball.physicsBody applyImpulse:CGVectorMake(push/2,2*push)];
        }
        if (ballGoingDown && self.ballVector.dx > 0) {
            // if the ball hits the wall going right and down, push the ball downwards (and left a little)
            [self.ball.physicsBody applyImpulse:CGVectorMake(-push/2,-2*push)];
        }
        if (ballGoingDown && self.ballVector.dx < 0) {
            // if the ball hits the wall going left and down, push the ball downwards (and left a little)
            [self.ball.physicsBody applyImpulse:CGVectorMake(push/2,-2*push)];
        }
        if (ballGoingSideways && self.ballVector.dx > 0) {
            // if ball is going exactly sideways, apply slight force left and substancial force downwards
            [self.ball.physicsBody applyImpulse:CGVectorMake(-push/2, -4*push)];
        }
        if (ballGoingSideways && self.ballVector.dx < 0) {
            // counterpart to last if statement
            [self.ball.physicsBody applyImpulse:CGVectorMake(push/2, -4*push)];
        }
    }
}


- (void)addBall:(CGSize)size {
    
    // declare method variables
    levelMultiplier = 5;
    SKColor *ballColor;
    if (![appDelegate.highScoreUserDefault boolForKey:@"TenStarsSaved"]) {
        ballColor = [SKColor orangeColor];
    }
    if ([appDelegate.highScoreUserDefault boolForKey:@"TenStarsSaved"]) {
        ballColor = [SKColor yellowColor];
    }
    
    // create a new sprite node from an image: the ball!
    self.ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball3"];
    self.ball.scale = .8;   // scale the ball smaller: less mass, smaller radius
    self.ball.physicsBody.restitution = 0.0;   // Bounciness: take away no velocity on impacts
    // set ball vector to default to straight up
    self.ballVector = CGVectorMake(sin(arc4random())*levelMultiplier, levelMultiplier);
    // set collision detection to be precise to reduce instances of clipping
    self.ball.physicsBody.usesPreciseCollisionDetection = YES;
    
    // create a CGPoint for position, point of reference for the ball, initially set at half the width and height of the 'size' of the device :)
    CGPoint myPoint = CGPointMake(size.width/2, size.height/2);
    self.ball.position = myPoint;
    self.ball.color = ballColor;   // original image is white to be blended into any color using this line.
    self.ball.colorBlendFactor = 1.0;   // apply color blend with white image of ball
    
    // set physicsBody property
    self.ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.ball.frame.size.width/2];
    self.ball.physicsBody.friction = 0;   // friction when bodies touch, default 0.2
    self.ball.physicsBody.linearDamping = 0;   // slows down as move through space, default 0.1
    self.ball.physicsBody.restitution = 1.0f;   // bounciness, 0 - 1, 1 being super bouncy, f not necessary
    self.ball.physicsBody.categoryBitMask = ballCategory;   // Assign bitmask to ball category (default is all) :)
    self.ball.physicsBody.contactTestBitMask = brickCategory | paddleCategory | paddleLeftCategory | paddleRightCategory |bottomEdgeCategory | edgeCategory | outsideEdgeCategory;   // Set up a contact sensitive to brick contacts or paddle contacts
    
    // add the sprite node to the scene
    [self addChild:self.ball];
}

-(void) moveNewBall:(CGSize) size {
    
    // declare method variables
    __block CGFloat newAngle = 0;   // to make variable alterable
    
    CGFloat angle = -(M_PI/20)*(rand()/100);
    
    SKAction *rotateBall = [SKAction rotateByAngle:angle duration:.06];
    SKAction *report = [SKAction runBlock:^{
        newAngle = newAngle + angle;
        self.ballVector = CGVectorMake(-sin(newAngle)*levelMultiplier, abs(cos(newAngle)*levelMultiplier));
    }];
    SKAction *rotateReport = [SKAction sequence:@[rotateBall,report]];
    
    SKAction *continueRotating = [SKAction repeatAction:rotateReport count:10];
    
    [self.ball runAction:continueRotating];
    if (cos(newAngle)*levelMultiplier == 0) {
        [self.ball.physicsBody applyImpulse:CGVectorMake(self.ballVector.dx,levelMultiplier)];
    }
    if (cos(newAngle)*levelMultiplier != 0) {
        [self.ball.physicsBody applyImpulse:self.ballVector];
    }
    self.ball.physicsBody.allowsRotation = NO;
    
}

-(void) addBricks:(CGSize) size {
    // add the brick layer
    brickCount = 0;
    SKColor *brickColor;
    if (![appDelegate.highScoreUserDefault boolForKey:@"TenStarsSaved"]) {
        brickColor = [SKColor colorWithRed:203.0f/255.0f green:31.0f/255.0f blue:25.0f/255.0f alpha: 1.0];
    }
    if ([appDelegate.highScoreUserDefault boolForKey:@"TenStarsSaved"]) {
        brickColor = [SKColor greenColor];
    }
    for (int j = 0; j < 3; j++)
    {
        for (int i = 0; i < 6; i++) {
            SKSpriteNode *brick = [SKSpriteNode spriteNodeWithImageNamed:@"brick3"];
            brick.color = brickColor;
            brick.colorBlendFactor = 1.0;
            
            // add a static physics body
            brick.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:brick.frame.size];
            brick.physicsBody.dynamic = NO;
            brick.physicsBody.friction = 0.0;
            brick.scale = .7;
            brick.physicsBody.categoryBitMask = brickCategory;   // Assign category BitMask
            
            int xPos = size.width/7 * (i+1);
            int yPos = size.height - (60 + j * 40);
            brick.position = CGPointMake(xPos,yPos);
            
            [self addChild:brick];
            brickCount = brickCount + 1;
        }
        
    }
    
}

-(void) addBottomEdge:(CGSize) size {
    SKNode *bottomEdge = [SKNode node];   // generic node object
    bottomEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0,1) toPoint:CGPointMake(size.width,1)];
    bottomEdge.physicsBody.categoryBitMask = bottomEdgeCategory;
    [self addChild:bottomEdge];
}


// add edge outside of normal play area in case ball clips
-(void) addOutsideEdge:(CGSize) size {
    CGRect bigRect = CGRectMake(-80, -80, self.frame.size.width+160, self.frame.size.height+160);
    SKNode *outsideEdge = [SKNode node];
    outsideEdge.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:bigRect];
    outsideEdge.physicsBody.categoryBitMask = outsideEdgeCategory;
    [self addChild:outsideEdge];
}

-(void) addPlayer:(CGSize)size {
    // set paddle component part sizes
    SKColor *paddleColor;
    if (![appDelegate.highScoreUserDefault boolForKey:@"TenStarsSaved"]) {
        paddleColor = [SKColor blueColor];
    }
    if ([appDelegate.highScoreUserDefault boolForKey:@"TenStarsSaved"]) {
        paddleColor = [SKColor cyanColor];
    }
    
    CGSize paddleSize = CGSizeMake(114/2, 22);
    CGSize smallPaddleSize = CGSizeMake(114/4, 22);
    
    SKSpriteNode *paddleLeft;
    SKSpriteNode *paddleRight;
    
    self.paddle = [SKSpriteNode spriteNodeWithColor:paddleColor size:paddleSize];
    self.paddle.position = CGPointMake(size.width/2,100);
    self.paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:paddleSize];
    self.paddle.physicsBody.dynamic = NO;
    self.paddle.physicsBody.friction = 0.0;
    self.paddle.physicsBody.categoryBitMask = paddleCategory;
    [self addChild:self.paddle];
    
    paddleLeft = [SKSpriteNode spriteNodeWithColor:paddleColor size:smallPaddleSize];
    paddleLeft.position = CGPointMake(-(self.paddle.size.width/2 + smallPaddleSize.width/2),0);
    paddleLeft.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:smallPaddleSize];
    paddleLeft.physicsBody.dynamic = NO;
    paddleLeft.physicsBody.friction = 0.0;
    paddleLeft.physicsBody.categoryBitMask = paddleLeftCategory;
    [self.paddle addChild:paddleLeft];
    
    paddleRight = [SKSpriteNode spriteNodeWithColor:paddleColor size:smallPaddleSize];
    paddleRight.position = CGPointMake((self.paddle.size.width/2 + smallPaddleSize.width/2),0);
    paddleRight.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:smallPaddleSize];
    paddleRight.physicsBody.dynamic = NO;
    paddleRight.physicsBody.friction = 0.0;
    paddleRight.physicsBody.categoryBitMask = paddleRightCategory;
    [self.paddle addChild:paddleRight];
}


/////////////////////////
// Move to init method //
/////////////////////////

-(void)beginBackgroundAnim {
    /* Setup your scene here */
    
    gameBegan = YES;
    level = 1;
    self.physicsWorld.speed = 0.80;
    highScoreNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScoreSaved"];
    
    // add a physics body to the scene to create edges
    // to see Apple reference on SKPhysicsBody class, see https://developer.apple.com/library/ios/documentation/SpriteKit/Reference/SKPhysicsBody_Ref/Reference/Reference.html#//apple_ref/occ/clm/SKPhysicsBody/bodyWithBodies:
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = edgeCategory;
    self.physicsBody.friction = 0.0;
    
    // change gravity settings of the physics world to be much weaker, 1.6 m/s2 rather than 9.8
    self.physicsWorld.gravity = CGVectorMake(0,0);
    self.physicsWorld.contactDelegate = self;   // look into itself for the contact delegate. Otherwise didBeginContact will not fire
    
    [self addBall:self.size];
    [self addPlayer:self.size];
    [self addBricks:self.size];
    [self addBottomEdge:self.size];
    [self addOutsideEdge:self.size];
    
    [self.ball.physicsBody applyImpulse:self.ballVector];
    self.ball.physicsBody.allowsRotation = NO;
    
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    // Level repeat logic
    if (brickCount == 0) {
        
        [self removeAllChildren];
        [self addBricks:self.size];
        [self.ball removeFromParent];
        [self addBall:self.size];
        self.ball.color = [SKColor orangeColor];
        self.ball.position = CGPointMake(self.paddle.position.x, self.paddle.size.height+100+self.ball.size.height + 10);
        [self moveNewBall:self.size];
        [self drawLabelsAndButtons:self.size];
        [self addPlayer:self.size];
        NSLog(@"Level repeat");
    }
    if (gameBegan) {
        self.ballVector = self.ball.physicsBody.velocity;
        CGPoint location = self.ball.position;   // set variable 'location'
        CGPoint newPosition = CGPointMake(location.x,100);   // left and right x position only
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
    
    if (self.ballVector.dy < 0) {
        ballGoingSideways = NO;
        ballGoingUp = NO;
        ballGoingDown = YES;
    }
    if (self.ballVector.dy > 0) {
        ballGoingSideways = NO;
        ballGoingUp = YES;
        ballGoingDown = NO;
    }
    if (self.ballVector.dy == 0) {
        ballGoingSideways = YES;
        ballGoingUp = NO;
        ballGoingDown = NO;
    }
    
}

@end
