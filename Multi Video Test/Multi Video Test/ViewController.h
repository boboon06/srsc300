//
//  ViewController.h
//  Multi Video Test
//
//  Created by cjsg1 on 4/12/12.
//  Copyright (c) 2012 University of Waikato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> 
@property (nonatomic,strong) NSString *videoID;
-(IBAction)startCamera:(id)sender;
@end
