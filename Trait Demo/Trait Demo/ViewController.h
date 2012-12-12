//
//  ViewController.h
//  Trait Demo
//
//  Created by cjsg1 on 10/12/12.
//  Copyright (c) 2012 University of Waikato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    BOOL btnStates[11];
    int maxSelectedTraits;
}
@property (nonatomic,retain) IBOutletCollection(UIButton) NSArray *traits;
@property (nonatomic,strong) IBOutlet UILabel *traitDisplay;
@property (nonatomic,strong) IBOutlet UITextField *tfCustomTrait;
@property (nonatomic,strong) UIColor *selectedColour;
@property (nonatomic,strong) UIColor *orginalColour;
-(IBAction)btnTraitPressed:(id)sender;
@end

