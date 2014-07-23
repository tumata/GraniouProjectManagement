//
//  Chantier.h
//  GraniouProjectManagement
//
//  Created by Yeti LLC on 7/22/14.
//  Copyright (c) 2014 Graniou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IdentifiantsTaches, Tache;

@interface Chantier : NSManagedObject

@property (nonatomic, retain) NSString * adresse;
@property (nonatomic, retain) NSString * amenageur;
@property (nonatomic, retain) NSString * brin;
@property (nonatomic, retain) NSString * codesite;
@property (nonatomic, retain) NSNumber * identifiant;
@property (nonatomic, retain) NSString * ladate;
@property (nonatomic, retain) NSString * ligne;
@property (nonatomic, retain) NSString * nom;
@property (nonatomic, retain) NSString * partenaire;
@property (nonatomic, retain) NSString * phase;
@property (nonatomic, retain) NSString * pk;
@property (nonatomic, retain) NSString * recetteur;
@property (nonatomic, retain) NSString * region;
@property (nonatomic, retain) NSSet *taches;
@property (nonatomic, retain) NSSet *listeTaches;
@end

@interface Chantier (CoreDataGeneratedAccessors)

- (void)addTachesObject:(Tache *)value;
- (void)removeTachesObject:(Tache *)value;
- (void)addTaches:(NSSet *)values;
- (void)removeTaches:(NSSet *)values;

- (void)addListeTachesObject:(IdentifiantsTaches *)value;
- (void)removeListeTachesObject:(IdentifiantsTaches *)value;
- (void)addListeTaches:(NSSet *)values;
- (void)removeListeTaches:(NSSet *)values;

@end
