//
//  PTBTacheVC.m
//  GraniouProjectManagement
//
//  Created by the Manticore iOS View Generator on 2014-07-16.
//  Copyright (c) 2014 GraniouProjectManagement. All rights reserved.
//

#define MAX_HEIGHT 2000

#import "PTBAppDelegate.h"
#import "PTBTacheVC.h"
#import "PTBWriteCommentVC.h"
#import "PTBTakePictureVC.h"
#import "Tache.h"

@interface PTBTacheVC () <PTBWriteCommentDelegate, PTBTakePictureVCDelegate>

@property (strong, nonatomic) PTBWriteCommentVC *writeCommentVC;
@property (strong, nonatomic) PTBTakePictureVC *takePictureVC;

@property (weak, nonatomic) IBOutlet UILabel *labelTitre;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (weak, nonatomic) IBOutlet UITextView *textViewCommentaire;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewImageCommentaire;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCommentaire;

@end

@implementation PTBTacheVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //////////// Initialisation pour tests : save entry
        
//        PTBAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
//        NSManagedObjectContext *context =  delegate.managedObjectContext;
//        
//        Tache *tache = [NSEntityDescription insertNewObjectForEntityForName:@"Tache" inManagedObjectContext:context];
//        
//        tache.nom = @"Effectuer les tests";
//        tache.infos = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
//        tache.commentaire = nil;
//        
//        NSError * error;
//        if (![context save:&error]) {
//            
//        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSString *foo = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
//    [_textViewDescription setText:foo];
//    [_textViewCommentaire setText:foo];
    [self setGoodSizeForTextView:_textViewDescription];
//    [self setGoodSizeForTextView:_textViewCommentaire];
    
    _imageViewCommentaire.image = nil;
    
    [_scrollViewImageCommentaire setBounds:CGRectMake(0, 0, 320, 0)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSource:(id)source {
    _source = source;
    [self updateView];
}

- (void)updateView {
    id titre = [_source valueForKey:@"nom"];
    id description = [_source valueForKey:@"infos"];
    id commentaire = [_source valueForKey:@"commentaire"];
    id urlPhoto = [_source valueForKey:@"urlPhoto"];
    
    _labelTitre.text = [titre description];
    _textViewDescription.text = [description description];
    _textViewCommentaire.text = [commentaire description];
    
    [self setGoodSizeForTextView:_textViewDescription];
    [self setGoodSizeForTextView:_textViewCommentaire];
    
    _imageViewCommentaire.image = [self getPhotoForUrl:urlPhoto];
    
}

- (void)setGoodSizeForTextView:(UITextView *)view {
    [view setFont:[UIFont systemFontOfSize:15]];
    CGSize size = [view.text sizeWithFont:[UIFont systemFontOfSize:15]
                  constrainedToSize:CGSizeMake(view.bounds.size.width, MAX_HEIGHT)
                      lineBreakMode:UILineBreakModeWordWrap];
    
    [view setBounds:CGRectMake(0, 0, view.bounds.size.width, size.height + 10)];
    //test
    //[view setBackgroundColor:[UIColor redColor]];

}

- (UIImage *)getPhotoForUrl:(id)url {
    return nil;
}



#pragma mark - Actions

- (IBAction)actionCommentaire:(id)sender {
    PTBWriteCommentVC *writeCommentVC = [[PTBWriteCommentVC alloc] init];
    writeCommentVC.delegate = self;
    _writeCommentVC = writeCommentVC;
    [self presentViewController:self.writeCommentVC animated:YES completion:nil];
}

- (IBAction)actionPhoto:(id)sender {
    PTBTakePictureVC *takePictureVC = [[PTBTakePictureVC alloc] init];
    takePictureVC.delegate = self;
    _takePictureVC = takePictureVC;
    [self presentViewController:_takePictureVC animated:YES completion:nil];
}

#pragma mark - WriteCommentDelegate methods

-(void)exitSavingComment:(NSString *)comment {
    _textViewCommentaire.text = comment;
    
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
    _imageViewCommentaire.image = image;
    
    [self dismissViewControllerAnimated:YES completion:^{
        _takePictureVC = nil;
    }];
}

-(void)exitCancellingPicture {
    [self dismissViewControllerAnimated:YES completion:^{
        _takePictureVC = nil;
    }];
}


@end
