//
//  MyScene.m
//  Break Rush
//
//  Created by Peter Wilde on 9/8/14.
//  Copyright (c) 2014 Wild Thing Studios. All rights reserved.
//
//   TO DO:
//          archive and submit to Apple!

#import "MyScene.h"
#import "EndScene.h"
#import "MenuScreen.h"
#import "AppDelegate.h"
#import <CoreMotion/CoreMotion.h>


@interface MyScene ()
{
    //*****************************//
    // class variable declarations //
    //*****************************//
    BOOL gameBegan;   // to signal game has started and movement actions are allowed to execute
    
    // flags to indicate which direction the ball is going to add impulses properly
    BOOL ballGoingUp;
    BOOL ballGoingDown;
    BOOL ballGoingSideways;
    
    BOOL tenStarsSaved;   // flag to store NSUserDefault boolean value from key, "TenStarsSaved"; activates extras if true
    
    NSInteger brickCount;   // track how many bricks are on screen, triggers level up when reaches zero
    
    double level;   // track level value
    
    CGFloat levelMultiplier;   // multiplier set to a constant by game designer
    
    NSInteger highScoreNumber;   // temporary holder of NSUserDefault integer value from key "HighScoreSaved"
    
    CGFloat paddlePosition;   //
    
    UIFont *customFont;   // hold custom font to apply to text
    
    SKSpriteNode *arrow;   // ball's child, arrow
    
    uint32_t oldRandom;   // stores old random value to persist through level ups, prevent random number from being the same level twice in a row
    
    CMMotionManager *motionManager;   // motion manager for accelerometer object
    NSOperationQueue *queue;   // for motion manager use
    CGFloat accelX;   // for motion manager use to pass to paddle's position
                        //UPDATE 11/2/19: Adjusting for touch to dictate position
    
    AppDelegate *appDelegate;   // appDelegate object to call from shared application delegate
    
}

//************************//
//Property declarations   //
//************************//


@property (nonatomic) SKSpriteNode *paddle;   // introduce property "paddle" to MyScene
@property (nonatomic) SKAction *playPaddleSFX;   // declare an SKAction property to play paddle sfx. See init method for initialization
@property (nonatomic) SKAction *playEdgeSFX;
@property (nonatomic) SKAction *playBrickSFX;
@property (nonatomic) SKSpriteNode *ball;
@property (nonatomic) CGVector ballVector;
@property (nonatomic) SKLabelNode *scoreLabel;
@property (nonatomic) SKSpriteNode *instructionBackDrop;

@end

// Declare categories for bitmasking, unsigned ints are official type used for BitMask properties on SKPhysicsBody object
static const uint32_t ballCategory      = 1;        // position 00000000000000000000000000000001
static const uint32_t brickCategory     = 2;        // position 00000000000000000000000000000010
static const uint32_t paddleCategory    = 4;        // position 00000000000000000000000000000100
static const uint32_t edgeCategory      = 8;        // position 00000000000000000000000000001000
static const uint32_t bottomEdgeCategory    = 16;   // position 00000000000000000000000000010000
static const uint32_t outsideEdgeCategory   = 32;
static const uint32_t paddleLeftCategory    = 64;
static const uint32_t paddleRightCategory   = 128;

/* alternatively, using bitwise operators! Hexadecimal notation, << operator moves flipped bit the specified amount to the left
 static const uint32_t ballCategory  = 0x1;        // position 00000000000000000000000000000001
 static const uint32_t brickCategory = 0x1 << 1;   // position 00000000000000000000000000000010
 static const uint32_t paddleCategory = 0x1 << 2;  // position 00000000000000000000000000000100
 static const uint32_t edgeCategory   = 0x1 << 3;  // position 00000000000000000000000000001000
 */

@implementation MyScene


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
        [self runAction:_playBrickSFX];
        [notTheBall.node removeFromParent];
        brickCount = brickCount - 1;
        appDelegate.score = appDelegate.score+1;
        [self updateScore:self.size];
    }
    
    if (notTheBall.categoryBitMask == paddleCategory){
        [self runAction:_playPaddleSFX];   // doesn't really matter which node runs the action, have the scene do it. Add a _ for instance variable. Initialized in init method
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
        // game over logic for either bottom of the screen or off-screan border for clipping
        EndScene *end = [EndScene sceneWithSize:self.size];
        [self.view presentScene:end];
        
    }
    
    if (notTheBall.categoryBitMask == edgeCategory) {
        [self runAction:_playEdgeSFX];
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
            // counterpart to last if
            [self.ball.physicsBody applyImpulse:CGVectorMake(push/2, -4*push)];
        }
    }
}


- (void)addBall:(CGSize)size ofType:(int)type{   // types:
                                                 // 1 = default,
                                                 // 2 = pinball image,
                                                 // 3 = add star,
                                                 // 4 = bowlingBall
    
    __block CGFloat newAngle = 0;   // to make variable alterable, add '__block'
    levelMultiplier = 5;
    CGFloat angle = -M_PI/20;
    SKColor *ballColor;
    if (!tenStarsSaved) {
        ballColor = [SKColor orangeColor];
    }
    if (tenStarsSaved) {
        ballColor = [SKColor yellowColor];
    }
    
    // create a new sprite node from an image: the white ball!
    if (type == 1) {
        self.ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball3"];
        self.ball.scale = .8;   // scale the ball smaller: less mass, smaller radius
        self.ball.color = ballColor;   // original image is white to be blended into any color using this line.
        self.ball.colorBlendFactor = 1.0;   // apply color blend with white image of ball
    }
    else if (type == 2) {   // image: pinball
        self.ball = [SKSpriteNode spriteNodeWithImageNamed:@"pinball"];
        self.ball.scale = .45;
    }
    else if (type == 3) {   // image: ball, with GoldStar on it
        self.ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball3"];
        self.ball.scale = .8;
        self.ball.color = ballColor;
        self.ball.colorBlendFactor = 1.0;
        SKSpriteNode *star = [SKSpriteNode spriteNodeWithImageNamed:@"GoldStar"];
        star.scale = .2;
        [self.ball addChild:star];
    }
    else if (type == 4) {
        self.ball = [SKSpriteNode spriteNodeWithImageNamed:@"bowlingBall"];
        self.ball.scale = .27;
    }
    self.ball.physicsBody.restitution = 0.0;   // Bounciness: take away no velocity on impacts
    // set ball vector to default to straight up
    self.ballVector = CGVectorMake(0, levelMultiplier);
    // set collision detection to be precise to reduce instances of clipping
    self.ball.physicsBody.usesPreciseCollisionDetection = YES;
    
    // create a CGPoint for position, point of reference for the ball, initially set at half the width and height of the 'size' of the device :)
    CGPoint myPoint = CGPointMake(size.width/2, size.height/2);
    self.ball.position = myPoint;
    
    // set physicsBody property
    self.ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.ball.frame.size.width/2];
    self.ball.physicsBody.friction = 0;   // friction when bodies touch, default 0.2
    self.ball.physicsBody.linearDamping = 0;   // slows down as move through space, default 0.1
    self.ball.physicsBody.restitution = 1.0f;   // bounciness, 0 - 1, 1 being super bouncy, f not necessary
    self.ball.physicsBody.categoryBitMask = ballCategory;   // Assign bitmask to ball category (default is all) :)
    self.ball.physicsBody.contactTestBitMask = brickCategory | paddleCategory | paddleLeftCategory | paddleRightCategory |bottomEdgeCategory | edgeCategory | outsideEdgeCategory;   // Set up a contact sensitive to brick contacts or paddle contacts
    // To make a texture for animation, use the following code:
    
    
    // add the sprite node to the scene
    [self addChild:self.ball];
    if(!gameBegan) {
        SKColor *arrowColor;
        if (!tenStarsSaved) {
            arrowColor = [SKColor blackColor];
        }
        if (tenStarsSaved) {
            arrowColor = [SKColor whiteColor];
        }
        arrow = [SKSpriteNode spriteNodeWithImageNamed:@"Arrow4"];
        arrow.scale = .5;
        arrow.color = arrowColor;
        arrow.colorBlendFactor = 1.0;
        arrow.position = CGPointMake(0, self.ball.size.height/2 + arrow.size.height/2);
        [self.ball addChild:arrow];
        
        SKAction *rotateArrow = [SKAction rotateByAngle:angle duration:.06];
        SKAction *report = [SKAction runBlock:^{
            newAngle = newAngle + angle;
            self.ballVector = CGVectorMake(-sin(newAngle)*levelMultiplier, cos(newAngle)*levelMultiplier);   // multiplier to be increased as level increases
        }];
        SKAction *rotateReport = [SKAction sequence:@[rotateArrow,report]];
        
        SKAction *continueRotating = [SKAction repeatActionForever:rotateReport];
        [self.ball runAction:continueRotating];
    }
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
    if (!tenStarsSaved) {
        brickColor = [SKColor colorWithRed:203.0f/255.0f green:31.0f/255.0f blue:25.0f/255.0f alpha: 1.0];
    }
    if (tenStarsSaved) {
        brickColor = [SKColor greenColor];
    }
    for (int j = 0; j < 3; j++)   // 3
    {
        for (int i = 0; i < 6; i++) {   // 6
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

-(void) addBricks:(CGSize) size withRedFloat:(CGFloat)red withGreenFloat:(CGFloat)green withBlueFloat:(CGFloat)blue{
    // add the brick layer
    brickCount = 0;
    for (int j = 0; j < 3; j++)   // 3
    {
        for (int i = 0; i < 6; i++) {   // 6
            SKSpriteNode *brick = [SKSpriteNode spriteNodeWithImageNamed:@"brick3"];
            brick.color = [SKColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha: 1.0];
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

-(void)addBricksWithRainbow:(CGSize)size {
    brickCount = 0;
    SKColor *colors[7] = {[SKColor redColor], [SKColor orangeColor], [SKColor yellowColor],                        [SKColor greenColor], [SKColor blueColor], [SKColor magentaColor], [SKColor purpleColor]};
    int colorCount = 0;
    for (int j = 0; j < 3; j++)   // 3 rows
    {
        for (int i = 0; i < 6; i++) {   // 6 columns
            SKSpriteNode *brick = [SKSpriteNode spriteNodeWithImageNamed:@"brick3"];
            brick.color = colors[colorCount];
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
            if (colorCount < 6) {
                colorCount++;
            }
            else if (colorCount >=6) {
                colorCount = 0;
            }
        }
        
    }
}
-(void)addBricksWithRealBricks:(CGSize)size ofType:(NSInteger) type{   //type must be 1 or 2
    brickCount = 0;
    bool brickLight = YES;
    SKSpriteNode *brick;
    
    for (int j = 0; j < 3; j++)   // 3
    {
        if (brickLight) {
            brickLight = NO;
        }
        else{
            brickLight = YES;
        }
        for (int i = 0; i < 6; i++) {   // 6
            if (type == 1) {
                if (brickLight) {
                    brick = [SKSpriteNode spriteNodeWithImageNamed:@"realBricks1a"];
                    brickLight = NO;
                }
                else {
                    brick = [SKSpriteNode spriteNodeWithImageNamed:@"realBricks1b"];
                    brickLight = YES;
                }
                brick.scale = .625;
            }
            else if (type == 2) {
                brick = [SKSpriteNode spriteNodeWithImageNamed:@"realBricks2"];
                brick.size = CGSizeMake(40,20);
            }
            // add a static physics body
            brick.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:brick.frame.size];
            brick.physicsBody.dynamic = NO;
            brick.physicsBody.friction = 0.0;
            //brick.scale = .7;
            brick.physicsBody.categoryBitMask = brickCategory;   // Assign category BitMask
            
            int xPos = size.width/7 * (i+1);
            int yPos = size.height - (60 + j * 40);
            brick.position = CGPointMake(xPos,yPos);
            
            [self addChild:brick];
            brickCount = brickCount+1;
        }
        
    }
}


-(void) addBottomEdge:(CGSize) size {
    SKNode *bottomEdge = [SKNode node];   // generic node object
    bottomEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0,1) toPoint:CGPointMake(size.width,1)];
    bottomEdge.physicsBody.categoryBitMask = bottomEdgeCategory;
    [self addChild:bottomEdge];
}


// add edge with a contact bitmask outside of normal play area in case ball clips off the screen
-(void) addOutsideEdge:(CGSize) size {
    CGRect bigRect = CGRectMake(-80, -80, self.frame.size.width+160, self.frame.size.height+160);
    SKNode *outsideEdge = [SKNode node];
    outsideEdge.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:bigRect];
    outsideEdge.physicsBody.categoryBitMask = outsideEdgeCategory;
    [self addChild:outsideEdge];
}


// set method for the touch of the screen
// touchesMoved to track where the touch is constantly.
// This is a deprecated method: control is accelerometer only
/*
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {   // continue to loop action as finger touches screen
        CGPoint location = [touch locationInNode:self];   // set variable 'location'
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
}
*/

-(void) addPlayer:(CGSize)size{
    // set paddle component part sizes
    SKColor *paddleColor;

    if (!tenStarsSaved){
        paddleColor = [SKColor blueColor];
    }
    if (tenStarsSaved){
        paddleColor = [SKColor cyanColor];
    }
    CGSize paddleSize = CGSizeMake(114/2, 22);
    CGSize smallPaddleSize = CGSizeMake(114/4, 22);
    
    SKSpriteNode *paddleLeft;
    SKSpriteNode *paddleRight;
    
    self.paddle = [SKSpriteNode spriteNodeWithColor:paddleColor size:paddleSize];
    self.paddle.position = CGPointMake(paddlePosition, 100);
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
-(void) addPlayer:(CGSize)size withSKColor: (SKColor *) color{
    // set paddle component part sizes
    CGSize paddleSize = CGSizeMake(114/2, 22);
    CGSize smallPaddleSize = CGSizeMake(114/4, 22);
    
    SKSpriteNode *paddleLeft;
    SKSpriteNode *paddleRight;
    
    self.paddle = [SKSpriteNode spriteNodeWithColor:color size:paddleSize];
    self.paddle.position = CGPointMake(paddlePosition, 100);
    self.paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:paddleSize];
    self.paddle.physicsBody.dynamic = NO;
    self.paddle.physicsBody.friction = 0.0;
    self.paddle.physicsBody.categoryBitMask = paddleCategory;
    [self addChild:self.paddle];
    
    paddleLeft = [SKSpriteNode spriteNodeWithColor:color size:smallPaddleSize];
    paddleLeft.position = CGPointMake(-(self.paddle.size.width/2 + smallPaddleSize.width/2),0);
    paddleLeft.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:smallPaddleSize];
    paddleLeft.physicsBody.dynamic = NO;
    paddleLeft.physicsBody.friction = 0.0;
    paddleLeft.physicsBody.categoryBitMask = paddleLeftCategory;
    [self.paddle addChild:paddleLeft];
    
    paddleRight = [SKSpriteNode spriteNodeWithColor:color size:smallPaddleSize];
    paddleRight.position = CGPointMake((self.paddle.size.width/2 + smallPaddleSize.width/2),0);
    paddleRight.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:smallPaddleSize];
    paddleRight.physicsBody.dynamic = NO;
    paddleRight.physicsBody.friction = 0.0;
    paddleRight.physicsBody.categoryBitMask = paddleRightCategory;
    [self.paddle addChild:paddleRight];
}

-(void) addScore:(CGSize)size {
    appDelegate.score = 0;
    SKColor *color;
    if (!tenStarsSaved) {
        color = [SKColor blackColor];
    }
    if (tenStarsSaved) {
        color = [SKColor whiteColor];
    }
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:customFont.fontName];
    self.scoreLabel.fontColor = color;
    self.scoreLabel.fontSize = 18;
    self.scoreLabel.position = CGPointMake(self.size.width/2, self.size.height-22);
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %li", (long)appDelegate.score];
    [self addChild:self.scoreLabel];
}


-(void)updateScore:(CGSize)size{
    
    SKColor *oldColor;
    oldColor = self.scoreLabel.fontColor;
    
    [self.scoreLabel removeFromParent];
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:customFont.fontName];
    self.scoreLabel.fontSize = 18;
    self.scoreLabel.position = CGPointMake(self.size.width/2, self.size.height-22);
    self.scoreLabel.fontColor = oldColor;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %li", (long)appDelegate.score];
    [self addChild:self.scoreLabel];
}

-(void)addIntro:(CGSize)size {
    SKColor *introColor;
    SKColor *textColor;
    if (!tenStarsSaved) {
        introColor = [SKColor whiteColor];
        textColor = [SKColor blackColor];
    }
    if (tenStarsSaved) {
        introColor = [SKColor clearColor];
        textColor = [SKColor whiteColor];
    }
    
    
    self.instructionBackDrop = [SKSpriteNode spriteNodeWithColor:introColor size:self.size];
    self.instructionBackDrop.position = CGPointMake(self.size.width/2, self.size.height/2);
    self.instructionBackDrop.alpha = 0.8;
    [self addChild:self.instructionBackDrop];
    
    SKLabelNode *instructionLabel = [SKLabelNode labelNodeWithFontNamed:customFont.fontName];
    instructionLabel.fontColor = textColor;
    instructionLabel.position = CGPointMake(0, -70);
    instructionLabel.fontSize = 18;
    instructionLabel.text = [NSString stringWithFormat:@"Tap screen to begin"];
    [self.instructionBackDrop addChild:instructionLabel];
    
}


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        gameBegan = NO;
        level = 1;
        self.physicsWorld.speed = 0.8;
        highScoreNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScoreSaved"];
        oldRandom = 1;
        //instanciate an AppDelegate object from which to call score
        appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        appDelegate.oldHighScore = highScoreNumber;
        paddlePosition = size.width/2;
        customFont = [UIFont fontWithName:@"Alpha Beta BRK" size:12];
        
        tenStarsSaved = [appDelegate.highScoreUserDefault boolForKey:@"TenStarsSaved"];
        
        //CMMotion code
        /*
        motionManager = [[CMMotionManager alloc] init];
        motionManager.accelerometerUpdateInterval  = 1.0/10.0; // Update at 10Hz
        if (motionManager.accelerometerAvailable) {
            NSLog(@"Accelerometer avaliable");
            queue = [NSOperationQueue currentQueue];
            [motionManager startAccelerometerUpdatesToQueue:queue
                                                withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                    CMAcceleration acceleration = accelerometerData.acceleration;
                                                    if (abs(acceleration.x) <= 1)accelX = acceleration.x;}];
        }
        */
        
        // set background and score font defaults
        SKColor *color;
        if (!tenStarsSaved) {
            self.backgroundColor = [SKColor whiteColor];
            color = [SKColor blackColor];
        }
        if (tenStarsSaved) {
            self.backgroundColor = [SKColor blackColor];
            color = [SKColor whiteColor];
        }
        self.scoreLabel.fontColor = color;
        
        self.playPaddleSFX = [SKAction playSoundFileNamed:@"Bump1.wav" waitForCompletion:NO];   // .caf files (core audio file) are standard for iOS, however it is being distorted for some reason in product test
        self.playBrickSFX = [SKAction playSoundFileNamed:@"BreakBrick3.wav" waitForCompletion:NO];
        self.playEdgeSFX = [SKAction playSoundFileNamed:@"WallBump11.wav" waitForCompletion:NO];
        
        
        
        // add a physics body to the scene to create edges
        // to see Apple reference on SKPhysicsBody class, see https://developer.apple.com/library/ios/documentation/SpriteKit/Reference/SKPhysicsBody_Ref/Reference/Reference.html#//apple_ref/occ/clm/SKPhysicsBody/bodyWithBodies:
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.categoryBitMask = edgeCategory;
        self.physicsBody.friction = 0.0;
        
        // change gravity settings of the physics world to be much weaker, 1.6 m/s2 rather than 9.8
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;   // look into itself for the contact delegate. Otherwise didBeginContact will not fire
        [self addBall:size ofType:1];
        [self addPlayer:size];
        [self addBricks:self.size];
        [self addBottomEdge:size];
        [self addOutsideEdge:size];
        [self addScore:size];
        [self addIntro:size];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!gameBegan) {
        for (UITouch *touch in touches) {   // continue to loop action as finger touches screen
            CGPoint location = [touch locationInNode:self];
            NSLog(@"location %f %f", location.x, location.y);
            if (location.y > appDelegate.adBannerSize) {   // Only begin game if the touch wasn't on the bottom of the screen where the iAd is (banner height is 32)
            
            [arrow removeFromParent];
            [self.instructionBackDrop removeFromParent];
            [self.ball.physicsBody applyImpulse:self.ballVector];
            self.ball.physicsBody.allowsRotation = NO;
            NSLog(@"x: %f, y: %f", self.ballVector.dx, self.ballVector.dy);
            gameBegan = YES;
            level = 1;
            }
        }
    }
    //UPDATE 11/2/19: code to populate accelX with touch position
    else {
        for (UITouch *touch in touches) {   // continue to loop action as finger touches screen
        CGPoint location = [touch locationInNode:self];
        NSLog(@"location %f %f", location.x, location.y);
            accelX = location.x;
        }
    }
}

//UPDATE 11/2/19: code to populate accelX with touch position during drag
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (gameBegan) {
        for (UITouch *touch in touches) {   // continue to loop action as finger touches screen
        CGPoint location = [touch locationInNode:self];
        NSLog(@"location %f %f", location.x, location.y);
            accelX = location.x;
        }
    }
}
-(void)movePaddle:(CGSize)size {
    //CGPoint newPosition = CGPointMake(self.paddle.position.x+(accelX*28),100);   // left and right x position only
    //UPDATE 11/2/19: moving with touch position only, no acceleration logic
    CGPoint newPosition = CGPointMake(accelX,100);
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
    
    // If appropriate, Level up!
    if (brickCount == 0) {
    [self levelUp:self.size];
    }
    // Sets flags for ball's direction of movement
    if (gameBegan)
        self.ballVector = self.ball.physicsBody.velocity;
    
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
    [self movePaddle:self.size];
    // update the paddle's x-position
    paddlePosition = self.paddle.position.x;
    
    //***************************//
    // CHEATING up to 120 points //
    // To be commented out       //
    // before publishing to the  //
    // Apple Store               //
    //***************************//
    /*
    if (appDelegate.score < 60) {
        u_int32_t random = arc4random_uniform(2);
        if (random == 0)
        self.paddle.position = CGPointMake(self.ball.position.x+30,100);
        if (random == 1)
        self.paddle.position = CGPointMake(self.ball.position.x-30,100);
        
    }
    */
}

-(void)levelUp:(CGSize)size {
        NSLog(@"Level up!");
        level = level + 1;
        if (level > 10) {
            level = 1;   // cycle through no more than ^ levels
        }
        if (self.physicsWorld.speed <= 1.8) {
            self.physicsWorld.speed = self.physicsWorld.speed + level/30.0;  // increase speed no more than ^ times base speed
        }
        u_int32_t random;
        if (!tenStarsSaved){
            random = arc4random_uniform(9)+1;   // generate a random number 1-10
            while (random == oldRandom) {   // keep rolling dice for new random scenario: don't repeat the same scenario twice in a row
                random = arc4random_uniform(9)+1;
            }
        }
        else if (tenStarsSaved){
            random = arc4random_uniform(19)+1;   // generate a random number 1-20
            while (random == oldRandom | random == 7 | random == 2) {   // keep rolling dice for new random scenario: don't repeat the same scenario twice in a row, or old schemes
                random = arc4random_uniform(19)+1;
            }
        }
        oldRandom = random;
    
        
        if (random == 1) {
            NSLog(@"Random scenario #1: default colors");
            [self addBricks:self.size];
            [self.ball removeFromParent];
            [self addBall:self.size ofType:1];
            self.ball.color = [SKColor orangeColor];
            self.backgroundColor = [SKColor whiteColor];
            self.scoreLabel.fontColor = [SKColor blackColor];   // set persistent font color for constant updates
            [self updateScore:self.size];
            [self.paddle removeFromParent];
            [self addPlayer:self.size withSKColor:[SKColor blueColor]];
        }
        
        else if (random == 2) {
            NSLog(@"Random scenario #2: neon colors");
            [self addBricks:self.size withRedFloat:255 withGreenFloat:255 withBlueFloat:0];
            [self.ball removeFromParent];
            [self addBall:self.size ofType:1];
            self.ball.color = [SKColor greenColor];
            self.backgroundColor = [SKColor blackColor];
            self.scoreLabel.fontColor = [SKColor whiteColor];   // set persistent font color for constant updates
            [self updateScore:self.size];
            [self.paddle removeFromParent];
            [self addPlayer:self.size withSKColor:[SKColor cyanColor]];
        }
        else if (random == 3) {
            NSLog(@"Random scenario #3: black actors");
            [self addBricks:self.size withRedFloat:0 withGreenFloat:0 withBlueFloat:0];
            [self.ball removeFromParent];
            [self addBall:self.size ofType:1];
            self.ball.color = [SKColor blackColor];
            self.backgroundColor = [SKColor whiteColor];
            self.scoreLabel.fontColor = [SKColor blackColor];   // set persistent font color for constant updates
            [self updateScore:self.size];
            [self.paddle removeFromParent];
            [self addPlayer:self.size withSKColor:[SKColor blackColor]];
        }
        else if (random == 4) {
            NSLog(@"Random scenario #4: black and white inversion");
            [self addBricks:self.size withRedFloat:255 withGreenFloat:255 withBlueFloat:255];
            [self.ball removeFromParent];
            [self addBall:self.size ofType:1];
            self.ball.color = [SKColor whiteColor];
            self.backgroundColor = [SKColor blackColor];
            self.scoreLabel.fontColor = [SKColor whiteColor];   // set persistent font color for constant updates
            [self updateScore:self.size];
            [self.paddle removeFromParent];
            [self addPlayer:self.size withSKColor:[SKColor whiteColor]];
        }
        else if (random == 5) {
            NSLog(@"Random scenario #5: hard to see bricks");
            [self addBricks:self.size withRedFloat:250 withGreenFloat:250 withBlueFloat:250];
            [self.ball removeFromParent];
            [self addBall:self.size ofType:1];
            self.ball.color = [SKColor orangeColor];
            self.backgroundColor = [SKColor whiteColor];
            self.scoreLabel.fontColor = [SKColor blackColor];   // set persistent font color for constant updates
            [self updateScore:self.size];
            [self.paddle removeFromParent];
            [self addPlayer:self.size withSKColor:[SKColor blueColor]];
        }
        else if (random == 6) {
            NSLog(@"Random scenario #6: blue screen of death");
            [self addBricks:self.size withRedFloat:255 withGreenFloat:255 withBlueFloat:255];
            [self.ball removeFromParent];
            [self addBall:self.size ofType:1];
            self.ball.color = [SKColor whiteColor];
            self.backgroundColor = [SKColor blueColor];
            self.scoreLabel.fontColor = [SKColor whiteColor];   // set persistent font color for constant updates
            [self updateScore:self.size];
            [self.paddle removeFromParent];
            [self addPlayer:self.size withSKColor:[SKColor colorWithWhite:0.99 alpha:1.0]];
        }
        else if (random == 7) {
            NSLog(@"Random scenario #7: change brick color only");
            [self addBricks:self.size withRedFloat:163 withGreenFloat:92 withBlueFloat:106];
            [self.ball removeFromParent];
            [self addBall:self.size ofType:1];
            self.ball.color = [SKColor orangeColor];
            self.backgroundColor = [SKColor whiteColor];
            self.scoreLabel.fontColor = [SKColor blackColor];   // set persistent font color for constant updates
            [self updateScore:self.size];
            [self.paddle removeFromParent];
            [self addPlayer:self.size withSKColor:[SKColor blueColor]];
        }
        
        else if (random == 8) {
            NSLog(@"Random scenario #8: swap ball and paddle color");
            [self addBricks:self.size withRedFloat:163 withGreenFloat:92 withBlueFloat:106];
            [self.ball removeFromParent];
            [self addBall:self.size ofType:1];
            self.ball.color = [SKColor blueColor];
            self.backgroundColor = [SKColor whiteColor];
            self.scoreLabel.fontColor = [SKColor blackColor];   // set persistent font color for constant updates
            [self updateScore:self.size];
            [self.paddle removeFromParent];
            [self addPlayer:self.size withSKColor:[SKColor orangeColor]];
        }
        else if (random == 9) {
            NSLog(@"Random scenario #9: GreyScale");
            [self addBricks:self.size withRedFloat:50 withGreenFloat:50 withBlueFloat:50];
            [self.ball removeFromParent];
            [self addBall:self.size ofType:1];
            self.ball.color = [SKColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
            self.backgroundColor = [SKColor whiteColor];
            self.scoreLabel.fontColor = [SKColor blackColor];   // set persistent font color for constant updates
            [self updateScore:self.size];
            [self.paddle removeFromParent];
            [self addPlayer:self.size withSKColor:[SKColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0]];
            
        }
        else if (random == 10) {
            NSLog(@"Random scenario #10: just another color");
            [self addBricks:self.size withRedFloat:205 withGreenFloat:89 withBlueFloat:12];    //burnt orange
            [self.ball removeFromParent];
            [self addBall:self.size ofType:1];
            self.ball.color = [SKColor colorWithRed:169.0f/255.0f green:59.0f/255.0f blue:182.0f/255.0f alpha:1.0];
            self.backgroundColor = [SKColor whiteColor];
            self.scoreLabel.fontColor = [SKColor blackColor];   // set persistent font color for constant updates
            [self updateScore:self.size];
            [self.paddle removeFromParent];
            [self addPlayer:self.size withSKColor:[SKColor colorWithRed:44.0f/255.0f green:174.0f/255.0f blue:154.0f/255.0f alpha:1.0]];
        }
        //**********************//
        //UNLOCKED LEVEL SCHEMES//
        //**********************//
        else if (random == 11) {
            NSLog(@"Random scenario #11: Rainbow Bricks");
            [self addBricksWithRainbow:self.size];
            [self.ball removeFromParent];
            [self addBall:self.size ofType:1];
            self.ball.color = [SKColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0];
            self.backgroundColor = [SKColor whiteColor];
            self.scoreLabel.fontColor = [SKColor blackColor];   // set persistent font color for constant updates
            [self updateScore:self.size];
            [self.paddle removeFromParent];
            [self addPlayer:self.size withSKColor:[SKColor blackColor]];
        }
        
        else if (random == 12) {
            NSLog(@"Random scenario #12: Real Bricks #1");
            [self addBricksWithRealBricks:self.size ofType:1];
            [self.ball removeFromParent];
            [self addBall:self.size ofType:1];
            self.ball.color = [SKColor orangeColor];
            self.backgroundColor = [SKColor whiteColor];
            self.scoreLabel.fontColor = [SKColor blackColor];   // set persistent font color for constant updates
            [self updateScore:self.size];
            [self.paddle removeFromParent];
            [self addPlayer:self.size withSKColor:[SKColor blueColor]];
            
        }
        
        else if (random == 13) {
            NSLog(@"Random scenario #13: Real Bricks #2");
            [self addBricksWithRealBricks:self.size ofType:2];
            [self.ball removeFromParent];
            [self addBall:self.size ofType:1];
            self.ball.color = [SKColor orangeColor];
            self.backgroundColor = [SKColor whiteColor];
            self.scoreLabel.fontColor = [SKColor blackColor];   // set persistent font color for constant updates
            [self updateScore:self.size];
            [self.paddle removeFromParent];
            [self addPlayer:self.size withSKColor:[SKColor blueColor]];

        }
        
        else if (random == 14) {
            NSLog(@"Random scenario #14: Real Bricks 1 and pinball");
            [self addBricksWithRealBricks:self.size ofType:1];
            [self.ball removeFromParent];
            [self addBall:self.size ofType:2];
            self.backgroundColor = [SKColor whiteColor];
            self.scoreLabel.fontColor = [SKColor blackColor];   // set persistent font color for constant updates
            [self updateScore:self.size];
            [self.paddle removeFromParent];
            [self addPlayer:self.size withSKColor:[SKColor blueColor]];

        }
        else if (random == 15) {
            NSLog(@"Random scenario #15: Pinball");
            [self addBricksWithRainbow:self.size];
            [self.ball removeFromParent];
            [self addBall:self.size ofType:2];
            self.backgroundColor = [SKColor whiteColor];
            self.scoreLabel.fontColor = [SKColor blackColor];   // set persistent font color for constant updates
            [self updateScore:self.size];
            [self.paddle removeFromParent];
            [self addPlayer:self.size withSKColor:[SKColor blueColor]];
        }
        
        else if (random == 16) {
            NSLog(@"Random scenario #16: GoldStar as ball with brick 2!");
            [self addBricksWithRealBricks:self.size ofType:2];
            [self.ball removeFromParent];
            [self addBall:self.size ofType:3];
            self.ball.color = [SKColor whiteColor];
            self.backgroundColor = [SKColor blackColor];
            self.scoreLabel.fontColor = [SKColor whiteColor];   // set persistent font color for constant updates
            [self updateScore:self.size];
            [self.paddle removeFromParent];
            [self addPlayer:self.size withSKColor:[SKColor cyanColor]];
        }
        
        else if (random == 17) {
            NSLog(@"Random scenario #17: GoldStar as ball with rainbow!");
            [self addBricksWithRainbow:self.size];
            [self.ball removeFromParent];
            [self addBall:self.size ofType:3];
            self.ball.color = [SKColor whiteColor];
            self.backgroundColor = [SKColor blackColor];
            self.scoreLabel.fontColor = [SKColor whiteColor];   // set persistent font color for constant updates
            [self updateScore:self.size];
            [self.paddle removeFromParent];
            [self addPlayer:self.size withSKColor:[SKColor cyanColor]];
        }
        else if (random == 18) {
            NSLog(@"Random scenario #18: bowlingBall as ball with rainbow!");
            [self addBricksWithRainbow:self.size];
            [self.ball removeFromParent];
            [self addBall:self.size ofType:4];
            self.backgroundColor = [SKColor whiteColor];
            self.scoreLabel.fontColor = [SKColor blackColor];   // set persistent font color for constant updates
            [self updateScore:self.size];
            [self.paddle removeFromParent];
            [self addPlayer:self.size withSKColor:[SKColor blueColor]];
        }
        else if (random == 19) {
            NSLog(@"Random scenario #19: Pinball and default colors");
            [self addBricks:self.size withRedFloat:203 withGreenFloat:31 withBlueFloat:25];
            [self.ball removeFromParent];
            [self addBall:self.size ofType:2];
            self.backgroundColor = [SKColor whiteColor];
            self.scoreLabel.fontColor = [SKColor blackColor];   // set persistent font color for constant updates
            [self updateScore:self.size];
            [self.paddle removeFromParent];
            [self addPlayer:self.size withSKColor:[SKColor blueColor]];
        }
        else if (random == 20) {
            NSLog(@"Random scenario #20: bowlingBall as ball and cool colors!");
            [self addBricks:self.size withRedFloat:46 withGreenFloat:35 withBlueFloat:163];
            [self.ball removeFromParent];
            [self addBall:self.size ofType:4];
            self.backgroundColor = [SKColor whiteColor];
            self.scoreLabel.fontColor = [SKColor blackColor];   // set persistent font color for constant updates
            [self updateScore:self.size];
            [self.paddle removeFromParent];
            [self addPlayer:self.size withSKColor:[SKColor greenColor]];
        }
        
        
        self.ball.position = CGPointMake(self.paddle.position.x, self.paddle.size.height+100+self.ball.size.height + 10);
        [self moveNewBall:self.size];
    
}


@end
