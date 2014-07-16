//
//  PTBAuthUser.h
//  GraniouProjectManagement
//
//  Created by Yeti LLC on 7/15/14.
//  Copyright (c) 2014 Graniou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTBAuthUser : NSObject

typedef void (^PTBCompletionBlock)(BOOL succes, NSError *error);


+ (bool)isLoggedIn;
+ (NSString *)getIDChantier;

- (void)tryLoginUser:(NSString *)username password:(NSString *)pass withCallback:(PTBCompletionBlock)callback;

@end
