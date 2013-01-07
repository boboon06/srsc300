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
    
    // Change the first button to a Next instead
    // TODO: Make this not stupidly suck omg so bad
    UIBarButtonItem *myNextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(nextButtonAction:)];
    UIBarButtonItem *myCancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonAction:)];
    
    NSArray *myButtons = [[NSArray alloc] initWithObjects:myNextButton, myCancelButton, nil];
    self.navigationItem.rightBarButtonItems = myButtons;
    
    //Loads avatar from file if it exists
    if([self doesFileExist:@"image0" :@"jpeg"]) {
        avatarImageView.image = [self loadImage:@"image0"];
    }
    
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

@end
