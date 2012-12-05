//
//  ViewController.h
//  Multi Avatar Test
//
//  Created by cjsg1 on 4/12/12.
//  Copyright (c) 2012 University of Waikato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic,strong) NSString *pictureID;
@property (nonatomic,retain) IBOutletCollection(UIImageView) NSArray *imageViews;
-(IBAction)startCamera:(id)sender;
@end