//
//  ViewController.m
//  PDFGen
//
//  Created by jsh23 on 29/11/12.
//  Copyright (c) 2012 The University of Waikato. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController
@synthesize text_input;
@synthesize name;
@synthesize rmimagebox;
@synthesize age;
@synthesize fbconnection;

@class PDFgen;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *home = NSHomeDirectory();
    NSString *imagepath = [home stringByAppendingString:@"/Documents/Screen Shot 2012-11-30 at 1.33.38 PM.png"];
    UIImage *imagedata = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagepath]];
    [rmimagebox setImage:[UIImage imageWithCGImage:[imagedata CGImage] scale: 1 orientation:UIImageOrientationUp ]];
    [FBSession.activeSession closeAndClearTokenInformation]; // Force a re-Auth on start. Device could be shared.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)text_return:(id)sender
{
    if (self.text_input.text.length > 0 && self.name.text.length > 0 && [age.text intValue] <= 100)
    {
        id gen = [PDFgen new];
        [gen createPDF:self.name.text pet:self.text_input.text age:age.text];
        [self showEmail];
    }
    else
    {
        int tmp_age = [age.text intValue];
        if (tmp_age > 100)
        {
            NSLog(@"ERROR: AGE OUT OF RANGE.");
            popup(@"Eeyep.", @"That's right, you're over a hundred years old... Real age please.");
        }
        if (self.text_input.text.length == 0)
        {
            NSLog(@"ERROR TEXT INPUT IS EMPTY");
            popup(@"Oh no.", @"You haven't wrote anything... Please answer the question!");
        }
        else if (self.name.text.length == 0)
        {
            NSLog(@"ERROR NAME FIELD IS EMPTY");
            popup(@"Very Funny.", @"You have a name. I know it! Please enter it in!");
        }
    }
}

// Mail shit.
-(void)showEmail
{
    UIAlertView *message = [UIAlertView alloc];   
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
            // In the final app, the App just wouldn't send. Due to this App for testing sending. It will!
            message = [message initWithTitle:@"Sorry"
                                                              message:@"Your device hasn't been set up to send emails. Please contact your System Administrator. App will now close."
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
    }
    else
    {
        message = [message initWithTitle:@"Sorry"
                                                          message:@"Your device doesn't support sending emails in-app. Please contact your System Administrator. App will now close."
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
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
    attach([home stringByAppendingString:@"/Documents/pdf_gen_out.pdf"], @"application/pdf", [name.text stringByAppendingString:@"'s Diploma.pdf"], picker);
    attach([home stringByAppendingString:@"/Documents/Screen Shot 2012-11-30 at 1.33.38 PM.png"], @"image/png", [name.text stringByAppendingString:@" Role Model.png"], picker);

    
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
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        exit(EXIT_FAILURE);
    }
}


// Facebook Bullshit!


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

- (void)fbrequest {
    // This was testing if my API Intergration was working.
    // Since it was better to PULL data from my Facebook. Than Cluttering my Friends stream.
    NSString *request = @"";
    NSArray *fbids = [request componentsSeparatedByString:@","];

    FBRequestConnection *newConnection = [[FBRequestConnection alloc] init];
    int querycount = 0;
    for (NSString *fbid in fbids) {
        FBRequestHandler handler =
        ^(FBRequestConnection *connection, id result, NSError *error) {
            [self requestCompleted:connection forFbID:fbid result:result error:error];
        };
        NSLog(@"Requesting \"%@\"", fbid);
        FBRequest *request = [[FBRequest alloc] initWithSession:FBSession.activeSession graphPath:fbid];
        [newConnection addRequest:request completionHandler:handler];
        querycount++;
        if (querycount > 30)
        {
            querycount = 0;
            [newConnection start];
            newConnection = [FBRequestConnection new];
        }
    }
    if (querycount != 0)
    {
    [newConnection start];
    }
}

- (void)requestCompleted:(FBRequestConnection *)connection
                 forFbID:fbID
                  result:(id)result
                   error:(NSError *)error {       
    NSString *text;
    if (error) {
        NSLog(@"ERROR: %@ CAUSE: %@", error.localizedDescription, error.localizedFailureReason);
    } else {
        NSDictionary *dictionary = (NSDictionary *)result;
        text = (NSString *)[dictionary objectForKey:@"name"];
        text = [text stringByAppendingFormat:@". Gender: %@", [[dictionary objectForKey:@"gender"] capitalizedString]];
        text = [text stringByAppendingFormat:@". Currently: %@", [[dictionary objectForKey:@"relationship_status"] capitalizedString]];
        text = [text stringByAppendingFormat:@". Birthday: %@", [[dictionary objectForKey:@"birthday"] capitalizedString]];
        if ([[dictionary objectForKey:@"gender"] isEqualToString:@"female"] && [[dictionary objectForKey:@"relationship_status"] isEqualToString:@"Single"])
        {
        NSLog(@"FB Result: %@", [NSString stringWithFormat:@"%@: %@",
                                 [fbID stringByTrimmingCharactersInSet:
                                  [NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                 text]);
            
            // I was totaly not finding who the Single women are on my Facebook Friends list.
            // Then sorting them into the hot or not categories.
            // To bad that if I theoretically was. I wouldn't have a chance with any of them.
            
            // It was purely String comparison testing. :Shiftyeyes:
        }

        
    }
}

-(void)fbpush
{
    id gen = [PDFgen new];
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    FBRequest *request1 = [FBRequest
                           requestForUploadPhoto:[UIImage imageWithContentsOfFile:[gen createJPG:self.name.text pet:self.text_input.text age:age.text]]];
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
