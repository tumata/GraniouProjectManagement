//
//  PTBTopMenuVC.m
//  GraniouProjectManagement
//
//  Created by the Manticore iOS View Generator on 2014-07-15.
//  Copyright (c) 2014 GraniouProjectManagement. All rights reserved.
//

#import "PTBTopMenuVC.h"
#import "PTBNavigationView.h"
#import "PTBAppModel.h"
#import "PTBWriteCommentVC.h"
#import "PTBTakePictureVC.h"

@interface PTBTopMenuVC () <PTBNavigationViewDelegate, PTBWriteCommentDelegate, PTBTakePictureVCDelegate>

@property (weak, nonatomic) IBOutlet PTBNavigationView *navigationView;

@property (weak, nonatomic) PTBWriteCommentVC *writeCommentVC;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) PTBTakePictureVC *takePictureVC;

- (IBAction)pressBouton:(id)sender;

@end

@implementation PTBTopMenuVC

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
    _navigationView.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - NavigationVC delegate methods

- (void)navigationViewDidPressLeftButton {
    NSLog(@"Bouton retour appuye");
}

- (void)navigationViewDidPressRightButton {
    NSLog(@"ok");
}

- (IBAction)pressBouton:(id)sender {
//    MCIntent* intent = [MCIntent intentWithSectionName:SECTION_MONTEUR andViewName:VIEW_WRITECOMMENT];
//    
//    
//    [intent setAnimationStyle:UIViewAnimationOptionTransitionFlipFromLeft];
//    [[MCViewModel sharedModel] setCurrentSection:intent];

    
//    PTBWriteCommentVC *writeCommentVC = [[PTBWriteCommentVC alloc] init];
//    writeCommentVC.delegate = self;
//    _writeCommentVC = writeCommentVC;
//    [self presentViewController:self.writeCommentVC animated:YES completion:nil];
    

//    PTBTakePictureVC *takePictureVC = [[PTBTakePictureVC alloc] init];
//    takePictureVC.delegate = self;
//    _takePictureVC = takePictureVC;
//    [self presentViewController:_takePictureVC animated:YES completion:nil];
    
    
    MCIntent* intent = [MCIntent intentWithSectionName:SECTION_MONTEUR andViewName:VIEW_TACHE];

    [intent setAnimationStyle:UIViewAnimationOptionTransitionFlipFromLeft];
    [[MCViewModel sharedModel] setCurrentSection:intent];
    
}

#pragma mark - WriteCommentDelegate methods

-(void)exitSavingComment:(NSString *)comment {
    
    _textView.text = comment;
    [self dismissViewControllerAnimated:YES completion:^{
        _writeCommentVC = nil;
    }];
}

-(void)exitCancelling {
    [self dismissViewControllerAnimated:YES completion:^{
        _writeCommentVC = nil;
    }];
}

#pragma mark - TakePicturesDelegate methods

-(void)exitSavingPicture:(UIImage *)image {
    
}

-(void)exitCancellingPicture {
    
}

@end
