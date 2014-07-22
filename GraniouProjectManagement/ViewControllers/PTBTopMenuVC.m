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

#import "Tache.h"

@interface PTBTopMenuVC () <PTBNavigationViewDelegate>

@property (weak, nonatomic) IBOutlet PTBNavigationView *navigationView;

@property (weak, nonatomic) PTBWriteCommentVC *writeCommentVC;
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
    NSAssert([MCViewModel sharedModel].historyStack.count > 1, @"Pressed back button with historystack at 0");
    [MCViewModel sharedModel].currentSection = [MCIntent intentWithSectionName:SECTION_LAST andAnimation:ANIMATION_POP];
    
}

- (void)navigationViewDidPressRightButton {
    NSLog(@"ok");
}

- (IBAction)pressBouton:(id)sender {
    
    Tache *tache = [Tache MR_findFirstByAttribute:@"type" withValue:@"tache"];
    
    MCIntent* intent = [MCIntent intentWithSectionName:SECTION_MONTEUR andViewName:VIEW_TACHE];
    [intent setAnimationStyle:UIViewAnimationOptionTransitionCrossDissolve];
    
    [[intent savedInstanceState] setObject:tache forKey:@"source"];
    
    [[MCViewModel sharedModel] setCurrentSection:intent];
    
}


- (IBAction)pressLR:(id)sender {
    Tache *tache = [Tache MR_findFirstByAttribute:@"type" withValue:@"ldr"];
    
    MCIntent* intent = [MCIntent intentWithSectionName:SECTION_MONTEUR andViewName:VIEW_TACHE];
    [intent setAnimationStyle:UIViewAnimationOptionTransitionCrossDissolve];
    
    [[intent savedInstanceState] setObject:tache forKey:@"source"];
    
    [[MCViewModel sharedModel] setCurrentSection:intent];
}

@end
