//
//  PDFgen.m
//  PDFGen
//
//  Created by jsh23 on 29/11/12.
//  Copyright (c) 2012 The University of Waikato. All rights reserved.
//

#import "PDFgen.h"

@implementation PDFgen
@synthesize headeroffset;
@synthesize pagesize;

- (NSString*)createPDF:(NSObject*)values
{
    NSLog(@"PDF TEXT: %@", text);
    NSString *home = NSHomeDirectory();
    NSString *pdfFile = [home stringByAppendingString:@"/Documents/pdf_gen_out.pdf"];
    NSLog(@"PDF PATH: %@", pdfFile);
    pagesize =  CGRectMake(0,0,792,612);
    // Prepare the text using a Core Text Framesetter.
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, (CFStringRef)[text copy], NULL);
    if (currentText) {
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
        if (framesetter) {
            
            // Create the PDF context using the default page size of 612 x 792.
            UIGraphicsBeginPDFContextToFile(pdfFile, pagesize, nil);
            
            //CFRange currentRange = CFRangeMake(0, 0);
            BOOL done = NO;
            
            do {
                // Mark the beginning of a new page.
                UIGraphicsBeginPDFPageWithInfo(pagesize, nil);
                [self drawContentname:name pet:text age:age];
                                    done = YES;
            } while (!done);
            // Close the PDF context and write the contents out.
            UIGraphicsEndPDFContext();
            
            // Release the framewetter.
            CFRelease(framesetter);
            
        } else {
            NSLog(@"Could not create the framesetter needed to lay out the atrributed string.");
        }
        // Release the attributed string.
        CFRelease(currentText);
    } else {
        NSLog(@"Could not create the attributed string for the framesetter");
    }    
    // Close the PDF context and write out the contents.
    UIGraphicsEndPDFContext();
    return pdfFile;
}

- (NSString*)createJPG:(NSObject*)values
{
    pagesize =  CGRectMake(0,0,792,612);
    NSString *home = NSHomeDirectory();
    NSString *jpgpath = [home stringByAppendingString:@"/Documents/pdf_gen_out.jpg"]; // Figure out the Path to the JPG
    NSLog(@"IMAGE PATH: %@", jpgpath); // Just incase I get some random issue with sending images to Facebook etc.
    UIGraphicsBeginImageContext(CGSizeMake(pagesize.size.width, pagesize.size.height)); // Begin the drawing.
    [self drawContentname:name pet:text age:age]; // Use the exact same drawing tools as the PDF uses. Nifty that.
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext(); // Place it into a UIImage.
    UIGraphicsEndImageContext(); // Finish the Context. I don't need it anymore.
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0); // Initilise saving it to a file.
    [imageData writeToFile:jpgpath atomically:YES]; // Do the save.
    return jpgpath; // Tell the caller where to find it (If the caller doesn't need it... it doesn't use it.)
}

-(void) drawContentname:(NSString*)name pet:(NSString*)text age:(NSString*)age
{
    NSString *home = NSHomeDirectory();
    CGRect visible = CGRectMake(72,72, pagesize.size.width-144, pagesize.size.height-144); // Setup the visible area. 72pt margins.
    [self drawBorder:visible width:4 offset:20]; // Draw the border. with a pre defined width and margin.
    [self drawHeader:visible]; // Draw the header.
    CGSize last; // Initilise a container to hold the last item's height (For dynamic reflow).
    last = [self drawText:[name stringByAppendingFormat:@" (%@) from %@ has completed a course in Not Breaking it!", age, @"Manehattan, EQ"] font:[UIFont fontWithName:@"Papyrus" size:16.0] x:0 y:0 width:visible.size.width]; // Draw the short spiel.
    CGSize title = [self drawText:[name stringByAppendingString:@":"] font:[UIFont fontWithName:@"Papyrus" size:16.0] x:0 y:last.height + 10 width:visible.size.width]; // Draw the name with a trailing :
    last = [self drawText:@"Admires:\n" font:[UIFont systemFontOfSize:14.0] x:0 y:2*title.height width:(visible.size.width/3)-10]; // Draw the Admires title.
    [self drawImage:[home stringByAppendingString:@"/Documents/Screen Shot 2012-11-30 at 1.33.38 PM.png"] x:0 y:2*title.height + last.height width:(visible.size.width/3)-10]; // Draw the image/possible text. [206 pt wide. Drawn Width Fit.]
    last = [self drawText:@"Respects:\n * Curiosity (Because a Rover that weighs the same as small SUV makes people respect you.)\n * The Element of Loyalty.\n * Fearlessness\n * Intelligence" font:[UIFont systemFontOfSize:14.0] x:(visible.size.width/3) y:2*title.height width:(visible.size.width/3)-10]; // Draw the traits that the user respects.
    last = [self drawText:[@"And is going to:\n" stringByAppendingString:text] font:[UIFont systemFontOfSize:14.0] x:2*(visible.size.width/3) y:2*title.height width:(visible.size.width/3)-10]; // Draw the user's spiel.
    [self drawTimestamp]; // Draw a small Generated Timestamp (Bottom Right).

}

- (void) drawHeader:(CGRect)pageSize
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext(); // Get context.
    CGContextSetRGBFillColor(currentContext, 0, 0, 0, 1.0);
    
    NSString *textToDraw = @"Diploma"; // For easy change to the string.
    
    UIFont *font = [UIFont fontWithName:@"Zapfino" size:24.0]; // The font I want.
    
    CGSize stringSize = [textToDraw sizeWithFont:font constrainedToSize:CGSizeMake(pageSize.size.width, pageSize.size.height) lineBreakMode:NSLineBreakByWordWrapping]; // Figure out how big the string is going to be.
    
    CGRect renderingRect = CGRectMake(72, 72, pageSize.size.width, stringSize.height); // Build where it's going to fit.
    
    [textToDraw drawInRect:renderingRect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter]; // Draw the header
    NSLog(@"Header height: %f", stringSize.height); // Log it's height.
    headeroffset = stringSize.height; // Store it for offsets!
}

- (void) drawBorder:(CGRect)drawarea width:(int)width offset:(int)offset
{
    
    UIColor *borderColor = [UIColor blackColor]; // Black Border.
    CGRect draw = CGRectMake((drawarea.origin.x-offset-width), (drawarea.origin.y-offset-width), (drawarea.size.width+offset+width), (drawarea.size.height+offset+width)); // Setup the Border Rectangle (It will fit around this.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext(); // Get the context.
    CGContextSetStrokeColorWithColor(currentContext, borderColor.CGColor); // Set up the stroke.
    CGContextSetLineWidth(currentContext, width); // Set up the width of the border.
    CGContextStrokeRect(currentContext, draw); // Draw that motherfucker!
}

- (CGSize) drawText:(NSString*)textToDraw font:(UIFont*)font x:(int)x y:(int)y width:(int)width
{
    CGContextRef    currentContext = UIGraphicsGetCurrentContext(); // Get the context.
    CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0); // Make sure it isn't going to be transparent!
    if (width > (pagesize.size.width - 144)) // If it's to large to draw...
    {
        width = pagesize.size.width - 144; // Clip it so I can.
    }
    
    CGSize stringSize = [textToDraw sizeWithFont:font // Known Font.
                               constrainedToSize:CGSizeMake(width, ((pagesize.size.height - 144) - headeroffset - y)) // Figure out where I can draw it, and make it reflow around.
                                   lineBreakMode:NSLineBreakByWordWrapping]; // If I have to break it. Break it by wrapping the words.
    CGRect renderingRect = CGRectMake(72 + x, 72 + headeroffset + y, width, stringSize.height); // Now this is where it will be drawn.
    
    [textToDraw drawInRect:renderingRect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft]; // Draw it!
    NSLog(@"DREW TEXT: X:%d Y:%d Width:%f Height:%f", x, y, stringSize.width, stringSize.height); // Log it.
    return stringSize; // Return it's size so I can do accurate drawing.
    
}

- (CGRect) drawImage:(NSString*)path x:(int)x y:(int)y width:(int)width
{
    UIImage * Image = [UIImage imageWithData:[NSData dataWithContentsOfFile:path]]; // Load in the image to RAM
    CGFloat scale = width/Image.size.width; // Figure out the scale from the Image [Wanted Width / Image Width] < 1 for smaller > 1 for larger.
    CGRect imageSize = CGRectMake(72 + x, 72 + headeroffset + y, width, Image.size.height*scale); // Generate the Image Render Box.
    UIImage *draw = [UIImage imageWithCGImage:[Image CGImage] scale:scale orientation:UIImageOrientationUp];  // Initilize the Image into a UIImage so I can Draw it.
    [draw drawInRect:imageSize]; // Draw the Image.
    NSLog(@"DREW IMAGE: X: %d Y:%d Width:%f Height:%f Scale:%f", x, y, imageSize.size.width, imageSize.size.height, scale); // Log it.
    return imageSize; // Return it's size so I can do accurate drawing.
}

-(void) drawTimestamp
{
    NSString *dt; // Initilize the Output string.
	NSDate *now = [NSDate date]; // Initilize a copy of the Time and Date.
	NSDateFormatter *dateFormatter = [NSDateFormatter new]; // Initilize a Date formatter.
	[dateFormatter setDateFormat:@"HH:mm:ss' 'dd-MM-yyyy"]; // Get ready to format!
	dt = [dateFormatter stringFromDate:now]; // FORMAT IT AND STORE IT! AHH EXACTLY HOW I LIKE IT!
    UIDevice *device = [UIDevice new]; // This devices's details!
    NSString *name = device.name; // Oh What's my name?
    NSString *stamp = [NSString stringWithFormat:@"Generated on %@ at: %@", name, dt ]; // Generate the stamp.
    CGSize stringSize = [stamp sizeWithFont:[UIFont systemFontOfSize:7.0] // Generic small font.
                               constrainedToSize:CGSizeMake(792, 72) // Fill one of the margins.
                                   lineBreakMode:NSLineBreakByWordWrapping]; // Break it if I have to.
    CGRect renderingRect = CGRectMake(pagesize.size.width-stringSize.width-30, pagesize.size.height-stringSize.height-5, pagesize.size.width, stringSize.height); // Generate the Drawing rectangle.
    
    [stamp drawInRect:renderingRect withFont:[UIFont systemFontOfSize:8.0] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft]; // Draw it!
    NSLog(@"DREW TIMESTAMP: X:%f Y:%f Width:%f Height:%f", pagesize.size.width-stringSize.width-30, pagesize.size.height-stringSize.height-5, stringSize.width, stringSize.height); // Log it.
}
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        exit(EXIT_FAILURE); // If an Critical error has occoured. Close it when the user clicks "Ok"
    }
}

@end
