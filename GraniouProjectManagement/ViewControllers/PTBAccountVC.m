//
//  PTBAccountVC.m
//  GraniouProjectManagement
//
//  Created by the Manticore iOS View Generator on 2014-07-11.
//  Copyright (c) 2014 GraniouProjectManagement. All rights reserved.
//

#import "PTBAccountVC.h"

@interface PTBAccountVC ()

@property (weak, nonatomic) IBOutlet UILabel *labelTitre;
@property (weak, nonatomic) IBOutlet UILabel *labelAdresse;
@property (weak, nonatomic) IBOutlet UILabel *labelCodeSite;
@property (weak, nonatomic) IBOutlet UILabel *labelBrin;
@property (weak, nonatomic) IBOutlet UILabel *labelPhase;
@property (weak, nonatomic) IBOutlet UILabel *labelAmenageur;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;


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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionLogout:(id)sender {
}

- (IBAction)actionLogin:(id)sender {
}

- (IBAction)actionSync:(id)sender {
}
@end
