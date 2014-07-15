//
//  PTBAppModel.m
//  GraniouProjectManagement
//
//  Created by Yeti LLC on 7/11/14.
//  Copyright (c) 2014 Graniou. All rights reserved.
//

#import "PTBAppModel.h"

@implementation PTBAppModel

// http://www.galloway.me.uk/tutorials/singleton-classes/

+ (PTBAppModel*)sharedModel {
    static PTBAppModel *sharedModel = nil;
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


-(void)loginOrWelcome:(MCIntent *)passThroughIntent {
    
}


@end
