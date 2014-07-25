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

@interface PTBTopMenuVC () <PTBNavigationViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet PTBNavigationView *navigationView;


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
    NSAssert([MCViewModel sharedModel].historyStack.count >= 1, @"Pressed back button with historystack at 0");
    [MCViewModel sharedModel].currentSection = [MCIntent intentWithSectionName:SECTION_LAST andAnimation:ANIMATION_POP];
    
}

- (void)navigationViewDidPressRightButton {
    NSLog(@"ok");
}

- (void)listeTachesBoutonPressed {
    MCIntent* intent = [MCIntent intentWithSectionName:SECTION_MONTEUR andViewName:VIEW_TACHESTABLE];
    [intent setAnimationStyle:UIViewAnimationOptionTransitionCrossDissolve];
    
    [[intent savedInstanceState] setObject:@"tache" forKey:@"sourceType"];
    
    [[MCViewModel sharedModel] setCurrentSection:intent];
}



- (void)listeLRBoutonPressed {
    MCIntent* intent = [MCIntent intentWithSectionName:SECTION_MONTEUR andViewName:VIEW_TACHESTABLE];
    [intent setAnimationStyle:UIViewAnimationOptionTransitionCrossDissolve];
    
    [[intent savedInstanceState] setObject:@"ldr" forKey:@"sourceType"];
    
    [[MCViewModel sharedModel] setCurrentSection:intent];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  ([[UIScreen mainScreen] bounds].size.height - 64) / 3 ;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"customInfosCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Liste des tâches";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Levées de réserve";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"Documents";
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:false];
    
    if (indexPath.row == 0) {
        [self listeTachesBoutonPressed];
    } else if (indexPath.row == 1) {
        [self listeLRBoutonPressed];
    } else if (indexPath.row == 2) {
        NSLog(@"Documents");
    }
}


@end
