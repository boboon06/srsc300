//
//  TaskCompleted.m
//  Storyboard
//
//  Created by sls38 on 12/12/12.
//  Copyright (c) 2012 sls37. All rights reserved.
//

#import "TaskCompleted.h"

@interface TaskCompleted ()

@end

@class PDFgen;

@implementation TaskCompleted

- (IBAction)clickLearn:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.google.com/"]];
}

- (IBAction)clickFacebook:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://facebook.com/"]];
}

- (IBAction)gencert:(id)sender
{
    id gen = [PDFgen new];
    [gen setpagesize:CGRectMake(0,0,792,612)]; // Size of a A4 page
    [gen createPDF:nil];
    [gen createJPG:nil];
}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
