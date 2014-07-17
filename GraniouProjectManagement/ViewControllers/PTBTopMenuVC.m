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

@interface PTBTopMenuVC () <PTBNavigationViewDelegate>

@property (weak, nonatomic) IBOutlet PTBNavigationView *navigationView;

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
    MCIntent* intent = [MCIntent intentWithSectionName:SECTION_MONTEUR andViewName:VIEW_WRITECOMMENT];
    
    
    [intent setAnimationStyle:UIViewAnimationOptionTransitionFlipFromLeft];
    [[MCViewModel sharedModel] setCurrentSection:intent];
    
}
@end
