//
//  cameraController.h
//  NotFussed
//
//  Created by cjsg1 on 5/12/12.
//  Copyright (c) 2012 The University of Waikato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@interface cameraController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic,retain) IBOutletCollection(UIImageView) NSArray *thumbnails;
@property (nonatomic,strong) NSString *videoID;
@property (nonatomic,strong) NSString *pictureID;
@property (nonatomic,retain) IBOutletCollection(UIImageView) NSArray *imageViews;
@end
