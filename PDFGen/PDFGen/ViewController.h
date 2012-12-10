//
//  ViewController.h
//  PDFGen
//
//  Created by jsh23 on 29/11/12.
//  Copyright (c) 2012 The University of Waikato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFgen.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <FacebookSDK/FacebookSDK.h>


@interface ViewController : UIViewController
@property (nonatomic, retain) IBOutlet UITextView *text_input;
@property (nonatomic, retain) IBOutlet UITextField *name;
@property (nonatomic, retain) IBOutlet UITextField *age;
@property (nonatomic, retain) IBOutlet UIImageView *rmimagebox;


-(IBAction)text_return:(id)sender;

// Mail stuff

-(void)showEmail;
-(void)displayComposerSheet;
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
// Facebook stuff
@property (strong, nonatomic) FBRequestConnection *fbconnection;

-(IBAction)facebook:(id)sender;

-(void)fbrequest;
-(void)fbpush;
- (void)requestCompleted:(FBRequestConnection *)connection
                 forFbID:(NSString *)fbID
                  result:(id)result
                   error:(NSError *)error;

//Debug.
-(void) writeToTextFile:(NSString*)text filename:(NSString*)filename;

@end
