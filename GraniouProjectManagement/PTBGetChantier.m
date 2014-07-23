//
//  PTBGetChantier.m
//  GraniouProjectManagement
//
//  Created by Yeti LLC on 7/22/14.
//  Copyright (c) 2014 Graniou. All rights reserved.
//

#import "PTBGetChantier.h"
#import "PTBAuthUser.h"
#import "Chantier.h"
#import "IdentifiantsTaches.h"
#import "Tache.h"
#import "PTBLoadingVC.h"



// Liens et clefs pour recuperer depuis le serveur
#define kBaseURLString          @"http://graniou-rail-project.fr/WebService/"
#define kChantierUrlString      @"chantier.php?id_chantier="
#define kTacheUrlString         @"data.php?"



@interface PTBGetChantier()

@property (strong, nonatomic) NSMutableDictionary *tachesToUpload;
@property (strong, nonatomic) NSMutableDictionary *tachesToDownload;


// Related VC
@property (weak, nonatomic) PTBLoadingVC *loadingVC;
@property (strong, nonatomic) NSNumber *progress;


@end

@implementation PTBGetChantier


//--------------------------------------------
// Fonction principale permettant la connection
//
- (void)startSynchronizingChantier:(UIViewController *)appliedView {
    
    if ([appliedView isKindOfClass:[PTBLoadingVC class]]) {
        _loadingVC = (PTBLoadingVC *)appliedView;
    }
    else NSAssert(true, @"appliedView not a PTBLoadingVC");
    
    
    // -----------------------------------------
    // Verifier que user authentifie et chantier
    //
    NSAssert([PTBAuthUser isLoggedIn], @"Pas logge...");
    if (![PTBAuthUser isLoggedIn]) return;
    
    
    // -----------------------------------------
    // Initialisations
    //
    _progress = [NSNumber numberWithFloat:0.0];
    [_loadingVC performSelectorOnMainThread:@selector(setProgress:) withObject:_progress waitUntilDone:NO];
    
    
    
    // ------------------------------------------------
    // Uploader tout ce qui n'a pas ete uploade
    // Si fail, pas grave, mais on ne retelecharge rien
    //
    //[self uploadNeededTaches];
    //[self performSelector:@selector(uploadNeededTaches) onThread:[NSThread currentThread] withObject:NULL waitUntilDone:YES];
    

    // -----------------------------------------
    // Charger les donnees chantier
    // Si non chargees :
    //      pas de chantier dans DB -> error : indispensable
    //      chantier dans DB -> on continue
    //
    [self recupererMetaChantier];
    [self setProgressTo:_progress.floatValue + 0.1];
    
    
    // --------------------------------------------------
    // Charger toutes les taches qui ont besoin de l'etre
    //
    [self downloadNeededTaches];
    
    
    //Sauvegarde du chantier
    [[[Chantier MR_findFirstByAttribute:@"identifiant" withValue:[PTBAuthUser getIDChantier]] managedObjectContext] MR_saveToPersistentStoreAndWait];
    
    
    // Lancement interface chantier
    [_loadingVC performSelectorOnMainThread:@selector(finishedGettingAllData) withObject:NULL waitUntilDone:NO];
}


// ----------------------------------------------------
// Envoi sur le serveur toutes les taches modifiees
//
-(void)uploadNeededTaches {
    Chantier *currentChantier = [Chantier MR_findFirstByAttribute:@"identifiant" withValue:[PTBAuthUser getIDChantier]];
    
    if (currentChantier) {
        // Filtre selon taches modifiees
        NSPredicate *tacheFiltre = [NSPredicate predicateWithFormat:@"(modified == %@", [NSNumber numberWithBool:true]];
        
        NSSet *tachesModified = [currentChantier.taches filteredSetUsingPredicate:tacheFiltre];
        
        for (Tache *tache in tachesModified) {
            
            // Ajouter la tache aux taches a uploader  : dico ("identifiant" : "type")
            
            // Uploader la tache
                // Reussi : (enlever de la liste) + (modified = false)
            
            NSLog(@"upload tache : %@", tache.identifiant);
        }
    }
    else {
        NSLog(@"Pas encore de chantier donc rien a uploader");
    }
}




// -----------------------------------------------------
// Pour recuperer toutes les "infos/meta" du chantier
// Test si celle-ci existent deja et ne les ajoutent pas
//
-(BOOL)recupererMetaChantier {
    
    
    // --------------------
    // Acces au webservice
    //
    NSString *urlGetChantier = [NSString stringWithFormat:@"%@%@%@", kBaseURLString, kChantierUrlString, [PTBAuthUser getIDChantier]];
    NSLog(@"%@", urlGetChantier);
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlGetChantier]];
    
    if (jsonData == nil) {return false;};
    
    NSError *error;
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"%@", jsonObjects);
    
    // Les infos
    NSDictionary *info = [[jsonObjects objectForKey:@"info"] objectAtIndex:0];
    NSArray *infosTaches = [jsonObjects objectForKey:@"taches"];
    NSArray *infosLdr = [jsonObjects objectForKey:@"ldr"];
    
    
    // Recuperation du chantier
    NSManagedObjectContext *myNewContext = [NSManagedObjectContext MR_context];
    Chantier *currentChantier = [Chantier MR_findFirstByAttribute:@"identifiant" withValue:[PTBAuthUser getIDChantier] inContext:myNewContext];

    
    
    if (!currentChantier) {
        currentChantier = [Chantier MR_createEntityInContext:myNewContext];
        
        // infos chantier
        for (NSString* key in [info allKeys]) {
            NSLog(@"%@", key);
            if ([key isEqualToString:@"id"]) {
                [currentChantier setValue:[NSNumber numberWithInteger:[[info objectForKey:key]integerValue]] forKey:@"identifiant"];
            }
            else {
                [currentChantier setValue:[info objectForKey:key] forKey:key];
            }
        }
        
        // infos taches
        for (NSNumber *value in infosTaches) {
            IdentifiantsTaches *newIdTache = [IdentifiantsTaches MR_createEntityInContext:myNewContext];
            newIdTache.type = @"tache";
            newIdTache.identifiant = value;
            [currentChantier addListeTachesObject:newIdTache];
        }
        
        // infos ldr
        for (NSNumber *value in infosLdr) {
            IdentifiantsTaches *newIdTache = [IdentifiantsTaches MR_createEntityInContext:myNewContext];
            newIdTache.type = @"ldr";
            newIdTache.identifiant = value;
            [currentChantier addListeTachesObject:newIdTache];
        }
    }
    //Oui
    else {
        // Nouvelles taches ?
        for (NSNumber *value in infosTaches) {
            NSPredicate *tacheFiltre = [NSPredicate predicateWithFormat:@"(identifiant == %@) AND (type == %@)", value, @"tache"];
            
            if ([[IdentifiantsTaches MR_findAllWithPredicate:tacheFiltre inContext:myNewContext] count] == 0) {
                IdentifiantsTaches *newIdTache = [IdentifiantsTaches MR_createEntityInContext:myNewContext];
                newIdTache.type = @"tache";
                newIdTache.identifiant = value;
                [currentChantier addListeTachesObject:newIdTache];
            }
            else {
                NSLog(@"Existe deja %@", tacheFiltre);
            }
        }
        
        // Nouvelles ldr ?
        for (NSNumber *value in infosLdr) {
            NSPredicate *tacheFiltre = [NSPredicate predicateWithFormat:@"(identifiant == %@) AND (type == %@)", value, @"ldr"];
            
            if ([[IdentifiantsTaches MR_findAllWithPredicate:tacheFiltre inContext:myNewContext] count] == 0) {
                IdentifiantsTaches *newIdTache = [IdentifiantsTaches MR_createEntityInContext:myNewContext];
                newIdTache.type = @"ldr";
                newIdTache.identifiant = value;
                [currentChantier addListeTachesObject:newIdTache];
            }
            else {
                NSLog(@"Existe deja %@", tacheFiltre);
            }
        }
    }
    
    //Sauvegarde du chantier
    [[currentChantier managedObjectContext] MR_saveToPersistentStoreAndWait];

    return true;
}


-(void)downloadNeededTaches {
    
    // Recuperation du chantier
    NSManagedObjectContext *myNewContext = [NSManagedObjectContext MR_context];
    Chantier *currentChantier = [Chantier MR_findFirstByAttribute:@"identifiant" withValue:[PTBAuthUser getIDChantier] inContext:myNewContext];
    
    // On recupere la liste totale des infosTaches
    NSSet *setInfosTachesTotalChantier = currentChantier.listeTaches;
    NSArray *listeInfosTachesTotalChantier = [setInfosTachesTotalChantier allObjects];
    
    // On recupere la liste des taches
    NSSet *setTaches = currentChantier.taches;
    NSArray *listeTaches = [setTaches allObjects];
    
    
    for (Tache *idTache in listeTaches) {
        // Filtre pour ne garder que les infosTaches des taches non presentes
        NSPredicate *filtreTachesDB = [NSPredicate predicateWithFormat:@"NOT((type == %@) AND (identifiant == %@))", idTache.type, idTache.identifiant];
        listeInfosTachesTotalChantier = [listeInfosTachesTotalChantier filteredArrayUsingPredicate:filtreTachesDB];
        NSLog(@"%i", [listeInfosTachesTotalChantier count]);
    }
    
    float delta = (1 - [_progress floatValue])/2/[listeInfosTachesTotalChantier count];
    
    for (IdentifiantsTaches *identifiant in listeInfosTachesTotalChantier) {
        // Ajouter au tableau tachesToDownload
        if ([self downloadTacheWithIdentifiant:identifiant]) {
            // Enlever du tableau tachesToDownload
            NSLog(@"Tache %@ downloaded", identifiant.identifiant);
        }
        else {
            NSLog(@"Probleme reseau telechargement tache %@", identifiant.identifiant);
        }
        [self addDeltaToProgress:delta];
    }
}




// -----------------------------------------------------
// Telecharge une tache a partir de son identifiant
//
- (BOOL)downloadTacheWithIdentifiant:(IdentifiantsTaches *)identifiantTache{
    
    // ----------------------------------------------------------------------------
    // Acces au webservice
    //
    NSString *type = identifiantTache.type;
    NSString *identifiant = [identifiantTache.identifiant stringValue];
    
    NSString *urlGetChantier = [NSString stringWithFormat:@"%@%@type=%@&id=%@", kBaseURLString, kTacheUrlString, type, identifiant];
    NSLog(@"%@", urlGetChantier);
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlGetChantier]];
    
    if (jsonData == nil) {return false;};
    
    NSError *error;
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    // Bug API, tache est dans un tableau a l'index 0 ...
    NSDictionary *infosTache;
    if ([type isEqualToString:@"tache"]) {
         infosTache = [[jsonObjects objectForKey:identifiantTache.type] objectAtIndex:0];
    } else {
        infosTache = [jsonObjects objectForKey:identifiantTache.type];
    }
    
    // ------------------------------------------------------------------------------------
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        Tache *tache = [Tache MR_createEntityInContext:localContext];
        
        tache.type = type;
        tache.modified = [NSNumber numberWithBool:false];
        
        tache.identifiant = [NSNumber numberWithInteger:[[infosTache objectForKey:@"identifiant"] integerValue]];
        tache.titre = [infosTache objectForKey:@"titre"];
        tache.laDescription = [infosTache objectForKey:@"laDescription"];
        tache.commentaire = [infosTache objectForKey:@"commentaire"];
        
        // Gerer les images !!!!!!
        
        [[Chantier MR_findFirstInContext:localContext] addTachesObject:tache];
        
        [localContext MR_saveToPersistentStoreAndWait];
    }];
    
    // ------------------------------------------------------------------------------------
    
    jsonData = nil;
    jsonObjects = nil;
    infosTache = nil;
    
    return true;
}





-(void)addDeltaToProgress:(float)delta {
    [self setProgressTo:([_progress floatValue] + delta)];
}

-(void)setProgressTo:(float)value {
    if (value > 1) value = 1.0;
    _progress = [NSNumber numberWithFloat:value];
    [_loadingVC performSelectorOnMainThread:@selector(setProgress:) withObject:_progress waitUntilDone:NO];
}

@end
