//
//  ViewController.h
//  Thumbnail select
//
//  Created by cjsg1 on 6/12/12.
//  Copyright (c) 2012 University of Waikato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic,retain) IBOutletCollection(UIButton) NSArray *thumbnails;
@property (nonatomic,strong) IBOutlet UIImageView *selectedThumbnail;
-(IBAction)changeThumbnail:(id)sender;
-(IBAction)startCamera:(id)sender;
@end