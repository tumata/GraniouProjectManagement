//
//  PTBAppDelegate.h
//  GraniouProjectManagement
//
//  Created by Yeti LLC on 7/11/14.
//  Copyright (c) 2014 Graniou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) UIViewController *mainVC;     // ADDED

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (UIWindow *)mainWindow;                                    //ADDED
+ (UIViewController *)mainVC;                                //ADDED

@end
