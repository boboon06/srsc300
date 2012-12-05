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
@synthesize attachments;
@synthesize name;
@synthesize rmimagebox;
@synthesize age;

@class PDFgen;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *home = NSHomeDirectory();
    NSString *imagepath = [home stringByAppendingString:@"/Documents/Screen Shot 2012-11-30 at 1.33.38 PM.png"];
    UIImage *imagedata = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagepath]];
    [rmimagebox setImage:[UIImage imageWithCGImage:[imagedata CGImage] scale: 1 orientation:UIImageOrientationUp ]];
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
        NSString *pdfpath = [gen createPDFname:self.name.text pet:self.text_input.text age:age.text];
        attachments = pdfpath;
        [self showPicker];
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
-(void)showPicker
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
@end
