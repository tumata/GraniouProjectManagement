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

@interface PTBLoadingVC () <UIAlertViewDelegate>

@property (strong, nonatomic) NSOperationQueue *operationQueue;

@property (weak, nonatomic) IBOutlet UIProgressView *loadingProgress;

@property (strong, nonatomic) UIAlertView *alertView;

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
    _loadingProgress.progress = 0.0;
    
//    _operationQueue = [[NSOperationQueue alloc] init];
//    [_operationQueue setMaxConcurrentOperationCount:1];
//    
//    [_operationQueue addOperation:[[NSInvocationOperation alloc] initWithTarget:[PTBGetChantier sharedInstance] selector:@selector(startSynchronizationWithViewController:) object:self]];
    
    [[PTBGetChantier sharedInstance] startSynchronizationWithViewController:self];
}




- (void)setProgress:(NSNumber *)prog {
    _loadingProgress.progress = [prog floatValue];
}


//-(void)finishedGettingAllData:(NSDictionary *)finishedInfos {
//    
//    NSString *countNotDownloaded = [finishedInfos objectForKey:@"notDownloadedCount"];
//    if ([countNotDownloaded integerValue] > 0) {
//        [self launchAlertView:finishedInfos];
//    } else {
//        MCIntent* intent = [MCIntent intentWithSectionName:SECTION_PROFILE andViewName:VIEW_ACCOUNT];
//        [intent setAnimationStyle:ANIMATION_NOTHING];
//        [[MCViewModel sharedModel] setCurrentSection:intent];
//    }
//}

#pragma mark - Alert view

- (void)launchAlertView:(NSDictionary *)finishedInfos {
    
    NSString *title = @"Attention";
    NSString *description = [NSString stringWithFormat:@"%@ tâches sur %@ n'ont pu être téléchargées", [finishedInfos objectForKey:@"notDownloadedCount"],[finishedInfos objectForKey:@"shouldDownloadCount"]];
    NSString *cancel = @"Réessayer";
    NSString *ok = @"Je comprends";
    
    _alertView = [[UIAlertView alloc] initWithTitle:title message:description delegate:self cancelButtonTitle:cancel otherButtonTitles:ok, nil];
    [_alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self loadChantier];
        
    }
    else if (buttonIndex == 1) {
        // Je comprends
        MCIntent* intent = [MCIntent intentWithSectionName:SECTION_PROFILE andViewName:VIEW_ACCOUNT];
        [intent setAnimationStyle:ANIMATION_NOTHING];
        [[MCViewModel sharedModel] setCurrentSection:intent];
    }
}

@end
