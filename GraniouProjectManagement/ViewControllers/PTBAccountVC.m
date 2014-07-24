//
//  PTBAccountVC.m
//  GraniouProjectManagement
//
//  Created by the Manticore iOS View Generator on 2014-07-11.
//  Copyright (c) 2014 GraniouProjectManagement. All rights reserved.
//

#import "PTBAccountVC.h"
#import "Chantier.h"
#import "PTBInfosScrollView.h"

@interface PTBAccountVC ()


@property (weak, nonatomic) IBOutlet PTBInfosScrollView *infosScrollView;



- (IBAction)actionLogout:(id)sender;
- (IBAction)actionLogin:(id)sender;
- (IBAction)actionSync:(id)sender;

@end

@implementation PTBAccountVC

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Actions

- (IBAction)actionLogout:(id)sender {
    NSLog(@"%@", NSStringFromCGRect([_infosScrollView frame]));
}

- (IBAction)actionLogin:(id)sender {
    MCIntent* intent = [MCIntent intentWithSectionName:SECTION_MONTEUR andViewName:VIEW_TOPMENU];
    [intent setAnimationStyle:UIViewAnimationOptionTransitionCrossDissolve];
    [[MCViewModel sharedModel] setCurrentSection:intent];
}

- (IBAction)actionSync:(id)sender {
}

@end
