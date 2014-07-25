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

- (void)uploadNeededTaches;
@end


///////////////////////
// Documentation :
///////////////////////


// Signals :

// Ce signal ne peut etre appele qu'une seule fois par synchronisation
//      "tachesDownloaded" + userInfo :
//                                  "notDownloadedCount"
//                                  "shouldDownloadCount"


// Ce signal peut etre appele plusieurs fois par synchronisation
//      "tachesUploaded"   + userInfo :
//                                  "uploaded" : @"1" or @"0"
