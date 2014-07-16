//
//  PTBAuthUser.h
//  GraniouProjectManagement
//
//  Created by Yeti LLC on 7/15/14.
//  Copyright (c) 2014 Graniou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTBAuthUser : NSObject

@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *droitAcces;
@property (nonatomic, strong) NSString *idChantier;


+ (PTBAuthUser*)sharedModel;

@end
