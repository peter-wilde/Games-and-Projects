//
//  ViewController.m
//  Flappy Yoshi
//
//  Created by Peter Wilde on 4/30/14.
//  Copyright (c) 2014 Peter Wilde. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)MBirdHovering
{
    if ( MHoverUp == true )
    {
        MBird.image = [UIImage imageNamed:@"YoshiFly3.png"];
        MBirdHover++;
        
        if ( MBirdHover >= 5 )
        {
            MHoverUp = false;
        }
    }
    
    
    else if ( MHoverUp == false )
    {
        MBird.image = [UIImage imageNamed:@"YoshiFly1.png"];
        MBirdHover--;
        
        if ( MBirdHover <= -5 )
        {
            MHoverUp = true;
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AudioServicesPlaySystemSound(PlayGameStartID);
    //[self performSegueWithIdentifier:@"SegueNamedStart" sender:StartButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    MBirdHoverment = [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(MBirdHovering) userInfo:nil repeats:YES];
    
    HighScoreNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScoreSaved"];
    HighScoreLabel.text = [NSString stringWithFormat:@"HighScore: %li", (long)HighScoreNumber];
    
    NSURL *StartURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"smw_riding_yoshi" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)StartURL, &PlayGameStartID);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
