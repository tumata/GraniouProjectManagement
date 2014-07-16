//
//  PTBAuthUser.m
//  GraniouProjectManagement
//
//  Created by Yeti LLC on 7/15/14.
//  Copyright (c) 2014 Graniou. All rights reserved.
//

#import "PTBAuthUser.h"

@implementation PTBAuthUser


+ (PTBAuthUser*)sharedModel {
    static PTBAuthUser *sharedModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedModel = [[self alloc] init];
    });
    return sharedModel;
}

-(id)init {
	self = [super init];
	if (self != nil) {
    }
    return self;
}




@end
