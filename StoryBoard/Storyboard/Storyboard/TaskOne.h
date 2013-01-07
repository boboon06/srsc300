//
//  TaskOne.h
//  Storyboard
//
//  Created by sls38 on 12/12/12.
//  Copyright (c) 2012 sls37. All rights reserved.
//

#import "TaskController.h"

@interface TaskOne : TaskController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    IBOutlet UIImageView *avatarImageView;
}
-(IBAction)takePicture:(id)sender;
@property (nonatomic,strong) NSString *pictureID;
@end
