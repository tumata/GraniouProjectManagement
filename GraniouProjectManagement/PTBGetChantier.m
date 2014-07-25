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
#import "Images.h"
#import "PTBSendTache.h"



// Liens et clefs pour recuperer depuis le serveur
#define kBaseURLString          @"http://graniou-rail-project.fr/WebService/"
#define kChantierUrlString      @"chantier.php?id_chantier="
#define kTacheUrlString         @"data.php?"




@interface PTBGetChantier() <NSURLSessionDataDelegate>

@property (strong, nonatomic) NSMutableDictionary *tachesToUpload;
@property (strong, nonatomic) NSMutableDictionary *tachesToDownload;

@property (strong, nonatomic) NSOperationQueue *queueGet;
@property (strong, nonatomic) NSOperationQueue *queueSet;

@property (strong, atomic) PTBSendTache *sendTaches;


// Related VC
@property (weak, nonatomic)     UIViewController *associatedViewController;
@property (strong, atomic)      NSNumber *progress;



@end



@implementation PTBGetChantier


+ (PTBGetChantier *)sharedInstance {
    static PTBGetChantier *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        self.queueGet = [[NSOperationQueue alloc] init];
        self.queueSet = [[NSOperationQueue alloc] init];
        
        [self.queueGet setMaxConcurrentOperationCount:1];
        [self.queueSet setMaxConcurrentOperationCount:1];
    }
    return self;
}

// Returns true if operation started
-(BOOL)startSynchronization {
    if (_queueGet.operationCount || _queueSet.operationCount) return false;
    _associatedViewController = nil;
    [self startGettingChantier];
    return true;
}

//returns true if operation started
-(BOOL)startSynchronizationWithViewController:(UIViewController *)appliedView {
    if (_queueGet.operationCount || _queueSet.operationCount) return false;
    _associatedViewController = appliedView;
    [self startGettingChantier];
    return true;
}



//--------------------------------------------
// Fonction principale permettant la connection
//
- (void)startGettingChantier {
    
    
    // -----------------------------------------
    // Verifier que user authentifie et chantier
    //
    NSAssert([PTBAuthUser isLoggedIn], @"Pas logge...");
    if (![PTBAuthUser isLoggedIn]) return;
    
    
    // -----------------------------------------
    // Initialisations
    //
    _progress = [NSNumber numberWithFloat:0.0];
    [self setProgress:0];
    
    
    // ------------------------------------------------
    // Uploader tout ce qui n'a pas ete uploade
    // Si fail, pas grave, mais on ne retelecharge rien
    //
    
    [self uploadNeededTaches];
    

    // -----------------------------------------
    // Charger les donnees chantier
    // Si non chargees :
    //      pas de chantier dans DB -> error : indispensable
    //      chantier dans DB -> on continue
    //
    [_queueGet addOperation:[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(recupererMetaChantier) object:nil]];
    //[self recupererMetaChantier];
    
    
    // --------------------------------------------------
    // Charger toutes les taches qui ont besoin de l'etre
    //
    [_queueGet addOperation:[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(downloadNeededTaches) object:nil]];
    //[self downloadNeededTaches];
    
    
}


// ----------------------------------------------------
// Envoi sur le serveur toutes les taches modifiees
//
-(void)uploadNeededTaches {
    // Recuperation du chantier
    NSManagedObjectContext *myNewContext = [NSManagedObjectContext MR_context];
    Chantier *currentChantier = [Chantier MR_findFirstByAttribute:@"identifiant" withValue:[PTBAuthUser getIDChantier] inContext:myNewContext];
    
    if (currentChantier) {
        // Filtre selon taches modifiees
        NSPredicate *tacheFiltre = [NSPredicate predicateWithFormat:@"modified == %@", [NSNumber numberWithBool:true]];
        
        NSSet *tachesModified = [currentChantier.taches filteredSetUsingPredicate:tacheFiltre];
        
        // Rien modifie, on envoi le signal tout envoye
        if ([tachesModified count] == 0) {
            NSDictionary *dico = @{@"neededUploadCount": @"0", @"uploadedCount": @"0"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tachesUploaded" object:nil userInfo:dico];
        }
        
        for (Tache *tache in tachesModified) {
            PTBSendTache *operation = [[PTBSendTache alloc] init];
            operation.type = tache.type;
            operation.identifiant = tache.identifiant;
            
            [_queueSet addOperation:operation];
            
        }
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
    
    //NSLog(@"%@", jsonObjects);
    
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

    [self setProgressTo:_progress.floatValue + 0.1];
    return true;
}

// -------------------------------------------
// Telecharge les taches necessaires
//
-(void)downloadNeededTaches {
    int countTachesNonRecuperees = 0;
    int shouldDownloadCount = 0;
    NSMutableDictionary *finishedInfos = [[NSMutableDictionary alloc] init];
    
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
    
    shouldDownloadCount = [listeInfosTachesTotalChantier count];
    float delta = (1 - [_progress floatValue])/[listeInfosTachesTotalChantier count];
    
    // listeInfosTachesTotalChantier ne contient plus que les taches non presentes ici
    for (IdentifiantsTaches *identifiant in listeInfosTachesTotalChantier) {
        
        if ([self downloadTacheWithIdentifiant:identifiant]) {
            NSLog(@"Tache %@ downloaded", identifiant.identifiant);
        }
        else {
            NSLog(@"Probleme reseau telechargement tache %@", identifiant.identifiant);
            countTachesNonRecuperees++;
        }
        [self addDeltaToProgress:delta];
    }
    
    // Rempli le dictionnaire infos notDownloadedCount
    [finishedInfos setObject:[NSString stringWithFormat:@"%i", countTachesNonRecuperees] forKey:@"notDownloadedCount"];
    [finishedInfos setObject:[NSString stringWithFormat:@"%i", shouldDownloadCount] forKey:@"shouldDownloadCount"];
    
    // Si listeInfosTachesTotalChantier vide alors delta = infini. on ajoute 50% du reste
    if (isinf(delta)) [self addDeltaToProgress:((1 - [_progress floatValue]))];
    
    // Notification fin download :
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tachesDownloaded" object:nil userInfo:finishedInfos];
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
        
        // Images
        Images *image;
        // 1. image description
        if ([type isEqualToString:@"ldr"]) {
            NSDictionary *imageDescriptionDico = [infosTache objectForKey:@"imageDescription"];
            NSString *stringBase64Image = [imageDescriptionDico objectForKey:@"data"];
            if ([stringBase64Image length] > 5) {
                // Conversion base 64 en NSData
                NSData *data = [[NSData alloc] initWithBase64EncodedString:stringBase64Image options:NSDataBase64DecodingIgnoreUnknownCharacters];
                // CreationImage
                image = [Images MR_createEntityInContext:localContext];
                image.imageDescription = data;
                data = nil;
                stringBase64Image = nil;
                imageDescriptionDico = nil;
            }
        }
        // 2. imageCommentaire
        NSDictionary *imageCommentaireDico = [infosTache objectForKey:@"imageCommentaire"];
        NSString *stringBase64Image = [imageCommentaireDico objectForKey:@"data"];
        if ([stringBase64Image length] > 5) {
            // Conversion base 64 en NSData
            NSData *data = [[NSData alloc] initWithBase64EncodedString:stringBase64Image options:NSDataBase64DecodingIgnoreUnknownCharacters];
            // CreationImage
            if (!image) {
                image = [Images MR_createEntityInContext:localContext];
            }
            image.imageCommentaire = data;
            data = nil;
            stringBase64Image = nil;
            imageCommentaireDico = nil;
        }
        // 3. ajout image
        if (image) tache.images = image;
        
        
        [[Chantier MR_findFirstInContext:localContext] addTachesObject:tache];
        [localContext MR_saveToPersistentStoreAndWait];
    }];
    
    // ------------------------------------------------------------------------------------
    
    jsonData = nil;
    jsonObjects = nil;
    infosTache = nil;
    
    return true;
}



#pragma mark - Progress view methods

-(void)addDeltaToProgress:(float)delta {
    [self setProgressTo:([_progress floatValue] + delta)];
}

-(void)setProgressTo:(float)value {
    if (_associatedViewController) {
        if ([_associatedViewController respondsToSelector:@selector(setProgress:)]) {
            if (value > 1) value = 1.0;
            _progress = [NSNumber numberWithFloat:value];
            [_associatedViewController performSelectorOnMainThread:@selector(setProgress:) withObject:_progress waitUntilDone:NO];
        }
    }
}



@end
