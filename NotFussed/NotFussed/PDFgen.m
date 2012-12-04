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

- (NSString*)createPDFname: (NSString*)name pet:(NSString*)text age:(NSString*)age
{
    NSLog(@"PDF TEXT: %@", text);
    NSString *home = NSHomeDirectory();
    NSString *pdfFile = [home stringByAppendingString:@"/Documents/pdf_gen_out.pdf"];
    NSLog(@"PDF PATH: %@", pdfFile);
    // Prepare the text using a Core Text Framesetter.
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, (CFStringRef)[text copy], NULL);
    if (currentText) {
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
        if (framesetter) {
            
            // Create the PDF context using the default page size of 612 x 792.
            CGRect pagesize =  CGRectMake(0,0,792,612);
            UIGraphicsBeginPDFContextToFile(pdfFile, pagesize, nil);
            
            //CFRange currentRange = CFRangeMake(0, 0);
            NSInteger currentPage = 0;
            BOOL done = NO;
            
            do {
                // Mark the beginning of a new page.
                UIGraphicsBeginPDFPageWithInfo(pagesize, nil);
                CGRect visible = CGRectMake(72,72, pagesize.size.width-144, pagesize.size.height-144);
                // Draw a page number at the bottom of each page.
                currentPage++;
                [self drawBorder:visible width:4 offset:20];
                [self drawHeader:visible];
                CGSize last;
                last = [self drawText:[name stringByAppendingFormat:@" (%@) from %@ has completed a course in No School Academy.", age, @"Manehattan"] font:[UIFont fontWithName:@"Papyrus" size:16.0] x:0 y:0 width:visible.size.width];
                CGSize title = [self drawText:[name stringByAppendingString:@":"] font:[UIFont fontWithName:@"Papyrus" size:16.0] x:0 y:last.height + 10 width:visible.size.width];
                last = [self drawText:@"Admires:\n" font:[UIFont systemFontOfSize:14.0] x:0 y:2*title.height width:(visible.size.width/3)-10];
                [self drawImage:[home stringByAppendingString:@"/Documents/Screen Shot 2012-11-30 at 1.33.38 PM.png"] x:0 y:2*title.height + last.height width:(visible.size.width/3)-10];
                last = [self drawText:@"Respects:\n * Curiosity (Because a Rover that weighs the same as small SUV makes people respect you.)\n * A Good Tasty Heart\n * The Elements Of Harmony\n * The Element of Loyalty." font:[UIFont systemFontOfSize:14.0] x:(visible.size.width/3) y:2*title.height width:(visible.size.width/3)-10];
                last = [self drawText:[@"And is going to:\n" stringByAppendingString:text] font:[UIFont systemFontOfSize:14.0] x:2*(visible.size.width/3) y:2*title.height width:(visible.size.width/3)-10];
                [self drawTimestamp];
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
     
- (CFRange)renderPage:(NSInteger)pageNum withTextRange:(CFRange)currentRange
       andFramesetter:(CTFramesetterRef)framesetter
{
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    CGRect    frameRect = CGRectMake(72, 72, 648, 468);
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    CGContextTranslateCTM(currentContext, 0, 612);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CTFrameDraw(frameRef, currentContext);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, -612);
    currentRange = CTFrameGetVisibleStringRange(frameRef);
    currentRange.location += currentRange.length;
    currentRange.length = 0;
    CFRelease(frameRef);
    return currentRange;
}

- (void) drawHeader:(CGRect)pageSize
{
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0, 0, 0, 1.0);
    
    NSString *textToDraw = @"Diploma";
    
    UIFont *font = [UIFont fontWithName:@"Zapfino" size:24.0];
    
    CGSize stringSize = [textToDraw sizeWithFont:font constrainedToSize:CGSizeMake(pageSize.size.width - 2*72, pageSize.size.height - 2*72) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect renderingRect = CGRectMake(72, 72, pageSize.size.width - 72, stringSize.height);
    
    [textToDraw drawInRect:renderingRect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    NSLog(@"Header height: %f", stringSize.height);
    headeroffset = stringSize.height;
}

- (void) drawBorder:(CGRect)drawarea width:(int)width offset:(int)offset
{
    
    UIColor *borderColor = [UIColor blackColor];
    CGRect draw = CGRectMake((drawarea.origin.x-offset-width), (drawarea.origin.y-offset-width), (drawarea.size.width+offset+width), (drawarea.size.height+offset+width));
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(currentContext, borderColor.CGColor);
    CGContextSetLineWidth(currentContext, width);
    CGContextStrokeRect(currentContext, draw);
}

- (CGSize) drawText:(NSString*)textToDraw font:(UIFont*)font x:(int)x y:(int)y width:(int)width
{
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
    CGRect pageSize = CGRectMake(0, 0, 792, 612);
    if (width > (pageSize.size.width - 144))
    {
        width = pageSize.size.width - 144;
    }
    
    CGSize stringSize = [textToDraw sizeWithFont:font
                               constrainedToSize:CGSizeMake(width, (468 - headeroffset - y))
                                   lineBreakMode:NSLineBreakByWordWrapping];
    CGRect renderingRect = CGRectMake(72 + x, 72 + headeroffset + y, width, stringSize.height);
    
    [textToDraw drawInRect:renderingRect
                  withFont:font
             lineBreakMode:NSLineBreakByWordWrapping
                 alignment:NSTextAlignmentLeft];
    NSLog(@"DREW TEXT: X:%d Y:%d Width:%f Height:%f", x, y, stringSize.width, stringSize.height);
    return stringSize;
    
}

- (CGRect) drawImage:(NSString*)path x:(int)x y:(int)y width:(int)width
{
    UIImage * Image = [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
    CGFloat scale = width/Image.size.width;
    
    CGRect imageSize = CGRectMake(72 + x, 72 + headeroffset + y, width, Image.size.height*scale);
    
    UIImage *draw = [UIImage imageWithCGImage:[Image CGImage] scale:scale orientation:UIImageOrientationUp];
    [draw drawInRect:imageSize];
    // Do stuff to render an image
    return imageSize;
}

-(void) drawTimestamp
{
    NSString *dt;
	NSDate *now = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"HH:mm:ss' 'dd-MM-yyyy"];
	dt = [dateFormatter stringFromDate:now];
    NSString *stamp = @"Generated on a iOS device at: ";
    stamp = [stamp stringByAppendingString:dt];
    CGSize stringSize = [stamp sizeWithFont:[UIFont systemFontOfSize:7.0]
                               constrainedToSize:CGSizeMake(792, 72)
                                   lineBreakMode:NSLineBreakByWordWrapping];
    CGRect renderingRect = CGRectMake(792-stringSize.width-5, 612-stringSize.height-5, 792, stringSize.height);
    
    [stamp drawInRect:renderingRect
                  withFont:[UIFont systemFontOfSize:7.0]
             lineBreakMode:NSLineBreakByWordWrapping
                 alignment:NSTextAlignmentLeft];
}
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        exit(EXIT_FAILURE);
    }
}

@end
