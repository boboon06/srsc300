//
//  ViewController.m
//  Multi Avatar Test
//
//  Created by cjsg1 on 4/12/12.
//  Copyright (c) 2012 University of Waikato. All rights reserved.
//

#import "ViewController.h"
#import "MobileCoreServices/MobileCoreServices.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Loading saved images
    [self restoreImages];
}

- (void)restoreImages {
    UIImageView *imageView;
    for (imageView in _imageViews) {
        NSString *imageViewTag = [NSString stringWithFormat:@"%d",imageView.tag];
        NSString *imageName = [NSString stringWithFormat:@"%@%@",@"image",imageViewTag];
        if ([self doesFileExist:imageName :@"jpeg"]) {
            [imageView setImage:[self loadImage:imageName]];
        } else {
            [imageView setImage:[UIImage imageNamed: @"dummy-avatar.png" ]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startCamera:(id)sender {
    // Getting the sender
    UIButton* btnRecord = (UIButton*) sender;
    // Getting the 'ID' from the button tag
    NSString* ID =[NSString stringWithFormat:@"%d",btnRecord.tag];
    _pictureID = ID;
    NSLog(@"%@",ID);
    // Starts the Camera
    [self startCameraControllerFromViewController:self usingDelegate:self];
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller usingDelegate: (id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate{
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
    
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
    // Presents the modal view of the cameraUI
    [controller presentViewController:(cameraUI) animated:YES completion:nil];
    return YES;
}

    //Handling when the ImagePicker is closed
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *orginalImage, *editedImage, *imageToSave;
    
    editedImage = (UIImage *) [info objectForKey: UIImagePickerControllerEditedImage];
    orginalImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
        
    if(editedImage) {
        imageToSave = editedImage;
    } else {
        imageToSave = orginalImage;
    }
    
    imageToSave = (UIImage*) [info objectForKey: UIImagePickerControllerOriginalImage];
    
    //Going through the Array to find the UIImageView
    UIImageView *imageView;
    for(imageView in _imageViews) {
        NSString *imageViewTag = [NSString stringWithFormat:@"%d",imageView.tag];
        if ([_pictureID isEqualToString:imageViewTag]) {
             imageView.image = imageToSave;
        }
    }
    //Removing the image from Documents
    NSString *imageName = [NSString stringWithFormat:@"image%@",_pictureID];
    [self removeFile:imageName :@"jpeg"];
    
    //Creating the image
    [self saveImage:imageToSave :imageName];
    
    [self dismissViewControllerAnimated: YES completion:nil];
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
