//
//  ViewController.h
//  Video Test
//
//  Created by cjsg1 on 30/11/12.
//  Copyright (c) 2012 University of Waikato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic,retain) IBOutletCollection(UIImageView) NSArray *thumbnails;
-(IBAction)startCamera:(id)sender;
@end