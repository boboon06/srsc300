//
//  TaskOne.m
//  Storyboard
//
//  Created by sls38 on 12/12/12.
//  Copyright (c) 2012 sls37. All rights reserved.
//

#import "TaskOne.h"
#import "MobileCoreServices/MobileCoreServices.h"
#import "MediaPlayer/MediaPlayer.h"
#import "AVFoundation/AVFoundation.h"

@interface TaskOne ()

@end

@class cameraController;

@implementation TaskOne

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Loads avatar from file if it exists
    if([self doesFileExist:@"image0" :@"jpeg"]) {
        avatarImageView.image = [self loadImage:@"image0"];
    }
    
    // Populate the details we already filled in
    self.NameField.text = StaticInfo.getName;
    self.AgeField.text = [StaticInfo.getAge stringValue];
    NSLog(@"Value '%@'", self.AgeField.text);
    if ([self.AgeField.text isEqualToString:@"0"]) {
        NSLog(@"did it, gangsta");
        self.AgeField.text = @"";
    }
    NSLog(@"Value '%@'", self.AgeField.text);
    self.CountryField.text = StaticInfo.getCountry;
    
    // Setting up the colour for button selection -- PLZ FIX BY LOOKING AT TASKTWO
    /*
    _selectedColour = [UIColor orangeColor];
    _orginalColour = [UIColor whiteColor];
    // Filling the btnState array with the required amount of bools
    UIButton *temp;
    for (int i = 0; i < sizeof(btnStates) - 1; i++) {
        btnStates[i] = NO;
    }
    temp = nil;
    //Setting it up so that a n amount of traits can be selected
    maxSelectedTraits = 3;
    [self updateTraitDisplay];
     */
}

- (void) setDefaults {
    self.NameField.text = @"";
    self.AgeField.text = @"";
    self.CountryField.text = @"New Zealand";
}

- (IBAction)btnTraitPressed:(UIButton *)sender {
}

- (IBAction)tfCustomTrait:(id)sender {
}

- (IBAction)takePicture:(id)sender {
    // Getting the sender
    UIButton* btnRecord = (UIButton*) sender;
    // Getting the 'ID' from the button tag
    NSString* ID =[NSString stringWithFormat:@"%d",btnRecord.tag];
    _pictureID = ID;
    NSLog(@"%@",ID);
    // Starts the Camera
    [self startCameraPictureControllerFromViewController:self usingDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [StaticInfo setName:self.NameField.text];
    [StaticInfo setAge:[NSNumber numberWithInt:[self.AgeField.text intValue]]];
    [StaticInfo setCountry:self.CountryField.text];
    
}

//Starting the camera for picture taking
- (BOOL) startCameraPictureControllerFromViewController: (UIViewController*) controller usingDelegate: (id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate{
    // Checking if the device has a camera or not
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) || (delegate == nil) || (controller == nil)) {
        return NO;
    }
    
    // Creating the Image Picker
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose pictures only
    //cameraUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    
    cameraUI.allowsEditing = YES;
    
    cameraUI.delegate = delegate;
    
    // Presents the modal view of the cameraUI
    [controller presentViewController:(cameraUI) animated:YES completion:nil];
    return YES;
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *editedImage = (UIImage *) [info objectForKey: UIImagePickerControllerEditedImage];
    UIImage *orginalImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
    UIImage *imageToSave = nil;
    
    if(editedImage) {
        imageToSave = editedImage;
    } else {
        imageToSave = orginalImage;
    }    
    
    //Setting the Avatar to the captured picture
    avatarImageView.image = imageToSave;
    
    //Removing the image from Documents
    NSString *imageName = [NSString stringWithFormat:@"image%@",_pictureID];
    [self removeFile:imageName :@"jpeg"];
    
    //Creating the image
    [self saveImage:imageToSave :imageName];
    
    [self dismissViewControllerAnimated: YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Creates an image
- (void)saveImage:(UIImage*)image: (NSString*)imageName {
    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpeg",imageName]];
    [fm createFileAtPath:fullPath contents:imageData attributes:nil];
}
//Removes a file
- (void)removeFile:(NSString*)fileName: (NSString*)fileExtension {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",fileName,fileExtension]];
    [fm removeItemAtPath:fullPath error:nil];
}

//Checks if a file exist
- (BOOL)doesFileExist: (NSString*)fileName : (NSString*)fileExtension {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",fileName,fileExtension]];
    return [fm fileExistsAtPath:fullPath];
}

//Loads an image
- (UIImage*)loadImage: (NSString*)imageName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpeg",imageName]];
    return [UIImage imageWithContentsOfFile:fullPath];
}

/* More trait stuff from task two!
- (IBAction)tfTraitEntered:(id)sender {
    UITextField *tF = (UITextField*) sender;
    if ([[tF text] isEqualToString:@""]) {
        btnStates[sizeof(btnStates) - 1 ] = NO;
    } else {
        int traitCount = 0;
        for(int i = 0; i < sizeof(btnStates);i++) {
            if (btnStates[i])
                traitCount++;
        }
        if (traitCount < maxSelectedTraits)
            btnStates[sizeof(btnStates) - 1] = YES;
    }
    [self updateTraitDisplay];
}


- (IBAction)btnTraitPressed:(id)sender {
    // Converting the sender to a button
    UIButton *btnPressed = (UIButton*) sender;
    
    // Getting the index of the _btnState array
    if (btnStates[btnPressed.tag] == YES) {
        btnStates[btnPressed.tag] = NO;
    } else {
        int traitCount = 0;
        UIButton *btn;
        for(btn in _traits) {
            if (btnStates[btn.tag] == YES)
                traitCount++;
        }
        if (btnStates[sizeof(btnStates) -1])
            traitCount++;
        if (traitCount < maxSelectedTraits)
            btnStates[btnPressed.tag] = YES;
    }
    
    // looping through the array to set the background colours
    // according to the state of the array
    if (btnStates[btnPressed.tag]) {
        [btnPressed setBackgroundColor:_selectedColour];
    } else {
        [btnPressed setBackgroundColor:_orginalColour];
    }
    
    [self updateTraitDisplay];
}

- (void)updateTraitDisplay {
    bool doUpdate = NO;
    for (int i = 0; i < sizeof(btnStates); i++) {
        if (btnStates[i]) {
            doUpdate = YES;
            break;
        }
    }
    if (doUpdate) {
        UIButton *btn;
        NSMutableString *traitsText = [[NSMutableString alloc] initWithString:@""];
        // Making the string with all the traits
        for(btn in _traits) {
            if (btnStates[btn.tag]) {
                NSString *temp = [NSString stringWithFormat:@"%@|",btn.titleLabel.text];
                [traitsText appendString:temp];
            }
        }
        //Checking for the user entered text
        if (btnStates[sizeof(btnStates) - 1]) {
            NSString *temp = [NSString stringWithFormat:@"%@|",_tfCustomTrait.text];
            [traitsText appendString:temp];
        }
        NSString *tempTraitsText = [traitsText substringToIndex:[traitsText length]-1];
        NSArray *sortingArray = [tempTraitsText componentsSeparatedByString:@"|"];
        sortingArray = [sortingArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        // Converting the array into a string the long way
        traitsText = [[NSMutableString alloc] initWithString:@""];
        for (int i = 0; i < [sortingArray count];i++) {
            [traitsText appendString:[NSString stringWithFormat:@"%@\r\n",[sortingArray objectAtIndex:i]]];
        }
        _traitDisplay.text = traitsText;
    } else {
        _traitDisplay.text = @"";
    }
}
 
 */

@end
