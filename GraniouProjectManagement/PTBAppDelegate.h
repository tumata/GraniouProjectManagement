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
@property (strong, nonatomic) UIViewController *mainVC;


- (NSURL *)applicationDocumentsDirectory;

+ (UIWindow *)mainWindow;
+ (UIViewController *)mainVC;

@end
