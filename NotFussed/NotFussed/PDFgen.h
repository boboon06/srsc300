//
//  PDFgen.h
//  PDFGen
//
//  Created by jsh23 on 29/11/12.
//  Copyright (c) 2012 The University of Waikato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>


@interface PDFgen : NSObject
@property (nonatomic) int headeroffset;

- (NSString*) createPDFname:(NSString*)name pet:(NSString*)text;
- (CFRange)renderPage:(NSInteger)pageNum withTextRange:(CFRange)currentRange andFramesetter:(CTFramesetterRef)framesetter;
-(void)drawHeader:(CGRect)pageSize;
- (void) drawBorder:(CGRect)area width:(int)width offset:(int)offset;
- (CGSize) drawText:(NSString*)textToDraw font:(UIFont*)font x:(int)x y:(int)y width:(int)width;
- (CGRect) drawImage:(NSString*)path x:(int)x y:(int)y width:(int)width;
- (void) drawTimestamp;
@end
