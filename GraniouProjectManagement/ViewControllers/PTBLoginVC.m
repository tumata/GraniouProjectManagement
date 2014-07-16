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


@interface PTBLoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *identifiant;
@property (weak, nonatomic) IBOutlet UITextField *mdp;
@property (weak, nonatomic) IBOutlet UIButton    *buttonLogin;

//@property (weak, nonatomic)

@end

@implementation PTBLoginVC

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

- (IBAction)tryConnection:(id)sender {
    UIButton *button = (UIButton *)sender;
    [button setEnabled:false];
    
    
    //[self getUsersJson];
    
    
    
    MCIntent* intent = [MCIntent intentWithSectionName:SECTION_PROFILE andViewName:VIEW_LOADING];
    [intent setAnimationStyle:ANIMATION_PUSH];
    [[MCViewModel sharedModel] setCurrentSection:intent];
}




- (void)getUsersJson {
    NSString *string = [NSString stringWithFormat:@"%@%@", BaseURLString, GetUsersURLString];
    NSURL *url = [NSURL URLWithString:string];
    
}

@end
