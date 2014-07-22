//
//  PTBWriteCommentVC.h
//  GraniouProjectManagement
//
//  Created by the Manticore iOS View Generator on 2014-07-15.
//  Copyright (c) 2014 GraniouProjectManagement. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PTBWriteCommentDelegate <NSObject>

@required
- (void)exitSavingComment:(NSString *)comment;
- (void)exitCancelling;

@end


@interface PTBWriteCommentVC : UIViewController

@property (nonatomic, weak) id<PTBWriteCommentDelegate>delegate;

- (void)setCommentaire:(NSString *)commentaire;

@end


/*
 ---------------------------------------------
---------->  Pour lancer la fenetre :
 ---------------------------------------------

PTBWriteCommentVC *writeCommentVC = [[PTBWriteCommentVC alloc] init];
writeCommentVC.delegate = self;
_writeCommentVC = writeCommentVC;
[self presentViewController:self.writeCommentVC animated:YES completion:nil];


----------------------------------------------
---------->  Delegate a implanter :
 ---------------------------------------------

#pragma mark - WriteCommentDelegate methods

-(void)exitSavingComment:(NSString *)comment {
    [self dismissViewControllerAnimated:YES completion:^{
        _writeCommentVC = nil;
    }];
}

-(void)exitCancelling {
    [self dismissViewControllerAnimated:YES completion:^{
        _writeCommentVC = nil;
    }];
}
 
 */
