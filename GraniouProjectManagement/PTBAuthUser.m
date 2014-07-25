//
//  PTBAuthUser.m
//  GraniouProjectManagement
//
//  Created by Yeti LLC on 7/15/14.
//  Copyright (c) 2014 Graniou. All rights reserved.
//

#import "PTBAuthUser.h"
#import "IdentifiantsTaches.h"
#import "Tache.h"
#import "PTBGetChantier.h"
#import "Chantier.h"

// Queue pour fetcher la data
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

// Liens et clefs pour recuperer depuis le serveur
#define kBaseURLString           @"http://graniou-rail-project.fr/WebService/"
#define kLoginBaseUrlString      @"check.php?"

#define kUsers                  @"users"
#define kLogin                  @"login"
#define kPassword               @"password"
#define kDroitAcces             @"droit"
#define kIdChantier             @"idChantier"
#define vDroitAccesResponsable  @"Responsable"


@interface PTBAuthUser ()

@property (nonatomic, strong) NSString *loginAuth;
@property (nonatomic, strong) NSString *passwordAuth;

@end

@implementation PTBAuthUser


+ (bool)isLoggedIn {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kIdChantier]) {
        return true;
    }
    else {
        return false;
    }
}

+ (NSString *)getIDChantier {
    if ([PTBAuthUser isLoggedIn]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:kIdChantier];
    }
    else return nil;
}

+(BOOL)isAllTachesDownloaded {
    bool good = true;
    
    if ([PTBAuthUser isLoggedIn]) {
        for (IdentifiantsTaches *unIdentifiant in [IdentifiantsTaches MR_findAll]) {
            NSPredicate *tacheFiltre = [NSPredicate predicateWithFormat:@"(identifiant == %@) AND (type == %@)", unIdentifiant.identifiant, unIdentifiant.type];
            if (![Tache MR_findAllWithPredicate:tacheFiltre]) {
                good = false;
            }
        }
    }
    return good;
}


#pragma mark - Login functions

void(^tryLoginUserCallback)(BOOL success, NSError *error);

//--------------------------------------------
// Fonction principale permettant la connection
//
- (void)tryLoginUser:(NSString *)username password:(NSString *)pass withCallback:(PTBCompletionBlock)callback {
    tryLoginUserCallback = callback;
    
    _loginAuth = username;
    _passwordAuth = pass;
    
     // Sending a request to the backend services
    dispatch_async(kBgQueue, ^{
        NSString *fullLoginRequest = [NSString stringWithFormat:@"%@%@login=%@&password=%@", kBaseURLString, kLoginBaseUrlString, username, pass];
        
        //NSLog(@"%@", fullLoginRequest);
        
        NSError *error = [[NSError alloc] init];
        NSData *jsonData;
        @try {
            jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:fullLoginRequest] options:NSDataReadingMappedIfSafe error:&error];
        }
        @catch (NSException *exception) {
            error = [NSError errorWithDomain:@"Erreur identifiants" code:0 userInfo:nil];
        }
        
        NSMutableDictionary *dicoDataAndError = [NSMutableDictionary dictionaryWithObject:error forKey:@"error"];
        if (jsonData) [dicoDataAndError setObject:jsonData forKey:@"data"];
        
        [self performSelectorOnMainThread:@selector(onBackendResponse:) withObject:dicoDataAndError waitUntilDone:NO];
    });
}

//----------------------------------------------------
// Une fois la reponse du serveur recue
// Only saves people from "equipe"
- (void)onBackendResponse:(NSDictionary *)object
{
    NSError *error = [object objectForKey:@"error"];
    NSLog(@"%@", error.domain);
    if ([error.domain isEqualToString:@"NSCocoaErrorDomain"]) {
        error = [NSError errorWithDomain:@"Erreur reseau" code:0 userInfo:nil];
    }
    
    bool good = false;
    
    if ([object objectForKey:@"data"]) {
        NSData *response = [object objectForKey:@"data"];
        
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&error];
        
        NSNumber *idChantier = [(NSDictionary *)jsonObjects valueForKey:@"id_chantier"];
        NSLog(@"%i", [idChantier integerValue]);
        
        
        if ([idChantier integerValue] != -1) {
            [self logInUserWithIdChantier:idChantier];
            good = true;
        }
        else if ([idChantier integerValue] == -1) {
            error = [NSError errorWithDomain:@"Erreur identifiants" code:0 userInfo:nil];
        } else {
            error = [NSError errorWithDomain:@"Erreur serveur !!!" code:1 userInfo:nil];
        }
    }
    
    tryLoginUserCallback(good, error);
}
    

//----------------------------------------------------
// On log l'utilisateur en fonction de l'ID Chantier
//
- (void)logInUserWithIdChantier:(NSNumber *)idChantier {
    
    [[NSUserDefaults standardUserDefaults] setObject:idChantier forKey:kIdChantier];
    NSLog(@"Authentifie et userDefault : %i", [[[NSUserDefaults standardUserDefaults] objectForKey:kIdChantier] integerValue]);
}




#pragma mark - Logout functions

void(^tryLogoutUserCallback)(NSDictionary *infos);

//----------------------------------------------------
// On tente de logout user
//
-(void)tryLogoutUserWithCallback:(PTBInfosCompletionBlock)callback {
    tryLogoutUserCallback = callback;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutCompleted:) name:@"tachesUploaded" object:nil];
    [[PTBGetChantier sharedInstance] uploadNeededTaches];
    
}

//----------------------------------------------------
// Une fois upload termine :
// Transmet les infos donnees par PTBGetChantier
//
-(void)logoutCompleted:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tachesUploaded" object:nil];
    
    // Si tout s'est bien passe :
    if ([[[notification userInfo] objectForKey:@"uploaded"] isEqualToString:@"1"]) {
        Chantier *chantier = [Chantier MR_findFirstByAttribute:@"identifiant" withValue:[PTBAuthUser getIDChantier]];
        [chantier MR_deleteEntity];
        [[chantier managedObjectContext] MR_saveToPersistentStoreAndWait];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kIdChantier];
    }
    
    tryLogoutUserCallback([notification userInfo]);
}


//----------------------------------------------------
// Forcer la deconnection
//
+(void)forceLogout {
    Chantier *chantier = [Chantier MR_findFirstByAttribute:@"identifiant" withValue:[PTBAuthUser getIDChantier]];
    if (chantier) {
        [chantier MR_deleteEntity];
        [[chantier managedObjectContext] MR_saveToPersistentStoreAndWait];
    
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kIdChantier];
    }
}

@end
