//
//  GameViewController.m
//  Flappy Yoshi
//
//  Created by Peter Wilde on 4/30/14.
//  Copyright (c) 2014 Peter Wilde. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController

-(IBAction)StartGame:(id)sender
{
    StartGame.hidden = YES;
    TunnelTop.hidden = NO;
    TunnelBottom.hidden = NO;
    
    AudioServicesPlaySystemSound(PlayFlySoundID);
    
    BirdMovement = [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(BirdMoving) userInfo:nil repeats:YES];
   
    [BirdHoverment invalidate];
    
    [self PlaceTunnels];
    
    TunnelMovement = [NSTimer scheduledTimerWithTimeInterval:0.0075 target:self selector:@selector(TunnelMoving) userInfo:nil repeats:YES];
    
    TopPlantMovement = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(TopPlantMoving) userInfo:nil repeats:YES];
    BottomPlantMovement = [NSTimer scheduledTimerWithTimeInterval:0.33 target:self selector:@selector(BottomPlantMoving) userInfo:nil repeats:YES];
}

-(void)PlaceTunnels
{
    RandomTopTunnelPosition = arc4random() %300;
    RandomTopTunnelPosition = RandomTopTunnelPosition - 200;
    RandomBottomTunnelPosition = RandomTopTunnelPosition + 655;
    
    TunnelTop.center = CGPointMake(340, RandomTopTunnelPosition);
    TunnelBottom.center = CGPointMake(340, RandomBottomTunnelPosition);
    
}

-(void)TunnelMoving
{
    TunnelTop.center = CGPointMake(TunnelTop.center.x - 1, TunnelTop.center.y);
    TunnelBottom.center = CGPointMake(TunnelBottom.center.x-1, TunnelBottom.center.y);
    if ( TunnelTop.center.x < -44 )
        [self PlaceTunnels];
    
    if ( TunnelTop.center.x == 45 )
        [self ScorePlus];
    
    if ( CGRectIntersectsRect(Bird.frame, TunnelTop.frame) ||
         CGRectIntersectsRect(Bird.frame, TunnelBottom.frame) ||
        CGRectIntersectsRect(Bird.frame, Bottom.frame) ||
        CGRectIntersectsRect(Bird.frame, Top.frame) )
        [self GameOver];
        
}

-(void)ScorePlus
{
    AudioServicesPlaySystemSound(PlayScoreSoundID);
    ++ScoreNumber;
    ScoreLabel.text = [NSString stringWithFormat:@"%i", ScoreNumber];
}

-(void)BirdHovering
{
    Bird.center = CGPointMake(Bird.center.x, Bird.center.y - BirdHover);
    
    if ( HoverUp == true )
    {
        Bird.image = [UIImage imageNamed:@"YoshiFly3.png"];
        BirdHover++;
        
        if ( BirdHover >= 5 )
        {
            HoverUp = false;
        }
    }
    
    
    else if ( HoverUp == false )
    {
        Bird.image = [UIImage imageNamed:@"YoshiFly1.png"];
        BirdHover--;
    
        if ( BirdHover <= -5 )
        {
            HoverUp = true;
        }
    }
}

-(void)BirdMoving
{
    Bird.center = CGPointMake(Bird.center.x, Bird.center.y - BirdFlight);
    
    BirdFlight = BirdFlight - 3;
    
    if ( BirdFlight < -15 )
        BirdFlight = -15;
    
    if ( BirdFlight > 0)
    {
        Bird.image = [UIImage imageNamed:@"YoshiFly2a.png"];
    }
    
    if ( BirdFlight < 0)
    {
        Bird.image = [UIImage imageNamed:@"YoshiFly1.png"];
    }
}

-(void)TopPlantMoving
{
    if (TopPlant.image == [UIImage imageNamed:@"piranha2au"])
    {
        TopPlant.image = [UIImage imageNamed:@"piranha2u"];
    }
    else
    {
        TopPlant.image = [UIImage imageNamed:@"piranha2au"];
    }
}
-(void)BottomPlantMoving
{
    if (BottomPlant.image == [UIImage imageNamed:@"piranha2a"])
    {
        BottomPlant.image = [UIImage imageNamed:@"piranha2"];
    }
    else
    {
        BottomPlant.image = [UIImage imageNamed:@"piranha2a"];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    BirdFlight = 21;
    AudioServicesPlaySystemSound(PlayFlySoundID);
}

-(void)GameOver
{
    AudioServicesPlaySystemSound(PlayDeathSoundID);
    
    if ( ScoreNumber > HighScore )
    {
        [[NSUserDefaults standardUserDefaults] setInteger:ScoreNumber forKey:@"HighScoreSaved"];
    }
    
    [TunnelMovement invalidate];
    [BirdMovement invalidate];
    
    ExitButton.hidden = NO;
    TunnelTop.hidden = YES;
    TunnelBottom.hidden = YES;
    Bird.hidden = YES;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AudioServicesPlaySystemSound(PlayGameEndID);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BirdHoverment = [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(BirdHovering) userInfo:nil repeats:YES];
    
    TunnelTop.hidden = YES;
    TunnelBottom.hidden = YES;
    
    ExitButton.hidden = YES;
    ScoreNumber = 0;
    
    HighScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScoreSaved"];
    
    NSURL *FlightURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"smw_yoshi_tongue" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)FlightURL, &PlayFlySoundID);
    NSURL *DeathURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"smw_yoshi_runs_away" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)DeathURL, &PlayDeathSoundID);
    NSURL *ScoreURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"smw_1-up" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)ScoreURL, &PlayScoreSoundID);
    NSURL *EndURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"smw_power_up_appears" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) EndURL, &PlayGameEndID);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
