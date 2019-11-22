//
//  ViewController.h
//  Flappy Yoshi
//
//  Created by Peter Wilde on 4/30/14.
//  Copyright (c) 2014 Peter Wilde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

NSInteger HighScoreNumber;
int MBirdHover = -4;
BOOL MHoverUp = true;

@interface ViewController : UIViewController
{
    IBOutlet UIImageView *MBird;
    IBOutlet UILabel *HighScoreLabel;
    IBOutlet UIButton *StartButton;
    
    NSTimer *MBirdHoverment;
    
    SystemSoundID PlayGameStartID;
}

-(void)MBirdHovering;
//-(IBAction)StartButtonStart:(id)sender;
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
