//
//  TaskTwo.m
//  Storyboard
//
//  Created by sls38 on 12/12/12.
//  Copyright (c) 2012 sls37. All rights reserved.
//

#import "TaskTwo.h"

@interface TaskTwo ()

@end

@implementation TaskTwo

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
    // Setting up the colour for button selection
    _selectedColour = [UIColor orangeColor];
    _orginalColour = [UIColor whiteColor];
    // Filling the btnState array with the required amount of bools
    UIButton *temp;
    for (int i = 0; i < sizeof(btnStates) - 1; i++) {
        btnStates[i] = NO;
    }
    temp = nil;
    //Setting it up so that a n amount of traits can be selected
    maxSelectedTraits = 3;
    [self updateTraitDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tfTraitEntered:(id)sender {
    UITextField *tF = (UITextField*) sender;
    if ([[tF text] isEqualToString:@""]) {
        btnStates[sizeof(btnStates) - 1 ] = NO;
    } else {
        int traitCount = 0;
        for(int i = 0; i < sizeof(btnStates);i++) {
            if (btnStates[i])
                traitCount++;
        }
        if (traitCount < maxSelectedTraits)
            btnStates[sizeof(btnStates) - 1] = YES;
    }
    [self updateTraitDisplay];
}

- (IBAction)btnTraitPressed:(id)sender {
    // Converting the sender to a button
    UIButton *btnPressed = (UIButton*) sender;
    
    // Getting the index of the _btnState array
    if (btnStates[btnPressed.tag] == YES) {
        btnStates[btnPressed.tag] = NO;
    } else {
        int traitCount = 0;
        UIButton *btn;
        for(btn in _traits) {
            if (btnStates[btn.tag] == YES)
                traitCount++;
        }
        if (btnStates[sizeof(btnStates) -1])
            traitCount++;
        if (traitCount < maxSelectedTraits)
            btnStates[btnPressed.tag] = YES;
    }
    
    // looping through the array to set the background colours
    // according to the state of the array
    if (btnStates[btnPressed.tag]) {
        [btnPressed setBackgroundColor:_selectedColour];
    } else {
        [btnPressed setBackgroundColor:_orginalColour];
    }
    
    [self updateTraitDisplay];
}

- (void)updateTraitDisplay {
    bool doUpdate = NO;
    for (int i = 0; i < sizeof(btnStates); i++) {
        if (btnStates[i]) {
            doUpdate = YES;
            break;
        }
    }
    if (doUpdate) {
        UIButton *btn;
        NSMutableString *traitsText = [[NSMutableString alloc] initWithString:@""];
        // Making the string with all the traits
        for(btn in _traits) {
            if (btnStates[btn.tag]) {
                NSString *temp = [NSString stringWithFormat:@"%@|",btn.titleLabel.text];
                [traitsText appendString:temp];
            }
        }
        //Checking for the user entered text
        if (btnStates[sizeof(btnStates) - 1]) {
            NSString *temp = [NSString stringWithFormat:@"%@|",_tfCustomTrait.text];
            [traitsText appendString:temp];
        }
        NSString *tempTraitsText = [traitsText substringToIndex:[traitsText length]-1];
        NSArray *sortingArray = [tempTraitsText componentsSeparatedByString:@"|"];
        sortingArray = [sortingArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        // Converting the array into a string the long way
        traitsText = [[NSMutableString alloc] initWithString:@""];
        for (int i = 0; i < [sortingArray count];i++) {
            [traitsText appendString:[NSString stringWithFormat:@"%@\r\n",[sortingArray objectAtIndex:i]]];
        }
        _traitDisplay.text = traitsText;
    } else {
        _traitDisplay.text = @"";
    }
}

@end
