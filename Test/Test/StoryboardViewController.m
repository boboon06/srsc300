//
//  StoryboardViewController.m
//  Test
//
//  Created by sls38 on 19/02/13.
//  Copyright (c) 2013 sls37. All rights reserved.
//

#import "StoryboardViewController.h"

@implementation StoryboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"viewDidLoad Called");
    [StaticInfo read];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
