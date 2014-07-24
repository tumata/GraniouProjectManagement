//
//  PTBLoadingVC.m
//  GraniouProjectManagement
//
//  Created by the Manticore iOS View Generator on 2014-07-15.
//  Copyright (c) 2014 GraniouProjectManagement. All rights reserved.
//

#import "PTBLoadingVC.h"
#import "PTBAppModel.h"
#import "PTBGetChantier.h"

@interface PTBLoadingVC ()

@property (strong, nonatomic) NSOperationQueue *operationQueue;

@property (weak, nonatomic) IBOutlet UIProgressView *loadingProgress;



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
    
    NSLog(@"ViewDidLoad !!!!!!!!!!!!!!!!!!!!");
    [self loadChantier];
    
}



-(void)onPause:(MCIntent *)intent {
    
    [super onPause:intent];
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



- (void)loadChantier {
    PTBGetChantier *getChantier = [[PTBGetChantier alloc] initWithView:self];
    _operationQueue = [[NSOperationQueue alloc] init];
    [_operationQueue setMaxConcurrentOperationCount:1];
    
    [_operationQueue addOperation:getChantier];
}




- (void)setProgress:(NSNumber *)prog {
    _loadingProgress.progress = [prog floatValue];
}

-(void)finishedGettingAllData {
    MCIntent* intent = [MCIntent intentWithSectionName:SECTION_PROFILE andViewName:VIEW_ACCOUNT];
    [intent setAnimationStyle:ANIMATION_NOTHING];
    [[MCViewModel sharedModel] setCurrentSection:intent];

}
@end
