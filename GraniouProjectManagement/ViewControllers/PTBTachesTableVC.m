//
//  PTBTachesTableVC.m
//  GraniouProjectManagement
//
//  Created by the Manticore iOS View Generator on 2014-07-15.
//  Copyright (c) 2014 GraniouProjectManagement. All rights reserved.
//

#import "PTBTachesTableVC.h"
#import "Tache.h"

#define kTYPE @"type"
#define kID @"identifiant"
#define kNom @"titre"
#define kInfo @"laDescription"
#define kCommentaire @"commentaire"
#define kPhotoCommentaire @"images.imageCommentaire"

@interface PTBTachesTableVC () <PTBNavigationViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *sourceType;
@property (strong, nonatomic) NSArray *sourceArray;

@property (weak, nonatomic) IBOutlet PTBNavigationView *navigationView;


@end

@implementation PTBTachesTableVC

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _navigationView.delegate = self;
    [self reloadDataAndView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onResume:(MCIntent *)intent {
    
    id type = [[intent savedInstanceState] objectForKey:@"sourceType"];
    
    // On s'assure que le type est "tache" ou "ldr", a modifier dans le futur
    NSAssert([[type description] isEqualToString:@"tache"] || [[type description] isEqualToString:@"ldr"], @"Mauvais type donne en source pour la table");
    
    // Affectation du type
    _sourceType = [type description];
    
    [super onResume:intent];
}

-(void)onPause:(MCIntent *)intent {
    [super onPause:intent];
}


-(void)reloadDataAndView {
    _sourceArray = [Tache MR_findByAttribute:kTYPE withValue:_sourceType andOrderBy:kID ascending:NO];
    [_tableView reloadData];
}

#pragma mark - NavigationView Delegate Methods

-(void)navigationViewDidPressLeftButton {
    NSAssert([MCViewModel sharedModel].historyStack.count > 1, @"Pressed back button with historystack at 0");
    [MCViewModel sharedModel].currentSection = [MCIntent intentWithSectionName:SECTION_LAST andAnimation:ANIMATION_POP];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sourceArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    Tache *tache = [_sourceArray objectAtIndex:indexPath.row];
    
    if ([(NSString *)[tache valueForKey:kCommentaire] length] > 0 || [tache valueForKeyPath:kPhotoCommentaire]) {
        [cell.imageView setImage:[UIImage imageNamed:@"check.png"]];
    } else {
        [cell.imageView setImage:[UIImage imageNamed:@"unCheck.png"]];
    }
    cell.textLabel.text = [tache valueForKey:kNom];
    cell.detailTextLabel.text = [tache valueForKey:@"laDescription"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tache *tache = [_sourceArray objectAtIndex:indexPath.row];
    
    MCIntent* intent = [MCIntent intentWithSectionName:SECTION_MONTEUR andViewName:VIEW_TACHE];
    
    [intent setAnimationStyle:UIViewAnimationOptionTransitionCrossDissolve];
    
    [[intent savedInstanceState] setObject:tache forKey:@"source"];
    [[MCViewModel sharedModel] setCurrentSection:intent];

}

@end
