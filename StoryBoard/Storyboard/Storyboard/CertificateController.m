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
    [FBSession.activeSession closeAndClearTokenInformation]; // Force a re-Auth on start. Device could be shared. Plus it doesn't work if I don't have this.
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

#pragma mark Facebook Intergration
-(IBAction)facebook:(id)sender
{
    // Check to see whether we have already opened a session.
    if (FBSession.activeSession.isOpen) {
        [self fbpush]; // For some reason. This never gets called.
    } else {
        [FBSession openActiveSessionWithPublishPermissions:[@"publish_actions" componentsSeparatedByString:@","]
                                           defaultAudience:FBSessionDefaultAudienceFriends
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                                             NSLog(@"FBLogin Returned \"%u\"", status);
                                             if (error) {
                                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                 message:error.localizedDescription
                                                                                                delegate:nil
                                                                                       cancelButtonTitle:@"OK"
                                                                                       otherButtonTitles:nil];
                                                 [alert show];
                                             } else if (FB_ISSESSIONOPENWITHSTATE(status)) {
                                                 [self fbpush]; // I'm in! Begin Operation PSYCOPS.
                                             }
                                         }];
    }
}

-(void)fbpush
{
    NSString *home = NSHomeDirectory();
    NSString *imagepath = [home stringByAppendingString:@"/Documents/pdf_gen_out.jpg"];
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    FBRequest *request1 = [FBRequest
                           requestForUploadPhoto:[UIImage imageWithContentsOfFile:imagepath]];
    [connection addRequest:request1
         completionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSLog(@"POSTED DIPLOMA TO FACEBOOK!");
             popup(@"Success!", @"That's it! You have successfuly posted your diploma on your Facebook wall!");
         }
         else
         {
             popup(@"Oh no!", @"I don't know why... But I couldn't post that to your Facebook wall ;( Please try again.");
             NSLog(@"ERROR: %@", error.localizedDescription);
         }
     }
     ];
    /*
     //If we ever need to upload video... this is how.
     NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mov"]; // Or W/E the path to the video is.
     NSData *videoData = [NSData dataWithContentsOfFile:filePath];
     NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
     videoData, @"video.mov",
     @"video/quicktime", @"contentType",
     @"No School Acadamy. Who I like and Why?", @"title",
     @"I was asked who did I like, and what traits about them I liked. And this is what I said about them.", @"description",
     nil];
     [connection requestWithGraphPath:@"me/videos"
     andParams:params
     andHttpMethod:@"POST" // Post things EVERYWERE!
     andDelegate:self];
     */
    [connection start];
}
@end
