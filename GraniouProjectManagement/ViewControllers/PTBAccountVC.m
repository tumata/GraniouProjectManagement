//
//  PTBAccountVC.m
//  GraniouProjectManagement
//
//  Created by the Manticore iOS View Generator on 2014-07-11.
//  Copyright (c) 2014 GraniouProjectManagement. All rights reserved.
//

#import "PTBAccountVC.h"
#import "Chantier.h"

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
   
    [self setDataFromCore];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Actions

- (IBAction)actionLogout:(id)sender {
}

- (IBAction)actionLogin:(id)sender {
    MCIntent* intent = [MCIntent intentWithSectionName:SECTION_MONTEUR andViewName:VIEW_TOPMENU];
    [intent setAnimationStyle:UIViewAnimationOptionTransitionCrossDissolve];
    [[MCViewModel sharedModel] setCurrentSection:intent];
}

- (IBAction)actionSync:(id)sender {
}

#pragma mark - Core Data function

- (void)setDataFromCore {
    Chantier *chantier = [Chantier MR_findFirst];
    
//    chantier.codesite = @"code 1634";
//    chantier.phase = @"153 1634";
//    chantier.amenageur = @"Vinci autoroutes";
//    chantier.ladate = @"01/02/1992";
    
    _labelTitre.text = chantier.nom;
    _labelAdresse.text = chantier.adresse;
    _labelCodeSite.text = chantier.codesite;
    _labelBrin.text = chantier.brin;
    _labelPhase.text = chantier.phase;
    _labelAmenageur.text = chantier.amenageur;
    _labelDate.text = chantier.ladate;
    
//    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
//        if (success) {
//            NSLog(@"You successfully saved your context.");
//        } else if (error) {
//            NSLog(@"Error saving context: %@", error.description);
//        }
//    }];
}

@end
