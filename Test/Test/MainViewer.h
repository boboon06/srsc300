//
//  MainViewer.h
//  Test
//
//  Created by sls38 on 19/02/13.
//  Copyright (c) 2013 sls37. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticInfo.h"

@interface MainViewer : UIView

- (IBAction)valueChanged:(id)sender;
- (IBAction)actionValueChanged:(id)sender;
- (IBAction)touchInside:(id)sender;
- (IBAction)touchDownButton:(id)sender;
- (IBAction)touchDownText:(id)sender;
- (IBAction)editChanged:(UITextField*)sender;
- (IBAction)newEdit:(UITextField *)sender;

@end
