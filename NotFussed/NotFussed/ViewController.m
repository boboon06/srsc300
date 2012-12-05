//
//  ViewController.m
//  NotFussed
//
//  Created by jsh23 on 28/11/12.
//  Copyright (c) 2012 The University of Waikato. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize attachments; // EMAIL ATTACHMENTS

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





// EMAIL RELATED CODE.
// HOW TO CALL THE EMAIL AND PDF CALLER?
// id gen = [PDFgen new];
// NSString PDFPATH = [gen createPDFname:<name> [OTHER data]]

// All this depends on how we implement storing data, I'll rather have to just need to use [gen createPDF] and pull from a Keyvalue Store.

-(void)showPicker
{
    UIAlertView *message = [UIAlertView alloc];
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            // It is so we can display the email code.
            [self displayComposerSheet];
        }
        else
        {
            // The device hasn't been set up. So tell the user to get it set up.
            message = [message initWithTitle:@"Sorry"
                                     message:@"Your device hasn't been set up to send emails. Please contact your System Administrator."
                                    delegate:self
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil];
            [message show];
        }
    }
    else
    {
        // The device doesn't support sending emails. Needs to be updated above iOS 3.0. The Base version should make the device fail to install it.
        message = [message initWithTitle:@"Sorry"
                                 message:@"Your device doesn't support sending emails. Please contact your System Administrator."
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
    
    [picker setToRecipients:toRecipients];
    //[picker setCcRecipients:ccRecipients];
    //[picker setBccRecipients:bccRecipients];
    
    // Attach an image to the email
    //NSString *home = NSHomeDirectory(); Unused ATM.
    /* Use theses to attach files.
    attach([home stringByAppendingString:@"/Documents/Screen Shot 2012-11-30 at 1.33.38 PM.png"], @"image/png", [name.text stringByAppendingString:@" Role Model.png"], picker);
    attach([home stringByAppendingString:@"/Documents/pdf_gen_out.pdf"], @"application/pdf", [name.text stringByAppendingString:@"'s Diploma.pdf"], picker);
    */
    
    
    // Fill out the email body text
    NSString *emailBody = @"OHMYGERD I've finished it!\nFinaly!";
    [picker setMessageBody:emailBody isHTML:NO];
    
    [self presentViewController:picker animated:YES completion:nil];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"MAIL Result: Canceled. Not Saved as Draft.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"MAIL Result: Canceled. Saved as Draft.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"MAIL Result: sent.");
            popup(@"Success!", @"Your message has been sent!");
            break;
        case MFMailComposeResultFailed:
            popup(@"I just don't know what went wrong!", @"Something went horribly wrong, and it's an undocumentated error. Derpy Hooves is sorry."); // Mail Agent probibly broke.
            NSLog(@"MAIL Result: Complete Failure.");
            break;
        default:
            popup(@"Success!", @"Your message has been queued!");
            NSLog(@"MAIL Result: Delivery Pending.");
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
