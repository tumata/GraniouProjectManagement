//
//  PTBTacheVC.m
//  GraniouProjectManagement
//
//  Created by the Manticore iOS View Generator on 2014-07-16.
//  Copyright (c) 2014 GraniouProjectManagement. All rights reserved.
//

#define MAX_HEIGHT 2000

#import "UIImage+ResizeMagick.h"
#import "PTBAppDelegate.h"
#import "PTBTacheVC.h"
#import "PTBWriteCommentVC.h"
#import "PTBTakePictureVC.h"
#import "Tache.h"

@interface PTBTacheVC () <PTBWriteCommentDelegate, PTBTakePictureVCDelegate, PTBNavigationViewDelegate>


@property (weak, nonatomic) IBOutlet PTBNavigationView *navigationView;

@property (strong, nonatomic) PTBWriteCommentVC *writeCommentVC;
@property (strong, nonatomic) PTBTakePictureVC *takePictureVC;

@property (weak, nonatomic) IBOutlet UILabel *labelTitre;
@property (weak, nonatomic) IBOutlet UIButton *buttonCommentaire;
@property (weak, nonatomic) IBOutlet UIButton *buttonImage;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (weak, nonatomic) IBOutlet UITextView *textViewCommentaire;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewImageDescription;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewImageCommentaire;

@property (strong, nonatomic) UIImage *imageDescription;
@property (strong, nonatomic) UIImage *imageCommentaire;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintDescription;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintCommentaire;


@end

@implementation PTBTacheVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _navigationView.delegate = self;
    
    // -----------------
    // Generated for the tests
    //
    //NSString *foo = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    //[_textViewDescription setText:foo];
    //[self setGoodSizeForTextView:_textViewDescription];
    
    //_imageDescription = [UIImage imageNamed:@"LogoGraniou.png"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onResume:(MCIntent *)intent {
    
    [self setSource:[intent.savedInstanceState objectForKey:@"source"]];
    
    [self reloadView];
    [super onResume:intent];
}

-(void)onPause:(MCIntent *)intent {
    // todo : remove all subviews
    
    // Save context
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
    
    [super onPause:intent];
}

- (void)setSource:(id)source {
    _source = source;
    [self setDataFromSource];
}

- (void)setDataFromSource {
    id titre = [_source valueForKey:@"titre"];
    id description = [_source valueForKey:@"laDescription"];
    id commentaire = [_source valueForKey:@"commentaire"];
    
    _labelTitre.text = [titre description];
    _textViewDescription.text = [description description];
    _textViewCommentaire.text = [commentaire description];
    
    _imageCommentaire = [_source valueForKeyPath:@"images.imageCommentaire"];
    // recuperer image description si ldr
    
    [self setGoodSizeForTextView:_textViewDescription];
    [self setGoodSizeForTextView:_textViewCommentaire];
    
}

-(void)reloadView {
    [self createAndSetImage:_imageDescription andScrollView:_scrollViewImageDescription constraint:_heightConstraintDescription];
    [self createAndSetImage:_imageCommentaire andScrollView:_scrollViewImageCommentaire constraint:_heightConstraintCommentaire];
    
    if (_textViewCommentaire.text.length) {
        _buttonCommentaire.titleLabel.text = @"Modifier le commentaire";
    }
    else _buttonCommentaire.titleLabel.text = @"Ajouter un commentaire";
    
    if (_imageCommentaire) {
        _buttonImage.titleLabel.text = @"Modifier la photo";
    }
    else _buttonImage.titleLabel.text = @"Ajouter une photo";
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

#pragma mark - NavigationView delegate methods

-(void)navigationViewDidPressLeftButton {
    NSAssert([MCViewModel sharedModel].historyStack.count > 1, @"Pressed back button with historystack at 0");
    [MCViewModel sharedModel].currentSection = [MCIntent intentWithSectionName:SECTION_LAST andAnimation:ANIMATION_POP];
}

#pragma mark - WriteCommentDelegate methods

-(void)exitSavingComment:(NSString *)comment {
    _textViewCommentaire.text = comment;
    
    [self reloadView];
    
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
    _imageCommentaire = nil;
    _imageCommentaire = image;
    [self reloadView];
    
    [self dismissViewControllerAnimated:YES completion:^{
        _takePictureVC = nil;
    }];
}

-(void)exitCancellingPicture {
    [self dismissViewControllerAnimated:YES completion:^{
        _takePictureVC = nil;
    }];
}

#pragma mark - ImageView functions
-(void)createAndSetImage:(UIImage *)theImage andScrollView:(UIScrollView *)scrollView constraint:(NSLayoutConstraint *)constraint{
    
    if (theImage) {
        UIImage *image = [theImage resizedImageWithMaximumSize:CGSizeMake(1000, 600)];
        
        [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [scrollView addSubview:imageView];
        
        [scrollView setContentSize:imageView.image.size];
        
        if (scrollView.contentSize.height > 390) {
            [constraint setConstant:390];
        } else constraint.constant = scrollView.contentSize.height;
    }
}

#pragma mark - Utils

- (void)setGoodSizeForTextView:(UITextView *)view {
    [view setFont:[UIFont systemFontOfSize:15]];
    CGSize size = [view.text sizeWithFont:[UIFont systemFontOfSize:15]
                        constrainedToSize:CGSizeMake(view.bounds.size.width, MAX_HEIGHT)
                            lineBreakMode:UILineBreakModeWordWrap];
    
    [view setBounds:CGRectMake(0, 0, view.bounds.size.width, size.height + 10)];
}

- (UIImage *)getPhotoForUrl:(id)url {
    return nil;
}



@end
