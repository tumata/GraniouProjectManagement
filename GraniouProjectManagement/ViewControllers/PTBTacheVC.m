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
#import "Images.h"

@interface PTBTacheVC () <PTBWriteCommentDelegate, PTBTakePictureVCDelegate, PTBNavigationViewDelegate>

@property (strong, nonatomic) NSManagedObject *source;

@property (weak, nonatomic) IBOutlet PTBNavigationView *navigationView;

@property (strong, nonatomic) PTBWriteCommentVC *writeCommentVC;
@property (strong, nonatomic) PTBTakePictureVC *takePictureVC;

@property (weak, nonatomic) IBOutlet UILabel *labelTitre;
@property (weak, nonatomic) IBOutlet UIButton *buttonCommentaire;
@property (weak, nonatomic) IBOutlet UIButton *buttonImage;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (weak, nonatomic) IBOutlet UITextView *textViewCommentaire;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewGlobal;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewImageDescription;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewImageCommentaire;

@property (strong, nonatomic) NSString *commentaire;
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
    
    _scrollViewGlobal.scrollsToTop = YES;
    _navigationView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"viewDidAppear");
    [self reloadView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onResume:(MCIntent *)intent {
    NSAssert([intent.savedInstanceState objectForKey:@"source"], @"Pas d'ID recu");
    [self setSource:[intent.savedInstanceState objectForKey:@"source"]];
    
    // Affiche classe selectionee
    NSLog(@"%@", [[_source superclass] description]);
    
    // Test que source est instance de NSManagedObject
    NSAssert([[[_source superclass] description] isEqualToString:@"NSManagedObject"], @"Mausaise classe _source dans tache");
    
    [super onResume:intent];
}

-(void)onPause:(MCIntent *)intent {
    // Remove all heavy stuff from there
    _source = nil;
    
    _imageCommentaire = nil;
    _imageDescription = nil;
    [[_scrollViewImageCommentaire subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [[_scrollViewImageDescription subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [_scrollViewGlobal setContentOffset:CGPointZero animated:NO];
    
    NSLog(@"pause");
    
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
    
    _commentaire = [commentaire description];
    _labelTitre.text = [titre description];
    _textViewDescription.text = [description description];
    
    
    NSData *imageDescription = [_source valueForKeyPath:@"images.imageDescription"];
    if (imageDescription) _imageDescription = [UIImage imageWithData:imageDescription];
    
    NSData *imageCommentaire = [_source valueForKeyPath:@"images.imageCommentaire"];
    if (imageCommentaire) _imageCommentaire = [UIImage imageWithData:imageCommentaire];
}

-(void)reloadView {
    // Creation des images si elles sont la
    [self createAndSetImage:_imageDescription andScrollView:_scrollViewImageDescription constraint:_heightConstraintDescription];
    [self createAndSetImage:_imageCommentaire andScrollView:_scrollViewImageCommentaire constraint:_heightConstraintCommentaire];
    
    // Commentaire
    _textViewCommentaire.text = _commentaire;
    
    // Contenu des boutons
    if (_commentaire.length > 0) {
        [_buttonCommentaire setSelected:0];
        [_buttonCommentaire setTitle:@"Modifier le commentaire" forState:UIControlStateNormal];
    }
    else {
        [_buttonCommentaire setSelected:0];
        [_buttonCommentaire setTitle:@"Ajouter un commentaire" forState:UIControlStateNormal];
    }
    
    if (_imageCommentaire) {
        [_buttonImage setSelected:0];
        [_buttonImage setTitle:@"Modifier la photo" forState:UIControlStateNormal];
    }
    else {
        [_buttonImage setSelected:0];
        [_buttonImage setTitle:@"Ajouter une photo" forState:UIControlStateNormal];
    }
    
    // Taille des textView
    [self setGoodSizeForTextView:_textViewDescription];
    [self setGoodSizeForTextView:_textViewCommentaire];
}


#pragma mark - Actions

- (IBAction)actionCommentaire:(id)sender {
    PTBWriteCommentVC *writeCommentVC = [[PTBWriteCommentVC alloc] init];
    writeCommentVC.delegate = self;
    [writeCommentVC setCommentaire: _commentaire];
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
    
    comment = [self makeSureStringIsCompliant:comment];
    _commentaire = comment;
    [self saveCommentToPersistantStore];
    
    [self dismissViewControllerAnimated:YES completion:^{
        _writeCommentVC = nil;
        
    }];
    
    [self reloadView];
}

-(void)exitCancelling {
    [self dismissViewControllerAnimated:YES completion:^{
        _writeCommentVC = nil;
        [self reloadView];
    }];
}

#pragma mark - TakePicturesDelegate methods

-(void)exitSavingPicture:(UIImage *)image {
    _imageCommentaire = nil;
    _imageCommentaire = image;
    [self savePictureToPersistantStore];
    
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
        
        if (scrollView.subviews.count > 0) {
            [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
    
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [scrollView addSubview:imageView];
        
        [scrollView setContentSize:imageView.image.size];
        
        if (scrollView.contentSize.height > 390) {
            [constraint setConstant:390];
        } else constraint.constant = scrollView.contentSize.height;
    }
    else {
        [constraint setConstant:0];
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

- (NSString *)makeSureStringIsCompliant:(NSString *)mot {
    
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"$\\][{}/"];
    return [[mot componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
}

#pragma mark - Persistant store functions

- (void)saveCommentToPersistantStore {
    [_source setValue:_commentaire forKey:@"commentaire"];
    
    [[_source managedObjectContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"Saved Comment succes");
        }
        else NSLog(@"Error saving comment : %@", error.localizedDescription);
    }];
}

- (void)savePictureToPersistantStore {
    NSData *imageData = UIImageJPEGRepresentation(_imageCommentaire, 1.0);
    
    if (![_source valueForKeyPath:@"images.imageCommentaire"]) {
        Images *image = [Images MR_createEntity];
        image.imageCommentaire = imageData;
        
        [_source setValue:image forKey:@"images"];
    }
    else {
        [_source setValue:imageData forKeyPath:@"images.imageCommentaire"];
    }
    
    
    [[_source managedObjectContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"Saved image with succes");
        }
        else NSLog(@"Error saving image : %@", error.localizedDescription);
    }];

}



@end
