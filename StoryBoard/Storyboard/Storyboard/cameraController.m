//
//  cameraController.m
//  NotFussed
//
//  Created by cjsg1 on 5/12/12.
//  Copyright (c) 2012 The University of Waikato. All rights reserved.
//

//
// Call startCameraVideo or startCameraPicture to start the camera.
//
// Call playVideo to play a fullscreen video
//
// For each UI element, there needs to be a unique tag for it in the array.
// With Videos, there needs to be a record video and play video button with the same ID.
// Pictures need a capture photo button and a UIImageView with the same ID.
// Thumbnails are generated at equal intervals according to how many UIImageViews there
// are in the IBOutletCollection.

#import "cameraController.h"
#import "MobileCoreServices/MobileCoreServices.h"
#import "MediaPlayer/MediaPlayer.h"
#import "AVFoundation/AVFoundation.h"

@interface cameraController ()

@end

@implementation cameraController

- (void)startCameraVideo:(id)sender {
    // Getting the sender
    UIButton* btnRecord = (UIButton*) sender;
    NSString* ID =[NSString stringWithFormat:@"%d",btnRecord.tag];
    _videoID = ID;
    NSLog(@"%@",ID);
    [self startCameraVideoControllerFromViewController:self usingDelegate:self];
}

- (IBAction)startCameraPicture:(id)sender {
    // Getting the sender
    UIButton* btnRecord = (UIButton*) sender;
    // Getting the 'ID' from the button tag
    NSString* ID =[NSString stringWithFormat:@"%d",btnRecord.tag];
    _pictureID = ID;
    NSLog(@"%@",ID);
    // Starts the Camera
    [self startCameraPictureControllerFromViewController:self usingDelegate:self];
}

 
- (IBAction)changeThumbnail:(id)sender {
    UIButton *button = (UIButton*) sender;
    [_selectedThumbnail setImage:[button imageForState:UIControlStateNormal] forState:UIControlStateNormal];
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

    //Starting a camera for video capture
- (BOOL) startCameraVideoControllerFromViewController: (UIViewController*) controller usingDelegate: (id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) || (delegate == nil) || (controller == nil)) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose pictures only
    //cameraUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController:(cameraUI) animated:YES completion:nil];
    return YES;
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
    
    UIImage *orginalImage,*editedImage,*imageToSave;
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    //Handling a Movie Capture
    if(CFStringCompare((CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        NSString *moviePath = [[info objectForKey: UIImagePickerControllerMediaURL] path];
        
        // Getting the path printed to console
        NSLog(@"Video path: %@",moviePath);
        
        // Moving the captured video from temporary storage to persistant storage
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *fileName = [NSString stringWithFormat:@"capturedVideo%@",_videoID];
        NSString *move_path =[NSString stringWithFormat:@"%@/%@%@", [paths objectAtIndex: 0],fileName,@".MOV"];
        NSLog(@"Destination path: %@",move_path);
        NSError *error;
        
        // Remove file at destination
        [fm removeItemAtPath:move_path error:&error];
        
        // Moving
        if ([fm copyItemAtPath:moviePath toPath:move_path error:&error]) {
            NSLog(@"Copy Successful");
        } else {
            NSLog(@"Copy Unsuccessful");
        }
        
        // Remove file the captured video from the temporary storage
        moviePath = [moviePath substringToIndex:[moviePath length] - 17];
        [self removeFile:fileName :@".MOV"];
        
        MPMoviePlayerController *movieObject = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:move_path]];
        // Getting thumbnails from the video
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:move_path]];
        CMTime duration = playerItem.duration;
        float seconds = CMTimeGetSeconds(duration);
        // Getting the points for the thumbnails
        float interval = (float) seconds/_thumbnails.count;
        // Going through the collection to set the thumbnails
        UIButton *imageView;
        for (imageView in _thumbnails) {
            NSInteger id = imageView.tag;
            float timePos =interval * id;
            UIImage *thumbnail =[movieObject thumbnailImageAtTime:timePos timeOption:MPMovieTimeOptionNearestKeyFrame];
            [imageView setImage:thumbnail forState:UIControlStateNormal];
        }
    }
    
    if(CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
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
    }
    
    [self dismissViewControllerAnimated: YES completion:nil];
}

-(IBAction)playVideo:(id)sender {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //Getting the 'ID' (Same code as record video, make it a method later)
    // Getting the sender
    UIButton* btnRecord = (UIButton*) sender;
    // Getting the 'ID' from the button title
    NSString* ID =[NSString stringWithFormat:@"%d",btnRecord.tag];
    _videoID = ID;
    NSLog(@"%@",ID);
        
    NSString *move_path =[NSString stringWithFormat:@"%@%@%@%@", [paths objectAtIndex: 0],@"/capturedVideo",_videoID,@".MOV"];
    // Creating the player and playing the video
    NSURL *url = [NSURL fileURLWithPath:move_path];
    
    MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [self presentMoviePlayerViewControllerAnimated:moviePlayer];
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
