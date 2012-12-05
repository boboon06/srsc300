//
//  ViewController.m
//  Multi Video Test
//
//  Created by cjsg1 on 4/12/12.
//  Copyright (c) 2012 University of Waikato. All rights reserved.
//

#import "ViewController.h"
#import "MobileCoreServices/MobileCoreServices.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize moviePlayer;

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startCamera:(id)sender {
    // Getting the sender
    UIButton* btnRecord = (UIButton*) sender;
    // Getting the 'ID' from the button title
    //NSArray* title = [btnRecord.currentTitle componentsSeparatedByString:@" "];
    //NSString* ID = [title objectAtIndex:title.count -1];
    NSString* ID =[NSString stringWithFormat:@"%d",btnRecord.tag];    
    _videoID = ID;
    NSLog(@"%@",ID);
    [self startCameraControllerFromViewController:self usingDelegate:self];
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller usingDelegate: (id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate{
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

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *moviePath = [[info objectForKey: UIImagePickerControllerMediaURL] path];
    
    // Getting the path printed to console
    NSLog(@"Video path: %@",moviePath);
    
    // Moving the captured video from temporary storage to persistant storage
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *move_path =[NSString stringWithFormat:@"%@%@%@%@", [paths objectAtIndex: 0],@"/capturedVideo",_videoID,@".MOV"];
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
    [fm removeItemAtPath:moviePath error:&error];
    
    // Checking if file exists
    NSLog(@"Checking if file exists at path: %@",move_path);
    if ([fm fileExistsAtPath:move_path]) {
        NSLog(@"File exist");
    } else {
        NSLog(@"File doesn't exist");
    }
    
    [self dismissViewControllerAnimated: YES completion:nil];
}

-(IBAction)playVideo:(id)sender {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //Getting the 'ID' (Same code as record video, make it a method later)
    // Getting the sender
    UIButton* btnRecord = (UIButton*) sender;
    // Getting the 'ID' from the button title
    //NSArray* title = [btnRecord.currentTitle componentsSeparatedByString:@" "];
    //NSString* ID = [title objectAtIndex:title.count -1];
    NSString* ID =[NSString stringWithFormat:@"%d",btnRecord.tag];
    _videoID = ID;
    NSLog(@"%@",ID);
    
    
    NSString *move_path =[NSString stringWithFormat:@"%@%@%@%@", [paths objectAtIndex: 0],@"/capturedVideo",_videoID,@".MOV"];
    // Creating the player and playing the video
    NSURL *url = [NSURL fileURLWithPath:move_path];
    
    MPMoviePlayerViewController *amoviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [self presentMoviePlayerViewControllerAnimated:amoviePlayer];
}

@end
