//
//  PTBLoadingVC.h
//  GraniouProjectManagement
//
//  Created by the Manticore iOS View Generator on 2014-07-15.
//  Copyright (c) 2014 GraniouProjectManagement. All rights reserved.
//

#import "MCViewController.h"

@interface PTBLoadingVC : MCViewController

- (IBAction)buttonPressed:(id)sender;

- (void)setProgress:(NSNumber *)prog;

// keys :
//      "notDownloadedCount" : "string"
//      "shouldDownloadCount" : "string"
- (void)finishedGettingAllData:(NSDictionary *)finishedInfos;

@end
