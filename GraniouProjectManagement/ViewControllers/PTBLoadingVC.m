//
//  PTBLoadingVC.m
//  GraniouProjectManagement
//
//  Created by the Manticore iOS View Generator on 2014-07-15.
//  Copyright (c) 2014 GraniouProjectManagement. All rights reserved.
//

#import "PTBLoadingVC.h"
#import "PTBAppModel.h"

@interface PTBLoadingVC ()

@end

@implementation PTBLoadingVC

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
    MCIntent* intent = [MCIntent intentWithSectionName:SECTION_PROFILE andViewName:VIEW_ACCOUNT];
    [intent setAnimationStyle:ANIMATION_NOTHING];
    [[MCViewModel sharedModel] setCurrentSection:intent];
}
@end
