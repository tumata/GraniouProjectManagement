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
#import "PTBGetChantier.h"

@interface PTBAccountVC ()


@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *labelTitre;

@property (weak, nonatomic) IBOutlet UIView *viewLoading;
@property (weak, nonatomic) IBOutlet UIImageView *imageLoading;
@property (strong, nonatomic) NSTimer *timer;


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

-(void)onResume:(MCIntent *)intent {
    [super onResume:intent];
    if (!_data)[self setDataFromCore];
}



#pragma mark - Actions

- (IBAction)actionLogin:(id)sender {
    MCIntent* intent = [MCIntent intentWithSectionName:SECTION_MONTEUR andViewName:VIEW_TOPMENU];
    [intent setAnimationStyle:UIViewAnimationOptionTransitionCrossDissolve];
    [[MCViewModel sharedModel] setCurrentSection:intent];
}

- (IBAction)actionLogout:(id)sender {
    
}


#pragma mark - Synchronisation

- (IBAction)actionSync:(id)sender {
    [_viewLoading setHidden:false];

    //_timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:2.0 target:self selector:@selector(rotateView) userInfo:nil repeats:YES];
    [self rotateView];
    
    // Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:@"tachesUploaded" object:nil];
    [[PTBGetChantier sharedInstance] uploadNeededTaches];
}

- (void)receivedNotification:(NSNotification *)notification {
    
    
    [_viewLoading setHidden:true];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tachesUploaded" object:nil];
}

- (void)rotateView {
    _imageLoading.transform = CGAffineTransformMakeRotation(0);
    [UIView animateWithDuration:2.0 animations:^{
        _imageLoading.transform = CGAffineTransformMakeRotation(-M_PI);
        
    } completion:^(BOOL finished) {
        if (!_viewLoading.isHidden) [self rotateView];
    }];
    

    
}



#pragma mark - Core Data function

- (void)setDataFromCore {
    Chantier *chantier = [Chantier MR_findFirst];
    NSEntityDescription *entity = [chantier entity];
    
    NSDictionary *attributes = [entity attributesByName];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    for (NSString *attribute in attributes) {
        id value = [chantier valueForKey: attribute];
        if ([value isKindOfClass:[NSString class]]) {
            if ([attribute isEqualToString:@"nom"]) {
                _labelTitre.text = value;
            } else {
                //NSLog(@"attribute %@ = %@", attribute, value);
                if ([value length] > 0) {
                    NSDictionary *dico;
                    if ([attribute isEqualToString:@"ladate"]) {
                        dico = [NSDictionary dictionaryWithObject:value forKey:@"date"];
                    } else {
                        dico = [NSDictionary dictionaryWithObject:value forKey:attribute];
                    }
                    [data addObject:dico];
                }
            }
        }
    }
    _data = data;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  35;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"customInfosCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dico = [_data objectAtIndex:indexPath.row];
    NSString *key = [[dico allKeys]objectAtIndex:0];
    NSString *value = [dico objectForKey:[[dico allKeys]objectAtIndex:0]];
    
    NSLog(@"attribute %@ = %@", key, value);
    
    cell.textLabel.text = key;
    cell.detailTextLabel.text = value;
    
    return cell;
}


@end
