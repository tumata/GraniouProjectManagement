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

// Queue pour fetcher la data
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

// Liens et clefs pour recuperer depuis le serveur
#define kBaseURLString          @"http://graniou-rail-project.fr/WebService/"
#define kChantierUrlString      @"chantier.php?id_chantier="
#define kTacheUrlString         @"data.php?"



@interface PTBGetChantier()




@end

@implementation PTBGetChantier


void(^tryGetAllInfosChantier)(BOOL success, NSError *error);
void(^tryGetOneTacheChantier)(BOOL success, NSError *error);



//--------------------------------------------
// Fonction principale permettant la connection
//
- (void)startDownloadingChantierWithProgressView:(UIProgressView *)progressView withCallback:(PTBCompletionBlock)callback {
    tryGetAllInfosChantier = callback;
    
    
    progressView.progress = 0.0;
    
    // ------------------------------------------------
    // Uploader tout ce qui n'a pas ete uploade
    // Si fail, pas grave, mais on ne retelecharge rien
    //
    
    
    // -----------------------------------------
    // Verifier que user authentifie et chantier
    //
    NSAssert([PTBAuthUser isLoggedIn], @"Pas logge...");
    if (![PTBAuthUser isLoggedIn]) tryGetAllInfosChantier(0,nil);
    
    
    // -----------------------------------------
    // Charger les donnees chantier
    //
    if (![self recupererMetaChantier]) tryGetAllInfosChantier(0,nil);
    progressView.progress += 0.1;
    
    
    // -----------------------------------------
    // Charger toutes les taches
    //
    NSUInteger totalCount = [IdentifiantsTaches MR_countOfEntities];
    
    Chantier *currentChantier = [Chantier MR_findFirstByAttribute:@"identifiant" withValue:[PTBAuthUser getIDChantier]];
    for (IdentifiantsTaches *identifiantTache in [IdentifiantsTaches MR_findByAttribute:@"parent" withValue:currentChantier]) {
        
        if (![self getOrSendByIdentifiantTache:identifiantTache inChantier:currentChantier]) {
            NSLog(@"Tache non recuperee");
        }
    }

    
    tryGetAllInfosChantier(1,nil);
    
}

//----------------------------------------------------
// Une fois la reponse du serveur recue
// Only saves people from "equipe"
- (void)onBackendResponse:(NSData *)response {
    NSError *error = nil;
    BOOL good = false;
    
    if (response) {
        
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"%@", jsonObjects);
        
       
        
    }
    
    //tryGetInfosChantier(1, nil);
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
    
    // Chantier deja cree dans la DB ?
    Chantier *newChantier = [Chantier MR_findFirstByAttribute:@"identifiant" withValue:[PTBAuthUser getIDChantier]];
    // Non
    if (!newChantier) {
        newChantier = [Chantier MR_createEntity];
        
        // infos chantier
        for (NSString* key in [info allKeys]) {
            NSLog(@"%@", key);
            if ([key isEqualToString:@"id"]) {
                [newChantier setValue:[NSNumber numberWithInteger:[[info objectForKey:key]integerValue]] forKey:@"identifiant"];
            }
            else {
                [newChantier setValue:[info objectForKey:key] forKey:key];
            }
        }
        
        // infos taches
        for (NSNumber *value in infosTaches) {
            IdentifiantsTaches *newIdTache = [IdentifiantsTaches MR_createEntity];
            newIdTache.type = @"tache";
            newIdTache.identifiant = value;
            [newChantier addListeTachesObject:newIdTache];
        }
        
        // infos ldr
        for (NSNumber *value in infosLdr) {
            IdentifiantsTaches *newIdTache = [IdentifiantsTaches MR_createEntity];
            newIdTache.type = @"ldr";
            newIdTache.identifiant = value;
            [newChantier addListeTachesObject:newIdTache];
        }
    }
    //Oui
    else {
        // Nouvelles taches ?
        for (NSNumber *value in infosTaches) {
            NSPredicate *tacheFiltre = [NSPredicate predicateWithFormat:@"(identifiant == %@) AND (type == %@)", value, @"tache"];
            
            if ([[IdentifiantsTaches MR_findAllWithPredicate:tacheFiltre] count] == 0) {
                IdentifiantsTaches *newIdTache = [IdentifiantsTaches MR_createEntity];
                newIdTache.type = @"tache";
                newIdTache.identifiant = value;
                [newChantier addListeTachesObject:newIdTache];
            }
            else {
                NSLog(@"Existe deja %@", tacheFiltre);
            }
        }
        
        // Nouvelles ldr ?
        for (NSNumber *value in infosLdr) {
            NSPredicate *tacheFiltre = [NSPredicate predicateWithFormat:@"(identifiant == %@) AND (type == %@)", value, @"ldr"];
            
            if ([[IdentifiantsTaches MR_findAllWithPredicate:tacheFiltre] count] == 0) {
                IdentifiantsTaches *newIdTache = [IdentifiantsTaches MR_createEntity];
                newIdTache.type = @"ldr";
                newIdTache.identifiant = value;
                [newChantier addListeTachesObject:newIdTache];
            }
            else {
                NSLog(@"Existe deja %@", tacheFiltre);
            }
        }
    }
    
    //Sauvegarde du chantier
    [[newChantier managedObjectContext] MR_saveToPersistentStoreAndWait];

    return true;
}


// -------------------------------------
// Si la tache est presente et modifiee : on l'envoi
// Si non presente : on la telecharge
//
- (BOOL)getOrSendByIdentifiantTache:(IdentifiantsTaches *)identifiantTache inChantier:(Chantier *)currentChantier {
    bool good = false;
    
    NSPredicate *tacheFiltre = [NSPredicate predicateWithFormat:@"(identifiant == %@) AND (type == %@)", identifiantTache.identifiant, identifiantTache.type];
    
    // La tache est-elle presente ?
    //
    NSArray *laTache = [Tache MR_findAllWithPredicate:tacheFiltre];
    
    if ([laTache count] > 0) {
        NSAssert([laTache count] <= 1, @"Plus de deux taches trouvees");
        
        // oui. est-ce que "modified" ?
        //
        Tache *tache = [laTache objectAtIndex:0];
        if (tache.modified) {
            //
            // oui : envoyer server
            //
            NSLog(@"Tache modified : envoyer serveur");
        }
    }
    else {
        // Telecharger la tache
        //
        good = [self downloadTacheWithIdentifiant:identifiantTache inChantier:currentChantier];
    }

    return good;
}


- (BOOL)downloadTacheWithIdentifiant:(IdentifiantsTaches *)identifiantTache inChantier:(Chantier *)currentChantier {
    
    if ([identifiantTache.type isEqualToString:@"ldr"]) return true;
    // --------------------
    // Acces au webservice
    //
    NSString *urlGetChantier = [NSString stringWithFormat:@"%@%@type=%@&id=%@", kBaseURLString, kTacheUrlString, identifiantTache.type, identifiantTache.identifiant];
    NSLog(@"%@", urlGetChantier);
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlGetChantier]];
    
    if (jsonData == nil) {return false;};
    
    NSError *error;
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    
    NSDictionary *infosTache = [[jsonObjects objectForKey:identifiantTache.type] objectAtIndex:0];
    
    Tache *tache = [Tache MR_createEntity];
    
    tache.type = identifiantTache.type;
    tache.modified = [NSNumber numberWithBool:false];
    
    tache.identifiant = [NSNumber numberWithInteger:[[infosTache objectForKey:@"id"] integerValue]];
    tache.titre = [infosTache objectForKey:@"titreTache"];
    tache.laDescription = [infosTache objectForKey:@"contenuTache"];
    tache.commentaire = [infosTache objectForKey:@"commentaire"];
    
    // AJOUTER TOUT LE RESTE ET GESTION LDR ET IMAGES NSDATA
    
    [currentChantier addTachesObject:tache];
    
    return true;
}

@end
