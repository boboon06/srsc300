//
//  TaskTwo.h
//  Storyboard
//
//  Created by sls38 on 12/12/12.
//  Copyright (c) 2012 sls37. All rights reserved.
//

#import "TaskController.h"

@interface TaskTwo : TaskController {
BOOL btnStates[11];
int maxSelectedTraits;
}
@property (nonatomic,retain) IBOutletCollection(UIButton) NSArray *traits;
@property (nonatomic,strong) IBOutlet UILabel *traitDisplay;
@property (nonatomic,strong) IBOutlet UITextField *tfCustomTrait;
@property (nonatomic,strong) UIColor *selectedColour;
@property (nonatomic,strong) UIColor *orginalColour;
-(IBAction)btnTraitPressed:(id)sender;
-(IBAction)tfTraitEntered:(id)sender;
@end
