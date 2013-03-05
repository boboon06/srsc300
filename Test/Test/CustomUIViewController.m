//
//  CustomUIViewController.m
//  Test
//
//  Created by sls38 on 20/02/13.
//  Copyright (c) 2013 sls37. All rights reserved.
//

#import "CustomUIViewController.h"

@interface CustomUIViewController ()

@end

@implementation CustomUIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"Loaded viewdidload controller");
    self.theText.text = [StaticInfo getPersonName];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [StaticInfo setPersonName:self.theText.text];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
