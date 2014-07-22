//
//  Tache.h
//  GraniouProjectManagement
//
//  Created by Yeti LLC on 7/22/14.
//  Copyright (c) 2014 Graniou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Chantier, Images;

@interface Tache : NSManagedObject

@property (nonatomic, retain) NSString * commentaire;
@property (nonatomic, retain) NSNumber * identifiant;
@property (nonatomic, retain) NSString * laDescription;
@property (nonatomic, retain) NSNumber * modified;
@property (nonatomic, retain) NSString * titre;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Chantier *chantier;
@property (nonatomic, retain) Images *images;

@end
