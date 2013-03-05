//
//  MainViewer.m
//  Test
//
//  Created by sls38 on 19/02/13.
//  Copyright (c) 2013 sls37. All rights reserved.
//

#import "MainViewer.h"

@implementation MainViewer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    NSLog(@"Test");
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    NSString *newString = @"f";
    newString = [StaticInfo getPersonName];
    NSLog(@"%@", newString);
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)valueChanged:(id)sender {
    NSLog(@"value changed");
}

- (IBAction)actionValueChanged:(id)sender {
    NSLog(@"Value changed action");
}

- (IBAction)touchInside:(id)sender {
    NSLog(@"Touched inside");
}

- (IBAction)touchDownButton:(id)sender {
    NSLog(@"Touch down button");
}

- (IBAction)touchDownText:(id)sender {
    NSLog(@"Touch down text");
}

- (IBAction)editChanged:(UITextField*)sender {
}

- (IBAction)newEdit:(UITextField *)sender {
    NSLog(@"%@", [sender text]);
}
@end
