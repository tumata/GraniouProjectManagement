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
- (void)exitSavingPicture;
- (void)exitCancellingPicture;

@end


@interface PTBTakePictureVC : UIViewController

@property (nonatomic, weak) id<PTBTakePictureVCDelegate>delegate;

@end



/*

 ---------------------------------------------
 ---------->  Pour lancer la fenetre :
 ---------------------------------------------
 
 //    PTBTakePictureVC *takePictureVC = [[PTBTakePictureVC alloc] init];
 //    takePictureVC.delegate = self;
 //    _takePictureVC = takePictureVC;
 //    [self presentViewController:_takePictureVC animated:YES completion:nil];
 
 ----------------------------------------------
 ---------->  Delegate a implanter :
 ---------------------------------------------
 
 #pragma mark - TakePictureDelegate methods
 
 - (void)exitSavingPicture:(UIImage *)image {
    [self dismissViewControllerAnimated:YES completion:^{
        _takePictureVC = nil;
    }];
 }
 
 -(void)exitCancellingPicture {
    [self dismissViewControllerAnimated:YES completion:^{
        _takePictureVC = nil;
    }];
 }

 

*/