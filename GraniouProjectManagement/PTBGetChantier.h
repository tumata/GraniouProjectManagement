//
//  PTBGetChantier.h
//  GraniouProjectManagement
//
//  Created by Yeti LLC on 7/22/14.
//  Copyright (c) 2014 Graniou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTBGetChantier : NSObject

//typedef void (^PTBCompletionBlock)(BOOL succes, NSError *error);

//- (void)startSynchronizingChantierWithProgressView:(UIProgressView *)progressView withCallback:(PTBCompletionBlock)callback;

- (void)startSynchronizingChantier:(UIViewController *)appliedView;

@end