//
//  ViewController.h
//  NotFussed
//
//  Created by jsh23 on 28/11/12.
//  Copyright (c) 2012 The University of Waikato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFgen.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ViewController : UIViewController


// EMAILING CODE CAN NOT BE REMOVED FROM THIS WINDOW DUE TO SOME FUCKED UP VIEW CONTROLER ISSUE

@property (nonatomic, retain) IBOutlet UILabel *message;
@property (nonatomic, retain) NSString *attachments;

-(void)showPicker;
-(void)displayComposerSheet;
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;

@end
