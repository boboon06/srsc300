//
//  StoryboardViewController.m
//  Storyboard
//
//  Created by sls38 on 6/12/12.
//  Copyright (c) 2012 sls37. All rights reserved.
//

#import "StoryboardViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface StoryboardViewController ()

@end

@implementation StoryboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [StaticInfo read];
    
    UIImage *bgImage = [UIImage imageNamed:@"Landscape.jpg"];
//    UIImage *bgImage = [self imageWithImage : [UIImage imageNamed:@"Landscape.jpg"], CGSizeMake(200, 200)];
    UIColor *background = [[UIColor alloc] initWithPatternImage: bgImage];
    self.view.backgroundColor = background;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Play Intro"])
    {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:NO forKey:@"Play Intro"];
        NSString *move_path =[[NSBundle mainBundle] pathForResource:@"intro" ofType:@"m4v"];
        // Creating the player and playing the video
        NSURL *url = [NSURL fileURLWithPath:move_path];
        
        MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:moviePlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(introfinished)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(introfinished)
                                                 name:MPMoviePlayerDidExitFullscreenNotification object:nil];

    
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playIntro {
    NSString *move_path =[[NSBundle mainBundle] pathForResource:@"intro" ofType:@"m4v"];
    // Creating the player and playing the video
    NSURL *url = [NSURL fileURLWithPath:move_path];
    
    MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [self presentMoviePlayerViewControllerAnimated:moviePlayer];
}

-(void)introfinished
{
    // CHAIN CHAIN CHAIN
    aTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(timerFired:)
                                            userInfo:nil
                                             repeats:NO];
    NSLog(@"Finished Intro");
    
    
}

-(void)timerFired:(NSTimer *) theTimer
{
    NSLog(@"timerFired @ %@", [theTimer fireDate]);
    //[self performSegueWithIdentifier:@"InfoBox" sender:self ];
}

@end
