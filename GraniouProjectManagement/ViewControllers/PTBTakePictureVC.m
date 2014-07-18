//
//  PTBTakePictureVC.m
//  GraniouProjectManagement
//
//  Created by the Manticore iOS View Generator on 2014-07-15.
//  Copyright (c) 2014 GraniouProjectManagement. All rights reserved.
//

#import "PTBTakePictureVC.h"

@interface PTBTakePictureVC ()


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
    // Do any additional setup after loading the view from its nib.
    
    // On ne montre pas la vue apres-photo
    [_viewAfterPicture setUserInteractionEnabled:false];
    
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
}

- (IBAction)actionPhotoCamera:(id)sender {
}

- (IBAction)actionValider:(id)sender {
    [self.delegate exitSavingPicture:_image];
}

- (IBAction)actionCancel:(id)sender {
    _image = nil;
    [self.delegate exitCancellingPicture];
}


@end
