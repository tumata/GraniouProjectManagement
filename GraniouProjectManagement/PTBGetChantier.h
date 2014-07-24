//
//  PTBGetChantier.h
//  GraniouProjectManagement
//
//  Created by Yeti LLC on 7/22/14.
//  Copyright (c) 2014 Graniou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTBGetChantier : NSObject


+ (PTBGetChantier *)sharedInstance;

// return TRUE if it started

- (BOOL)startSynchronization;
- (BOOL)startSynchronizationWithViewController:(UIViewController *)appliedView;


@end
