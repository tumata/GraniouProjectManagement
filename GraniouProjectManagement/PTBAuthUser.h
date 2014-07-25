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
typedef void (^PTBInfosCompletionBlock)(NSDictionary *infos);


+ (bool)isLoggedIn;
+ (NSString *)getIDChantier;

+ (BOOL)isAllTachesDownloaded;

- (void)tryLoginUser:(NSString *)username password:(NSString *)pass withCallback:(PTBCompletionBlock)callback;

- (void)tryLogoutUserWithCallback:(PTBInfosCompletionBlock)callback;

+ (void)forceLogout;

@end
