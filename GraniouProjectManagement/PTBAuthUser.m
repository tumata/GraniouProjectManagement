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
        
        NSLog(@"%@", fullLoginRequest);
        
        NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:fullLoginRequest]];
        [self performSelectorOnMainThread:@selector(onBackendResponse:) withObject:jsonData waitUntilDone:YES];
    });
}

//----------------------------------------------------
// Une fois la reponse du serveur recue
// Only saves people from "equipe"
- (void)onBackendResponse:(NSData *)response
{
    NSError *error = nil;
    BOOL good = false;
    
    if (response) {
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"%@", jsonObjects);
        
        NSNumber *idChantier = [(NSDictionary *)jsonObjects valueForKey:@"id_chantier"];
        NSLog(@"%i", [idChantier integerValue]);
        
        if ([idChantier integerValue] != -1) {
            [self logInUserWithIdChantier:idChantier];
            good = true;
        }
    }
    else {
        NSLog(@"%@", [error localizedDescription]);
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


@end
