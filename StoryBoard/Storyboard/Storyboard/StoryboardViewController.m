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
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Play Intro"])
    {
        NSString *move_path =[[NSBundle mainBundle] pathForResource:@"intro" ofType:@"m4v"];
        // Creating the player and playing the video
        NSURL *url = [NSURL fileURLWithPath:move_path];
        
        MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:moviePlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(introfinished)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
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
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"Play Intro"];
}

@end
