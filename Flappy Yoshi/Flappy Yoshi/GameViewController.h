//
//  GameViewController.h
//  Flappy Yoshi
//
//  Created by Peter Wilde on 4/30/14.
//  Copyright (c) 2014 Peter Wilde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

int BirdFlight;
int BirdHover = -5;
int RandomTopTunnelPosition;
int RandomBottomTunnelPosition;
int ScoreNumber;
NSInteger HighScore;

bool HoverUp = true;

@interface GameViewController : UIViewController
{
    IBOutlet UIImageView *Bird;
    IBOutlet UIButton *StartGame;
    IBOutlet UIImageView *TunnelTop;
    IBOutlet UIImageView *TunnelBottom;
    IBOutlet UIImageView *Top;
    IBOutlet UIImageView *Bottom;
    IBOutlet UIButton *ExitButton;
    IBOutlet UILabel *ScoreLabel;
    IBOutlet UIImageView *TopPlant;
    IBOutlet UIImageView *BottomPlant;
    
    NSTimer *BirdMovement;
    NSTimer *BirdHoverment;
    NSTimer *TunnelMovement;
    NSTimer *TopPlantMovement;
    NSTimer *BottomPlantMovement;

    SystemSoundID PlayFlySoundID;
    SystemSoundID PlayDeathSoundID;
    SystemSoundID PlayScoreSoundID;
    SystemSoundID PlayGameEndID;
}

-(IBAction)StartGame:(id)sender;
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
-(void)BirdMoving;
-(void)BirdHovering;
-(void)TunnelMoving;
-(void)PlaceTunnels;
-(void)ScorePlus;
-(void)GameOver;
-(void)TopPlantMoving;
-(void)BottomPlantMoving;

@end
