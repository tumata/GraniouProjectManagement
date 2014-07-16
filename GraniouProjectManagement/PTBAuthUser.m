//
//  PTBAuthUser.m
//  GraniouProjectManagement
//
//  Created by Yeti LLC on 7/15/14.
//  Copyright (c) 2014 Graniou. All rights reserved.
//

#import "PTBAuthUser.h"

// Queue pour fetcher la data
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

// Liens et clefs pour recuperer depuis le serveur
#define kBaseURLString           @"http://graniou-rail-project.fr/WebService/"
#define kUsersSourceFile         @"json_users.php"

#define kUsers                  @"users"
#define kLogin                  @"login"
#define kPassword               @"password"
#define kDroitAcces             @"droit"
#define kIdChantier             @"idChantier"
#define vDroitAccesResponsable  @"Responsable"


static NSDictionary *dicoKusersVpass = nil;
static NSDictionary *dicoKusersVidChantier = nil;

@interface PTBAuthUser ()

@property (nonatomic, strong) NSString *loginAuth;
@property (nonatomic, strong) NSString *passwordAuth;
@property (nonatomic, strong) NSString *idChantier;

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


void(^tryLoginUserCallback)(BOOL success, NSError *error);


//--------------------------------------------
// Fonction principale permettant la connection
//
- (void)tryLoginUser:(NSString *)username password:(NSString *)pass withCallback:(PTBCompletionBlock)callback {
    tryLoginUserCallback = callback;
    
    _loginAuth = username;
    _passwordAuth = pass;
    
     // Start doing some time consuming tasks like sending a request to the backend services
    if (!dicoKusersVpass)
        dispatch_async(kBgQueue, ^{
            NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[kBaseURLString stringByAppendingString:kUsersSourceFile]]];
            [self performSelectorOnMainThread:@selector(onBackendResponse:) withObject:jsonData waitUntilDone:YES];
        });
    else {
        NSLog(@"Ne telecharge pas mais test credentials");
        // Test logger
        bool logged = [self logInUser:_loginAuth password:_passwordAuth];
        // Transmet la reponse
        tryLoginUserCallback(logged, nil);
    }
    

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
            
        //NSLog(@"%@", jsonObjects);
            
        // Recuperation de la table "users"
        NSArray *entries = [jsonObjects objectForKey:kUsers];
            
        // On cree le dictionnaire des login/passwords
        NSMutableDictionary *loginsPasswords = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *loginsIDChantier = [[NSMutableDictionary alloc] init];
        
        // Pour chaque element
        for (NSMutableDictionary *item in entries) {
            // Clef droitAcces
            NSString *droitAcces = [item objectForKey:kDroitAcces];
            
            // Quel est son droit. Si Responsable, pas d'acces
            if (![droitAcces isEqualToString:vDroitAccesResponsable]) {
                [loginsPasswords setObject:[item objectForKey:kPassword] forKey:[item objectForKey:kLogin]];
                [loginsIDChantier setObject:[item objectForKey:kIdChantier] forKey:[item objectForKey:kLogin]];
            }
        }
        
        dicoKusersVpass = loginsPasswords;
        dicoKusersVidChantier = loginsIDChantier;
    }
        
    good = [self logInUser:_loginAuth password:_passwordAuth];
    tryLoginUserCallback(good, error);
}
    

//----------------------------------------------------
// On log l'utilisateur en fonction de l'ID Chantier
//
- (bool)logInUser:(NSString *)username password:(NSString *)pass {
    bool good = false;
    // Test credentials
    if ([self isGoodLoginPassword:_loginAuth password:_passwordAuth]) {
        NSString *idChantier = [dicoKusersVidChantier objectForKey:username];
        
        [[NSUserDefaults standardUserDefaults] setObject:idChantier forKey:kIdChantier];
        NSLog(@"Authentifie et userDefault : %@", [[NSUserDefaults standardUserDefaults] objectForKey:kIdChantier]);;
        
        good = true;
        dicoKusersVpass = nil;
        dicoKusersVidChantier = nil;
    }
    return good;
}

//----------------------------------------------------
// Compare les entrees a la liste
//
- (BOOL)isGoodLoginPassword:(NSString *)login password:(NSString *)password {
    if (dicoKusersVpass) {
        if ([[dicoKusersVpass objectForKey:login] isEqualToString:password]) {
            return true;
        }
    }
    return false;
}


@end
