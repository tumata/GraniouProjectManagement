//
//  PTBAppDelegate.m
//  GraniouProjectManagement
//
//  Created by Yeti LLC on 7/11/14.
//  Copyright (c) 2014 Graniou. All rights reserved.
//

#import "PTBAppDelegate.h"
#import "ManticoreViewFactory.h"
#import "PTBAppModel.h"
#import "PTBAuthUser.h"

#import "Tache.h"
#import "Chantier.h"


@implementation PTBAppDelegate


+ (UIWindow*)mainWindow{
    PTBAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    return delegate.window;
}

+ (UIViewController*)mainVC{
    PTBAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    return delegate.mainVC;
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"GraniouDB"];
    
    //[self setupSomeObjectsInDB] ;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    // Register activities
    
    [self registerVCs];
    
    // Run the factory methods
    
    _mainVC = [[MCViewFactory sharedFactory] createViewController:VIEW_BUILTIN_MAIN];               // creates startup page
    [self.window setRootViewController:_mainVC];
    [_mainVC.view setFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    //configure stack size (most apps will be unlimited)
    [MCViewModel sharedModel].stackSize = STACK_SIZE_UNLIMITED;
    
    // Show the main view controller
    
    MCIntent* intent;
    
    if ([PTBAuthUser isLoggedIn]) {
        intent = [MCIntent intentWithSectionName:SECTION_PROFILE andViewName:VIEW_LOADING];
    }
    else {
        intent = [MCIntent intentWithSectionName:SECTION_PROFILE andViewName:VIEW_LOGIN];
    }

    
    // intent = [MCIntent intentWithSectionName:SECTION_PROFILE andViewName:VIEW_ACCOUNT];
    
    
    [intent setAnimationStyle:UIViewAnimationOptionTransitionFlipFromLeft];
    [[MCViewModel sharedModel] setCurrentSection:intent];

   
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Registering the View controllers

-(void) registerVCs {
    
    MCViewFactory *factory = [MCViewFactory sharedFactory];
    [factory registerView:SECTION_PROFILE];
    [factory registerView:SECTION_MONTEUR];
    [factory registerView:VIEW_LOGIN];
    [factory registerView:VIEW_ACCOUNT];
    [factory registerView:VIEW_LOADING];
    [factory registerView:VIEW_TOPMENU];
    [factory registerView:VIEW_CHANTIERMENU]; // 5
    [factory registerView:VIEW_TACHESTABLE];
    [factory registerView:VIEW_TACHE];
    [factory registerView:VIEW_TAKEPICTURE]; // 10
    [factory registerView:VIEW_WRITECOMMENT];
    [factory registerView:VIEW_DOCUMENTSTABLE];
    [factory registerView:VIEW_SHOWPDF];

    
    // the following two lines are optional. Built in activities will show instead.
    //[factory registerView:VIEW_BUILTIN_MAIN];  // comment this line out if you don't create MCMainViewController.xib and subclass MCMainViewController
    //[factory registerView:VIEW_BUILTIN_ERROR]; // comment this line out if you don't create MCErrorViewController.xib and subclass MCErrorViewController
}

#define CHANTIER    @"Chantier"
#define TACHE       @"Tache"


- (void)setupSomeObjectsInDB {
    
    Tache *tache1 = [Tache MR_createEntity];
    tache1.identifiant = [NSNumber numberWithInt:1];
    tache1.titre = @"Regarder le monde";
    tache1.laDescription = @"Aller faire un tour en biccyclette pendant que son frere fait des betises et que ses parents sont a la foire comtoise. Plutot cool comme programme n'est-ce pas ?";
    tache1.type = @"tache";
    
    Tache *tache2 = [Tache MR_createEntity];
    tache2.identifiant = [NSNumber numberWithInt:2];
    tache2.titre = @"Regarder la deux";
    tache2.laDescription = @"Aller faire un tour en biccyclette pendant que son frere fait des betises et que ses parents sont a la foire comtoise. Plutot cool comme programme n'est-ce pas ?";
    tache2.type = @"ldr";
    
    Tache *tache3 = [Tache MR_createEntity];
    tache3.identifiant = [NSNumber numberWithInt:3];
    tache3.titre = @"Regarder le trois";
    tache3.laDescription = @"Aller faire un tour en biccyclette pendant que son frere fait des betises et que ses parents sont a la foire comtoise. Plutot cool comme programme n'est-ce pas ?";
    tache3.type = @"ldr";
    
    Tache *tache4 = [Tache MR_createEntity];
    tache4.identifiant = [NSNumber numberWithInt:4];
    tache4.titre = @"Regarder la quatre";
    tache4.laDescription = @"Aller faire un tour en biccyclette pendant que son frere fait des betises et que ses parents sont a la foire comtoise. Plutot cool comme programme n'est-ce pas ?";
    tache4.type = @"tache";
    
    Chantier *chantier = [Chantier MR_createEntity];
    chantier.nom = @"Le plus beau chantier";
    chantier.adresse = @"Rue de la ruelle";
    chantier.brin = @"120";
    chantier.identifiant = [NSNumber numberWithInt:1];
    [chantier addTachesObject:tache1];
    [chantier addTachesObject:tache2];
    [chantier addTachesObject:tache3];
    [chantier addTachesObject:tache4];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"You successfully saved your context.");
        } else if (error) {
            NSLog(@"Error saving context: %@", error.description);
        }
    }];
}


@end
