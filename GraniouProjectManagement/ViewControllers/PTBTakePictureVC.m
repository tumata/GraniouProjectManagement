//
//  PTBTakePictureVC.m
//  GraniouProjectManagement
//
//  Created by the Manticore iOS View Generator on 2014-07-15.
//  Copyright (c) 2014 GraniouProjectManagement. All rights reserved.
//

#import "PTBTakePictureVC.h"

@interface PTBTakePictureVC () <UINavigationControllerDelegate ,UIImagePickerControllerDelegate>

@property (nonatomic) UIImagePickerController *imagePickerController;

@property (weak, nonatomic) IBOutlet UIView *viewBeforePicture;
@property (weak, nonatomic) IBOutlet UIView *viewAfterPicture;

@property (weak, nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@property (weak, nonatomic) IBOutlet UIButton *buttonMenuPhotos;

// Premiere vue : prendre photo depuis camera ou bibliotheque
- (IBAction)actionPhotoLibrary:(id)sender;
- (IBAction)actionPhotoCamera:(id)sender;

// Deuxieme vue : annuler / sauvegarder
- (IBAction)actionValider:(id)sender;
- (IBAction)actionCancel:(id)sender;

@end

@implementation PTBTakePictureVC

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
    
    // Test si l'appareil a un appareil photo
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // There is not a camera on this device, so don't show the camera button.
        [_buttonMenuPhotos setUserInteractionEnabled:false];
        [_buttonMenuPhotos setBackgroundColor:[UIColor redColor]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)actionPhotoLibrary:(id)sender {
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)actionPhotoCamera:(id)sender {
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)actionValider:(id)sender {
    NSAssert(_image, @"PTBTakePicture could press validate without image");
    [self.delegate exitSavingPicture:_image];
}

- (IBAction)actionCancel:(id)sender {
    _image = nil;
    [self.delegate exitCancellingPicture];
}

#pragma mark - PickerController methods

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        // The user wants to use the camera interface.
        imagePickerController.showsCameraControls = YES;
    }
    _imagePickerController = imagePickerController;
    
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.image = image;
    
    // On enleve le viewController prise de photo
    [self dismissViewControllerAnimated:YES completion:NULL];
    // Operations
    [self imageFromPickerSetNowFinishAndUpdate];
}

// Picker has canceled
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Once image is in memory, show it etc.
- (void)imageFromPickerSetNowFinishAndUpdate
{
    // Affichage de l'image prise dans imageView
    [_imageView setImage: self.image];
    
    [_viewBeforePicture setHidden:true];
    
    _imagePickerController = nil;
}


@end
