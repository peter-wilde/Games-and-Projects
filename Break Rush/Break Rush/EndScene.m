//
//  EndScene.m
//  Break Rush
//
//  Created by Peter Wilde on 9/8/14.
//  Copyright (c) 2014 Wild Thing Studios. All rights reserved.
//

#import "EndScene.h"
#import "MyScene.h"
#import "MenuScreen.h"
#import "AppDelegate.h"

@implementation EndScene
/*
 -(id)initWithSize:(CGSize)size withNewHighScore:(BOOL)highS withScoreAmount:(NSInteger)currentScore {
 if (self = [super initWithSize:size]) {
 
 SKAction *playGameOverSFX = [SKAction playSoundFileNamed:@"GameOverTone.wav" waitForCompletion:YES];
 [self runAction:playGameOverSFX];
 
 self.backgroundColor = [SKColor blackColor];
 
 SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
 label.text = @"GAME OVER";
 label.fontColor = [SKColor whiteColor];
 label.fontSize = 44;
 label.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
 [self addChild:label];
 
 // second label
 SKLabelNode *tryAgain = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
 tryAgain.text = @"tap to continue";
 tryAgain.fontColor = [SKColor whiteColor];
 tryAgain.fontSize = 24;
 tryAgain.position = CGPointMake(size.width/2, size.height/2-30);
 
 // animate with SKAction
 SKAction *fadeInLabel = [SKAction fadeInWithDuration:.0001];   // simply appear
 SKAction *fadeOutLabel = [SKAction fadeOutWithDuration:.0001];   // simply disappear
 SKAction *wait = [SKAction waitForDuration:1];
 SKAction *fadeInOut = [SKAction sequence:@[wait,fadeOutLabel,wait,fadeInLabel]];   // flash in and out
 SKAction *repeatFade = [SKAction repeatActionForever:fadeInOut];
 [tryAgain runAction:repeatFade];
 [self addChild:tryAgain];
 
 // current score label
 SKLabelNode *currentScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
 currentScoreLabel.text = [NSString stringWithFormat:@"Your score: %li", (long) currentScore];
 currentScoreLabel.fontSize = 20;
 currentScoreLabel.fontColor = [SKColor whiteColor];
 currentScoreLabel.position = CGPointMake(size.width/2, 150);
 [self addChild:currentScoreLabel];
 
 
 // high score label
 highScoreNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScoreSaved"];
 SKLabelNode *highScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
 highScoreLabel.text = [NSString stringWithFormat:@"HighScore: %li", (long)highScoreNumber];
 highScoreLabel.fontSize = 20;
 highScoreLabel.fontColor = [SKColor whiteColor];
 highScoreLabel.position = CGPointMake(size.width/2, 100);
 [self addChild:highScoreLabel];
 
 if (highS) {
 SKLabelNode *newHighScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura Mediu"];
 newHighScoreLabel.text = [NSString stringWithFormat:@"New high score!"];
 newHighScoreLabel.fontSize = 20;
 newHighScoreLabel.fontColor = [SKColor whiteColor];
 newHighScoreLabel.position = CGPointMake(size.width/2, 130);
 [self addChild:newHighScoreLabel];
 }
 }
 return self;
 }
 */
-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        /*if (!myQueue) {
            myQueue = dispatch_queue_create("com.endscene.gcdhighscore", NULL);
        }*/
        
        SKAction *playGameOverSFX = [SKAction playSoundFileNamed:@"GameOverTone.wav" waitForCompletion:YES];
        [self runAction:playGameOverSFX];
        customFont = [UIFont fontWithName:@"Alpha Beta BRK" size:12];
        
        self.backgroundColor = [SKColor blackColor];
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        label.text = @"GAME OVER";
        label.fontColor = [SKColor whiteColor];
        label.fontSize = 44;
        label.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        [self addChild:label];
        
        // second label
        SKLabelNode *tryAgain = [SKLabelNode labelNodeWithFontNamed:customFont.fontName];
        tryAgain.text = @"tap to continue";
        tryAgain.fontColor = [SKColor whiteColor];
        tryAgain.fontSize = 24;
        tryAgain.position = CGPointMake(size.width/2, size.height/2-30);
        
        // animate with SKAction
        SKAction *fadeInLabel = [SKAction fadeInWithDuration:.0001];   // simply appear
        SKAction *fadeOutLabel = [SKAction fadeOutWithDuration:.0001];   // simply disappear
        SKAction *wait = [SKAction waitForDuration:1];
        SKAction *fadeInOut = [SKAction sequence:@[wait,fadeOutLabel,wait,fadeInLabel]];   // flash in and out
        SKAction *repeatFade = [SKAction repeatActionForever:fadeInOut];
        [tryAgain runAction:repeatFade];
        [self addChild:tryAgain];
        
        // current score label
        SKLabelNode *currentScoreLabel = [SKLabelNode labelNodeWithFontNamed:customFont.fontName];
        currentScoreLabel.text = [NSString stringWithFormat:@"Your score: %li", (long) appDelegate.score];
        currentScoreLabel.fontSize = 20;
        currentScoreLabel.fontColor = [SKColor whiteColor];
        currentScoreLabel.position = CGPointMake(size.width/2, 150);
        [self addChild:currentScoreLabel];
        
        // Information on obtaining new high score
        if (appDelegate.score > appDelegate.oldHighScore) {
            SKLabelNode *newHighScoreLabel = [SKLabelNode labelNodeWithFontNamed:customFont.fontName];
            newHighScoreLabel.text = [NSString stringWithFormat:@"New high score!"];
            newHighScoreLabel.fontSize = 35;
            newHighScoreLabel.fontColor = [SKColor whiteColor];
            newHighScoreLabel.position = CGPointMake(size.width/2, self.size.height/2+100);
            [self addChild:newHighScoreLabel];
            
        }
        // high score label
        if (appDelegate.score <= appDelegate.oldHighScore){
            
            highScoreNumber = appDelegate.oldHighScore;
            SKLabelNode *highScoreLabel = [SKLabelNode labelNodeWithFontNamed:customFont.fontName];
            highScoreLabel.text = [NSString stringWithFormat:@"HighScore: %li", (long)highScoreNumber];
            highScoreLabel.fontSize = 20;
            highScoreLabel.fontColor = [SKColor whiteColor];
            highScoreLabel.position = CGPointMake(size.width/2, 100);
            [self addChild:highScoreLabel];
        }
        
        if (appDelegate.score > appDelegate.oldHighScore) {
            [appDelegate.highScoreUserDefault setInteger:appDelegate.score forKey:@"HighScoreSaved"];   // save new high score to data
        
            // Check flag for ten stars, check score for ten star acquisition, and post a notification that new color schemes have been unlocked
             if (![appDelegate.highScoreUserDefault boolForKey:@"TenStarsSaved"] && [appDelegate.highScoreUserDefault integerForKey:@"HighScoreSaved"] >= 100) {
                NSLog(@"Ten Stars collected!");
                NSInteger numLines = 3;
                SKLabelNode *newColorSchemesUnlocked[3];
                for (int i = 0; i < numLines; i++) {
                    newColorSchemesUnlocked[i] = [SKLabelNode labelNodeWithFontNamed:[UIFont fontWithName:@"Alpha Beta BRK" size:12].fontName];
                    newColorSchemesUnlocked[i].fontColor = [SKColor whiteColor];
                }
                newColorSchemesUnlocked[0].fontSize = 21;
                newColorSchemesUnlocked[1].fontSize = 19;
                newColorSchemesUnlocked[2].fontSize = 19;
            
                newColorSchemesUnlocked[0].position = CGPointMake(self.size.width/2, self.size.height-40);
                newColorSchemesUnlocked[0].text = [NSString stringWithFormat:@"New color schemes unlocked!"];
                newColorSchemesUnlocked[1].position = CGPointMake(self.size.width/2, self.size.height-60);
                newColorSchemesUnlocked[1].text = [NSString stringWithFormat:@"Keep playing to see"];
                newColorSchemesUnlocked[2].position = CGPointMake(self.size.width/2, self.size.height-80);
                newColorSchemesUnlocked[2].text = [NSString stringWithFormat:@"even more color schemes!"];
                for (int i = 0; i < numLines; i++) {
                    [self addChild:newColorSchemesUnlocked[i]];
                }
            // Done! Set flag for ten stars collected as raised forever: this if statement will not run again, but MyScene and MenuScene will have extra color schemes applied
                [appDelegate.highScoreUserDefault setBool:YES forKey:@"TenStarsSaved"];
            }
            SKLabelNode *highScoreLabel = [SKLabelNode labelNodeWithFontNamed:customFont.fontName];
            highScoreLabel.text = [NSString stringWithFormat:@"HighScore: %li", (long)appDelegate.score];
            highScoreLabel.fontSize = 20;
            highScoreLabel.fontColor = [SKColor whiteColor];
            highScoreLabel.position = CGPointMake(size.width/2, 100);
            [self addChild:highScoreLabel];
            appDelegate.oldHighScore = appDelegate.score;   // update oldHighScore now that we're done with it for this round
        }
        
        
    }   // end super init if statement
    return self;
}   // end method


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {   // continue to loop action as finger touches screen
        CGPoint location = [touch locationInNode:self];
        if (location.y > appDelegate.adBannerSize) {
            MenuScreen *firstScene = [MenuScreen sceneWithSize:self.size];
            [self.view presentScene:firstScene];
        }
    }
}

@end
