//
//  TaskOne.h
//  Storyboard
//
//  Created by sls38 on 12/12/12.
//  Copyright (c) 2012 sls37. All rights reserved.
//

#import "TaskController.h"
#import "StaticInfo.h"

@interface TaskOne : TaskController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    IBOutlet UIImageView *avatarImageView;
    BOOL btnStates[11];
    int maxSelectedTraits;
}
/*
@property (nonatomic,retain) IBOutletCollection(UIButton) NSArray *traits;
@property (nonatomic,strong) IBOutlet UILabel *traitDisplay;
@property (nonatomic,strong) IBOutlet UITextField *tfCustomTrait;
@property (nonatomic,strong) UIColor *selectedColour;
@property (nonatomic,strong) UIColor *orginalColour;
-(IBAction)btnTraitPressed:(id)sender;
-(IBAction)tfTraitEntered:(id)sender;
*/

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *traits;
@property (strong, nonatomic) IBOutlet UITextField *tfCustomTrait;
@property (strong, nonatomic) IBOutlet UILabel *traitDisplay;
- (IBAction)btnTraitPressed:(UIButton *)sender;
- (IBAction)tfCustomTrait:(id)sender;

-(IBAction)takePicture:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *NameField;
@property (strong, nonatomic) IBOutlet UITextField *AgeField;
@property (strong, nonatomic) IBOutlet UITextField *CountryField;

@property (nonatomic,strong) NSString *pictureID;
@end
