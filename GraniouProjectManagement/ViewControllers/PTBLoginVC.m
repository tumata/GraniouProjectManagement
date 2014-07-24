//
//  PTBLoginVC.m
//  GraniouProjectManagement
//
//  Created by the Manticore iOS View Generator on 2014-07-11.
//  Copyright (c) 2014 GraniouProjectManagement. All rights reserved.
//

#import "PTBLoginVC.h"
#import "PTBAppModel.h"
#import "AFJSONRequestOperation.h"
#import "PTBAuthUser.h"


@interface PTBLoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *identifiant;
@property (weak, nonatomic) IBOutlet UITextField *mdp;
@property (weak, nonatomic) IBOutlet UIButton    *buttonLogin;

@property (weak, nonatomic) IBOutlet UILabel *erreurLabel;
@property (weak, nonatomic) IBOutlet UIView *erreurView;
@property (weak, nonatomic) IBOutlet UIImageView *logoGraniou;


@property (weak, nonatomic) UITextField *currentFieldSelected;

@end


@implementation PTBLoginVC

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
    
    _identifiant.delegate = self;
    _mdp.delegate = self;
    _buttonLogin.enabled = false;
    _erreurView.alpha = 0.0;
    
    NSLog(@"Is logged in : %i", [PTBAuthUser isLoggedIn]);
    
}

-(void)onResume:(MCIntent *)intent {
    // Ne plus recevoir les notifications de keyBoard
    [self registerForKeyboardNotifications];
    [super onResume:intent];
}

-(void)onPause:(MCIntent *)intent {
    // Remettre en place les notifications de keyBoard
   [self unRegisterForKeyboardNotifications];
    [super onPause:intent];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Connection

- (IBAction)tryConnection:(id)sender {
    if (_identifiant.text.length && _mdp.text.length) {
        // Empeche input momentanement
        [sender setEnabled:false];
        
        // Creation d'une instamce AuthUser pour tenter l'authentification
        PTBAuthUser *authUser = [[PTBAuthUser alloc] init];
        [authUser tryLoginUser:self.identifiant.text password:self.mdp.text withCallback:^(BOOL success, NSError *error) {
            if (success) {
                
                // On descend la vue et le keyboard
                [_currentFieldSelected resignFirstResponder];
                [self viewGoDown];
                
                MCIntent* intent = [MCIntent intentWithSectionName:SECTION_PROFILE andViewName:VIEW_LOADING];
                [intent setAnimationStyle:ANIMATION_PUSH];
                [[MCViewModel sharedModel] setCurrentSection:intent];
            }
            else {
                // On redonne la possibilite de cliquer
                [sender setEnabled:true];
                // Annonce erreur de saisie
                [self displayErrorViewAnimated:error];
                // Remise champ mdp vide
                _mdp.text = @"";
            }
        }];
    }
}

#pragma mark - errorView Animations

- (void)displayErrorViewAnimated:(NSError *)error {
   
    _erreurLabel.text = [error domain];
    
    
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         _erreurView.alpha = 1.0;
                     }completion:^(BOOL finished){
                         [UIView animateWithDuration:2.0
                                           animations:^{
                                               _erreurView.alpha = 0.0;
                                           }];
                     }];
}


- (void) updateActivityIndicator:(NSTimer *)incomingTimer {
    _erreurView.hidden = true;
}


#pragma mark - KeyBoard notifications and slide

//-------------------------------------------------------
// Notification lorsque debut d'edit du textField
//
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _currentFieldSelected = textField;
}


//-------------------------------------------------------
//   Notification lorsque fin d'edit du textField
//
- (void)textFieldDidEndEditing:(UITextField *)textField {
    _currentFieldSelected = nil;
}


//-------------------------------------------------------
//  Notifications lorsque le clavier apparait / disparait
//
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
}

- (void)unRegisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)aNotification {
    [self viewGoUp];
    [_buttonLogin setEnabled:true];
}

#pragma mark - Translations de la vue principale

- (void)viewGoUp {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    // Vue globale
    CGPoint center = self.view.center;
    center.y -= 150;
    self.view.center = CGPointMake(center.x, center.y);
    
    // Logo Graniou
    _logoGraniou.center = CGPointMake(_logoGraniou.center.x,
                                      _logoGraniou.center.y +100);
    
    [UIView commitAnimations];
}

- (void)viewGoDown {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    
    // Vue globale
    CGPoint center = self.view.center;
    center.y += 150;
    self.view.center = CGPointMake(center.x, center.y);
    
    // Logo Graniou
    _logoGraniou.center = CGPointMake(_logoGraniou.center.x,
                                      _logoGraniou.center.y -100);
    [UIView commitAnimations];
}

@end
