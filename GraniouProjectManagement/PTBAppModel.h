//
//  PTBAppModel.h
//  GraniouProjectManagement
//
//  Created by Yeti LLC on 7/11/14.
//  Copyright (c) 2014 Graniou. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SECTION_PROFILE        @"PTBProfileSectionVC"
#define VIEW_LOGIN             @"PTBLoginVC"
#define VIEW_ACCOUNT           @"PTBAccountVC"


@interface PTBAppModel : NSObject

+ (PTBAppModel*)sharedModel;

@end
