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

@end
