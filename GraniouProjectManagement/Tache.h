//
//  Tache.h
//  GraniouProjectManagement
//
//  Created by Yeti LLC on 7/21/14.
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
@property (nonatomic, retain) Images *images;
@property (nonatomic, retain) Chantier *chantier;

@end
