//
//  PDFgen.m
//  PDFGen
//
//  Created by jsh23 on 29/11/12.
//  Copyright (c) 2012 The University of Waikato. All rights reserved.
//

#import "PDFgen.h"

@implementation PDFgen
@synthesize lastheight;

- (NSString*)createPDFname: (NSString*)name pet:(NSString*)text
{
    NSLog(@"PDF TEXT: %@", text);
    NSString *pdfFile = NSHomeDirectory();
    pdfFile = [pdfFile stringByAppendingString:@"/Documents/pdf.pdf"];
    NSLog(@"PDF PATH: %@", pdfFile);
    // Prepare the text using a Core Text Framesetter.
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, (CFStringRef)[text copy], NULL);
    if (currentText) {
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
        if (framesetter) {
            
            // Create the PDF context using the default page size of 612 x 792.
            UIGraphicsBeginPDFContextToFile(pdfFile, CGRectMake(0, 0, 792, 612), nil);
            
            //CFRange currentRange = CFRangeMake(0, 0);
            NSInteger currentPage = 0;
            BOOL done = NO;
            
            do {
                // Mark the beginning of a new page.
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 792, 612), nil);
                
                // Draw a page number at the bottom of each page.
                currentPage++;
                [self drawHeader];
                [self drawText:@"I am:" font:[UIFont fontWithName:@"Papyrus" size:16.0] offset:5];
                [self drawText:name font:[UIFont systemFontOfSize:14.0] offset:5];
                [self drawText:@"What pet do I like and why?" font:[UIFont fontWithName:@"Papyrus" size:16.0] offset:5];
                [self drawText:text font:[UIFont systemFontOfSize:14.0] offset:5];
                
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
     
// Use Core Text to draw the text in a frame on the page.
- (CFRange)renderPage:(NSInteger)pageNum withTextRange:(CFRange)currentRange
       andFramesetter:(CTFramesetterRef)framesetter
{
    // Get the graphics context.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Create a path object to enclose the text. Use 72 point
    // margins all around the text.
    CGRect    frameRect = CGRectMake(72, 72, 648, 468);
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    // The currentRange variable specifies only the starting point. The framesetter
    // lays out as much text as will fit into the frame.
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, 612);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, -612);
    
    // Update the current range based on what was drawn.
    currentRange = CTFrameGetVisibleStringRange(frameRef);
    currentRange.location += currentRange.length;
    currentRange.length = 0;
    CFRelease(frameRef);
    
    return currentRange;
}
- (void) drawHeader
{
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0, 0, 0, 1.0);
    CGRect pageSize = CGRectMake(0, 0, 792, 612);
    
    NSString *textToDraw = @"No School Academy";
    
    UIFont *font = [UIFont fontWithName:@"Zapfino" size:24.0];
    
    CGSize stringSize = [textToDraw sizeWithFont:font constrainedToSize:CGSizeMake(pageSize.size.width - 2*72, pageSize.size.height - 2*72) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect renderingRect = CGRectMake(72, 72, pageSize.size.width - 72, stringSize.height);
    
    [textToDraw drawInRect:renderingRect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    lastheight = stringSize.height;
}

- (void) drawText:(NSString*)textToDraw font:(UIFont*)font offset:(int)offset
{
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
    CGRect pageSize = CGRectMake(0, 0, 792, 612);
    
    CGSize stringSize = [textToDraw sizeWithFont:font
                               constrainedToSize:CGSizeMake(pageSize.size.width - 144, pageSize.size.height - 144)
                                   lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect renderingRect = CGRectMake(72, 72 + lastheight + offset, pageSize.size.width - 144, stringSize.height);
    
    [textToDraw drawInRect:renderingRect
                  withFont:font
             lineBreakMode:NSLineBreakByWordWrapping
                 alignment:NSTextAlignmentLeft];
    lastheight = lastheight + offset + stringSize.height;
    
}

@end
