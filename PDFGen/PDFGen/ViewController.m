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
    [FBSession.activeSession closeAndClearTokenInformation];
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
            [self displayComposerSheet];
        }
        else
        {
            message = [message initWithTitle:@"Sorry"
                                                              message:@"Your device hasn't been set up to send emails."
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
    }
    else
    {
        message = [message initWithTitle:@"Sorry"
                                                          message:@"Your device doesn't support sending emails in-app."
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
    NSArray *toRecipients = [NSArray arrayWithObject:@"jsh23@students.waikato.ac.nz"];
    //NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    //NSArray *bccRecipients = [NSArray arrayWithObject:@"videos@theboboon.com"];
    
    //Add then to the email.
    [picker setToRecipients:toRecipients];
    //[picker setCcRecipients:ccRecipients];
    //[picker setBccRecipients:bccRecipients];
    
    // Attach ALL the things!
    NSString *home = NSHomeDirectory();
    attach([home stringByAppendingString:@"/Documents/pdf_gen_out.pdf"], @"application/pdf", [name.text stringByAppendingString:@"'s Diploma.pdf"], picker);
    attach([home stringByAppendingString:@"/Documents/Screen Shot 2012-11-30 at 1.33.38 PM.png"], @"image/png", [name.text stringByAppendingString:@" Role Model.png"], picker);

    
    // Fill out the email body text
    NSString *emailBody = @"OHMYGERD I've finished it!\nFinaly!";
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
    // FBSample logic
    // Check to see whether we have already opened a session.
    if (FBSession.activeSession.isOpen) {
        // login is integrated with the send button -- so if open, we send
        NSLog(@"Facebook Logged in");
        //[self fbrequest];
    } else {
        NSLog(@"Facebook Not Logged in");
        [FBSession openActiveSessionWithPublishPermissions:[@"publish_actions" componentsSeparatedByString:@","]
         defaultAudience:FBSessionDefaultAudienceFriends
                                              allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState status,
                                                          NSError *error) {
                                          NSLog(@"FBLogin Returned \"%u\"", status);
                                          // if login fails for any reason, we alert
                                          if (error) {
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                              message:error.localizedDescription
                                                                                             delegate:nil
                                                                                    cancelButtonTitle:@"OK"
                                                                                    otherButtonTitles:nil];
                                              [alert show];
                                              // if otherwise we check to see if the session is open, an alternative to
                                              // to the FB_ISSESSIONOPENWITHSTATE helper-macro would be to check the isOpen
                                              // property of the session object; the macros are useful, however, for more
                                              // detailed state checking for FBSession objects
                                          } else if (FB_ISSESSIONOPENWITHSTATE(status)) {
                                              // send our requests if we successfully logged in
                                              //[self fbrequest];
                                              [self fbpush];
                                          }
                                      }];
    }
}
// FBSample logic
// Read the ids to request from textObjectID and generate a FBRequest
// object for each one.  Add these to the FBRequestConnection and
// then connect to Facebook to get results.  Store the FBRequestConnection
// in case we need to cancel it before it returns.
//
// When a request returns results, call requestComplete:result:error.
//
- (void)fbrequest {
    // extract the id's for which we will request the profile
    NSString *request = @"1220150977,100001650575332,100000202263149,1587736808,100000022841550,1002822061,1498093966,1190915752,669255834,1850316793,1348850863,100000144623492,562743721,100003050986582,1397499215,100001269642681,100000518410942,100003034864366,100000366157963,1434103987,1542074799,699059842,100000497254165,100000406801244,553079108,1427228282,1599320169,1065907340,1466179462,782979917,100000490394384,100000565153169,1195502962,100000151253733,100001364978712,740543516,621288725,1423760681,1008534015,100001141082952,1556354981,1818608947,679991516,100000561615020,100001220022869,1058441328,671916891,1385750421,100002324959387,690140428,100000095483902,100000469879527,1171601575,100001070898083,100001093847994,100000247518298,549029516,1738584301,100001905340718,100002241078860,100001962864246,100000904822046,1391385782,1280596305,100000746829588,100001025555197,1234663786,678096275,1170862484,100000052456720,687520388,1644858455,1298343016,810670402,757930520,100000026814808,1272796036,773860435,219400149,100002178611733,1416185848,627882736,100001146138200,100000090714943,1502739717,1349550892,100000426712293,100001024337319,100000291519429,1537029452,100000774664235,1350301618,817486305,1135545249,100000234396593,732292736,1172130794,1797061289,1460155400,543445811,100000843726949,100000895582218,1461254393";
    NSArray *fbids = [request componentsSeparatedByString:@","];
    
  
    // create the connection object
    FBRequestConnection *newConnection = [[FBRequestConnection alloc] init];
    
    // for each fbid in the array, we create a request object to fetch
    // the profile, along with a handler to respond to the results of the request
    int querycount = 0;
    for (NSString *fbid in fbids) {
        
        // create a handler block to handle the results of the request for fbid's profile
        FBRequestHandler handler =
        ^(FBRequestConnection *connection, id result, NSError *error) {
            // output the results of the request
            [self requestCompleted:connection forFbID:fbid result:result error:error];
        };
        
        // create the request object, using the fbid as the graph path
        // as an alternative the request* static methods of the FBRequest class could
        // be used to fetch common requests, such as /me and /me/friends
        NSLog(@"Requesting \"%@\"", fbid);
        FBRequest *request = [[FBRequest alloc] initWithSession:FBSession.activeSession
                                                      graphPath:fbid];
        
        // add the request to the connection object, if more than one request is added
        // the connection object will compose the requests as a batch request; whether or
        // not the request is a batch or a singleton, the handler behavior is the same,
        // allowing the application to be dynamic in regards to whether a single or multiple
        // requests are occuring
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

// FBSample logic
// Report any results.  Invoked once for each request we make.
- (void)requestCompleted:(FBRequestConnection *)connection
                 forFbID:fbID
                  result:(id)result
                   error:(NSError *)error {
    // not the completion we were looking for...
    //if (self.fbconnection &&
      //  connection != self.fbconnection) {
        //return;
    //}
    
    // ARC Clean.
    //self.fbconnection = nil;
        
    NSString *text;
    if (error) {
        // error contains details about why the request failed
        text = error.localizedDescription;
        NSLog(@"ERROR: %@ CAUSE: %@", error.localizedDescription, error.localizedFailureReason);
    } else {
        // result is the json response from a successful request
        NSDictionary *dictionary = (NSDictionary *)result;
        // we pull the name property out, if there is one, and display it
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
         }
     }
     ];
    [connection start];
}

// Debug.
-(void) writeToTextFile:(NSString*)text filename:(NSString*)filename{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.txt",
                          documentsDirectory, filename];
    //create content - four lines of text
    NSString *content = text;
    //save content to the documents directory
    [content writeToFile:fileName
              atomically:YES
                encoding:NSStringEncodingConversionAllowLossy
                   error:nil];
    
}

@end
