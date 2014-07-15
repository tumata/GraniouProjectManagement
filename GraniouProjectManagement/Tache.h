//
//  Tache.h
//  GraniouProjectManagement
//
//  Created by Yeti LLC on 7/14/14.
//  Copyright (c) 2014 Graniou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Chantier;

@interface Tache : NSManagedObject

@property (nonatomic, retain) NSString * infos;
@property (nonatomic, retain) NSString * nom;
@property (nonatomic, retain) NSNumber * identifiant;
@property (nonatomic, retain) NSString * commentaire;
@property (nonatomic, retain) NSString * urlPhoto;
@property (nonatomic, retain) NSNumber * modified; // boolean
@property (nonatomic, retain) Chantier *chantier;

@end
