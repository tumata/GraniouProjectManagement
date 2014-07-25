//
//  PTBSendTaches.m
//  GraniouProjectManagement
//
//  Created by Yeti LLC on 7/24/14.
//  Copyright (c) 2014 Graniou. All rights reserved.
//

#import "PTBSendTache.h"
#import "PTBAuthUser.h"
#import "Chantier.h"
#import "Tache.h"
#import "Images.h"

// Liens et clefs pour recuperer depuis le serveur
#define baseURLString      @"http://graniou-rail-project.fr/WebService/send_"
// Ajouter soir ldr soit tache entre.
#define urlTacheEnd        @"_ios.php"

#define keyCompression 0.7

@interface PTBSendTache ()


@end

@implementation PTBSendTache




-(void)main {
    
    // Recuperation du chantier
    NSManagedObjectContext *myNewContext = [NSManagedObjectContext MR_context];
    Chantier *currentChantier = [Chantier MR_findFirstByAttribute:@"identifiant" withValue:[PTBAuthUser getIDChantier] inContext:myNewContext];
    
    if (currentChantier) {
        // Filtre selon taches modifiees
        NSPredicate *tacheFiltre = [NSPredicate predicateWithFormat:@"type == %@ AND identifiant == %@", _type, _identifiant];
        
        Tache *tache = [Tache MR_findFirstWithPredicate:tacheFiltre inContext:myNewContext];
        [self sendTacheWithTache:tache];
    }
}




- (BOOL)sendTacheWithTache:(Tache *)tache {
    
    NSData *tacheData = [self tacheToData:tache];
    NSString *url = [NSString stringWithFormat:@"%@%@%@", baseURLString, tache.type, urlTacheEnd];
    NSLog(@"Tache %@ \"%@\" envoyee : %@",tache.identifiant ,tache.titre, url);
    
    
    [self sendHttpPostTacheWithData:tacheData toUrlWithString:url tache:tache];
    
    int sleep = 2;
    if ([tache.images.imageCommentaire length] > 5) sleep = 5;
    
    [NSThread sleepForTimeInterval:sleep];
    return true;
}





- (NSData *)tacheToData:(Tache *)tache {
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    
    NSMutableData *body = [NSMutableData data];
    
    // Pour commencer la requete
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Conversion image en base 64 
    NSData *image = tache.images.imageCommentaire;
    NSString *nomImage = [NSString stringWithFormat:@"image-%@-%@", [tache.chantier.identifiant stringValue], [tache.identifiant stringValue]];
    NSLog(@"%@", nomImage);
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@.jpg\"\r\n", nomImage] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:UIImageJPEGRepresentation([UIImage imageWithData:image], keyCompression)]];
    
    // Id Tache
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"id\"\r\n\r\n%@", [_identifiant stringValue]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Id Chantier
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"idChantier\"\r\n\r\n%@", [PTBAuthUser getIDChantier]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Commentaire
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"commentaire\"\r\n\r\n%@", tache.commentaire] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Pour terminer la requete
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return body;
}


- (void)sendHttpPostTacheWithData:(NSData *)body
                                    toUrlWithString:(NSString *)stringURL
                                              tache:(Tache *)tache {
    
    NSString *type = tache.type;
    NSNumber *identifiant = tache.identifiant;
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:nil delegateQueue: [NSOperationQueue mainQueue]];
    
    
    NSURL * url = [NSURL URLWithString:stringURL];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // Body donnee en parametres
    [request setHTTPBody:body];
    
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%i", error.code);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tachesUploaded" object:nil userInfo:@{@"uploaded": @"0"}];
        }
        else {
            [NSThread sleepForTimeInterval:2.0];
            
            // Recuperation du chantier
            NSManagedObjectContext *myNewContext = [NSManagedObjectContext MR_context];
            Chantier *currentChantier = [Chantier MR_findFirstByAttribute:@"identifiant" withValue:[PTBAuthUser getIDChantier] inContext:myNewContext];
            
            if (currentChantier) {
                // Filtre selon taches modifiees
                NSPredicate *tacheFiltre = [NSPredicate predicateWithFormat:@"type == %@ AND identifiant == %@", type, identifiant];
                
                Tache *tache = [Tache MR_findFirstWithPredicate:tacheFiltre inContext:myNewContext];
                tache.modified = [NSNumber numberWithBool:false];
                
                // Test si plus de taches modifiees
                NSPredicate *modifiedFiltre = [NSPredicate predicateWithFormat:@"modified == %@", [NSNumber numberWithBool:true]];
                
                NSSet *tachesModified = [currentChantier.taches filteredSetUsingPredicate:modifiedFiltre];
                
                if ([tachesModified count] == 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"tachesUploaded" object:nil userInfo:@{@"uploaded": @"1"}];
                }
                
                
                
                [myNewContext MR_saveToPersistentStoreAndWait];
            }
        }
    }];
    
    [dataTask resume];
    
}

@end
