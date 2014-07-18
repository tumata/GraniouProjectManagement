//
//  PTBTakePictureVC.h
//  GraniouProjectManagement
//
//  Created by the Manticore iOS View Generator on 2014-07-15.
//  Copyright (c) 2014 GraniouProjectManagement. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PTBTakePictureVCDelegate <NSObject>

@required
- (void)exitSavingPicture:(UIImage *)image;
- (void)exitCancellingPicture;

@end


@interface PTBTakePictureVC : UIViewController

@property (nonatomic, weak) id<PTBTakePictureVCDelegate>delegate;

@end
