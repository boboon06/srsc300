//
//  CertificateController.h
//  Storyboard
//
//  Created by sls38 on 12/12/12.
//  Copyright (c) 2012 sls37. All rights reserved.
//

#import "TaskController.h"
#import <MessageUI/MessageUI.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>

@interface CertificateController : UIViewController
@property (nonatomic, retain) IBOutlet UIImageView *certview;

-(IBAction)email:(id)sender;
-(void)displayComposerSheet;
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
-(IBAction)facebook:(id)sender;
-(void)fbpush;
@end
