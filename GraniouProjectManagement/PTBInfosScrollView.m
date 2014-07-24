//
//  PTBInfosScrollView.m
//  GraniouProjectManagement
//
//  Created by Philippe Tumata on 23/07/2014.
//  Copyright (c) 2014 Graniou. All rights reserved.
//

#import "PTBInfosScrollView.h"
#import "Chantier.h"

@interface PTBInfosScrollView() <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UIView *view;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *tableViewCell;

@property (strong, nonatomic) NSArray *data;

@end

@implementation PTBInfosScrollView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // 1. Load xib
        [[NSBundle mainBundle] loadNibNamed:@"PTBInfosScrollView" owner:self options:nil];
        
        // 2. add as subview
        [self addSubview:self.view];
        
        // 3. Custom stuff
        [self customInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // 1. Load the interface from .xib
        [[NSBundle mainBundle] loadNibNamed:@"PTBInfosScrollView" owner:self options:nil];
        // 2. Add as subview
        [self addSubview:self.view];
        
        // 3. Custom stuff
        [self customInitialization];
        
    }
    return self;
}


- (void)customInitialization {
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    [self setDataFromCore];
    
    [_tableView reloadData];
    
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
            NSLog(@"attribute %@ = %@", attribute, value);
            if ([value length] > 0) {
                NSDictionary *dico = [NSDictionary dictionaryWithObject:value forKey:attribute];
                [data addObject:dico];
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
    return  40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
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
