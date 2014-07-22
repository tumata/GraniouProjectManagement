//
//  Images.h
//  GraniouProjectManagement
//
//  Created by Yeti LLC on 7/22/14.
//  Copyright (c) 2014 Graniou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tache;

@interface Images : NSManagedObject

@property (nonatomic, retain) NSData * imageCommentaire;
@property (nonatomic, retain) NSData * imageDescription;
@property (nonatomic, retain) Tache *parent;

@end
