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


- (NSURL *)applicationDocumentsDirectory;

+ (UIWindow *)mainWindow;                                    //ADDED
+ (UIViewController *)mainVC;                                //ADDED

@end
