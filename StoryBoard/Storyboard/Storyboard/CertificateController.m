//
//  CertificateController.m
//  Storyboard
//
//  Created by sls38 on 12/12/12.
//  Copyright (c) 2012 sls37. All rights reserved.
//

#import "CertificateController.h"

@interface CertificateController ()

@end

@implementation CertificateController
@synthesize certview;

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
    NSString *home = NSHomeDirectory();
    NSString *imagepath = [home stringByAppendingString:@"/Documents/pdf_gen_out.jpg"];
    UIImage *imagedata = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagepath]];
    CGFloat scale = certview.frame.size.width/imagedata.size.width;
    [certview setImage:[UIImage imageWithCGImage:[imagedata CGImage] scale: scale orientation:UIImageOrientationUp ]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)email:(id)sender
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            NSLog(@"CALLING MAILER!");
            [self displayComposerSheet]; // Mail that shit!
        }
        else
        {
            popup(@"Sorry", @"Your device hasn't been set up to send emails. Please contact your System Administrator. App will now close.");
        }
    }
    else
    {
        popup(@"Sorry", @"Your device doesn't support sending emails in-app. Please contact your System Administrator. App will now close.");
    }
}
-(void)displayComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = (id)self;
    
    [picker setSubject:@"SRS300 iPad APP: Lesson Results!"];
    
    
    // Set up recipients
    //NSArray *toRecipients = [NSArray arrayWithObject:@"jsh23@students.waikato.ac.nz"];
    //NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    //NSArray *bccRecipients = [NSArray arrayWithObject:@"videos@theboboon.com"];
    
    //Add then to the email.
    //[picker setToRecipients:toRecipients];
    //[picker setCcRecipients:ccRecipients];
    //[picker setBccRecipients:bccRecipients];
    
    // Attach ALL the things!
    NSString *home = NSHomeDirectory();
    attach([home stringByAppendingString:@"/Documents/pdf_gen_out.pdf"], @"application/pdf", [@"Joshua Holland" stringByAppendingString:@"'s Diploma.pdf"], picker);
    attach([home stringByAppendingString:@"/Documents/Screen Shot 2012-11-30 at 1.33.38 PM.png"], @"image/png", [@"Joshua Holland" stringByAppendingString:@" Role Model.png"], picker);
    
    
    // Fill out the email body text
    NSString *emailBody = @"OHMYGERD I've finished it!\nFinaly!"; // What else should I say?
    [picker setMessageBody:emailBody isHTML:NO];
    
    [self presentViewController:picker animated:YES completion:nil];
}


// Handles completion events.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"MAIL Result: Canceled. Not Saved as Draft");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"MAIL Result: Canceled. Saved as Draft");
            break;
        case MFMailComposeResultSent:
            NSLog(@"MAIL Result: sent");
            popup(@"Success!", @"Your message has been sent!");
            break;
        case MFMailComposeResultFailed:
            popup(@"I just don't know what went wrong!", @"Something went wrong. Derpy Hooves is sorry."); // Mail Agent probibly broke.
            NSLog(@"MAIL Result: Complete Failure");
            break;
        default:
            popup(@"Success!", @"Your message has been queued!");
            NSLog(@"MAIL Result: Delivery Pending/");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
void popup(NSString* title, NSString* body)
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:title
                                                      message:body
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}
void attach(NSString* path, NSString* MIME, NSString* name, MFMailComposeViewController *picker)
{
    NSData *myData = [NSData dataWithContentsOfFile:path];
    [picker addAttachmentData:myData mimeType:MIME fileName:name];
}
@end
