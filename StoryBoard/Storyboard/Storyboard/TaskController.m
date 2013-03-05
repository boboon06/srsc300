//
//  TaskController.m
//  Storyboard
//
//  Created by sls38 on 12/12/12.
//  Copyright (c) 2012 sls37. All rights reserved.
//

#import "TaskController.h"

@interface TaskController ()

@end

@implementation TaskController

- (void) nextButtonAction:(id)sender {
    NSLog(@"Next Pressed");
    [self performSegueWithIdentifier:@"Next" sender:self ];
}

- (void)doneButtonAction:(id)sender {
    NSLog(@"Done Pressed");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)cancelButtonAction:(id)sender {
    NSLog(@"Cancel Pressed");
    // TODO: Find out if this is actually a nicer way of signifiying a cancel
    [self setDefaults];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

/**
 * Restore the stuff to it's default state, for the cancel button
 */
- (void)setDefaults {
    NSLog(@"setting defaults");
}

-(IBAction)returned:(UIStoryboardSegue *)segue {
    NSLog(@"Unwind Pressed");
    // TODO: Find out if this is actually a nicer way of signifiying a cancel
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
    
    UIBarButtonItem *myDoneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonAction:)];
    UIBarButtonItem *myCancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonAction:)];
    
    NSArray *myButtons = [[NSArray alloc] initWithObjects:myDoneButton, myCancelButton, nil];
    self.navigationItem.rightBarButtonItems = myButtons;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
