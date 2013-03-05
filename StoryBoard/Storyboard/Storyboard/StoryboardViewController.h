//
//  StoryboardViewController.h
//  Storyboard
//
//  Created by sls38 on 6/12/12.
//  Copyright (c) 2012 sls37. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticInfo.h"

@interface StoryboardViewController : UIViewController <UINavigationControllerDelegate> {
    NSTimer *aTimer;
}

-(void)introfinished;
-(void)exitFullScreened;
-(UIImage*)imageWithImage;
@end
