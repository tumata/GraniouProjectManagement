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

#import "Chantier.h"
#import "Tache.h"
#import "LeveeReserve.h"

@implementation PTBAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


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
    
    MCIntent* intent = [MCIntent intentWithSectionName:SECTION_PROFILE andViewName:VIEW_LOGIN];      //Understand section/view
    [intent setAnimationStyle:UIViewAnimationOptionTransitionFlipFromLeft];
    [[MCViewModel sharedModel] setCurrentSection:intent];

    //[self tutorial];
    
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
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GraniouProjectManagement" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GraniouProjectManagement.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
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
    [factory registerView:VIEW_LOGIN];
    [factory registerView:VIEW_ACCOUNT];

    
    // the following two lines are optional. Built in activities will show instead.
    //[factory registerView:VIEW_BUILTIN_MAIN];  // comment this line out if you don't create MCMainViewController.xib and subclass MCMainViewController
    //[factory registerView:VIEW_BUILTIN_ERROR]; // comment this line out if you don't create MCErrorViewController.xib and subclass MCErrorViewController
}

#define CHANTIER    @"Chantier"
#define TACHE       @"Tache"
#define LR          @"LeveeReserve"

-(void) tutorial {
    NSManagedObjectContext *context = [self managedObjectContext];
    Chantier *chantier = [NSEntityDescription
                                      insertNewObjectForEntityForName:CHANTIER
                                      inManagedObjectContext:context];
    chantier.identifiant = [NSNumber numberWithInt:1];
    chantier.adresse = @"Testville";
    chantier.codesite = @"Testland";
    
    Tache *tache = [NSEntityDescription
                                            insertNewObjectForEntityForName:TACHE
                                            inManagedObjectContext:context];
    tache.nom = @"tache 1";
    tache.chantier = chantier;
    
    [chantier addTachesObject:tache];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    // Test listing all FailedBankInfos from the store
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:CHANTIER
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (Chantier *chantier in fetchedObjects) {
        NSLog(@"Adresse: %@", chantier.adresse);
        Tache *tache = [chantier.taches anyObject];
        NSLog(@"Zip: %@", tache.nom);
    }

}


@end
