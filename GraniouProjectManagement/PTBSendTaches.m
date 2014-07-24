//
//  PTBSendTaches.m
//  GraniouProjectManagement
//
//  Created by Yeti LLC on 7/24/14.
//  Copyright (c) 2014 Graniou. All rights reserved.
//

#import "PTBSendTaches.h"
#import "PTBAuthUser.h"
#import "Chantier.h"
#import "Tache.h"
#import "Images.h"

// Liens et clefs pour recuperer depuis le serveur
#define kBaseURLString      @"http://graniou-rail-project.fr/WebService/"
#define urlTacheSend        @"/send_tache_ios.php"
#define urlLdrSend          @"/send_ldr_ios.php"


@interface PTBSendTaches ()



@end

@implementation PTBSendTaches


-(void)main {
    int totalCount = 0;
    int totalSent = 0;
    
    // Recuperation du chantier
    NSManagedObjectContext *myNewContext = [NSManagedObjectContext MR_context];
    Chantier *currentChantier = [Chantier MR_findFirstByAttribute:@"identifiant" withValue:[PTBAuthUser getIDChantier] inContext:myNewContext];
    
    if (currentChantier) {
        // Filtre selon taches modifiees
        NSPredicate *tacheFiltre = [NSPredicate predicateWithFormat:@"modified == %@", [NSNumber numberWithBool:true]];
        
        NSSet *tachesModified = [currentChantier.taches filteredSetUsingPredicate:tacheFiltre];
        totalCount = [tachesModified count];
        
        for (Tache *tache in tachesModified) {
            if ([self sendTacheWithTache:tache]) totalSent++;
        }
    }
    
    NSDictionary *infos = @{@"nombreTachesEnvoyees": [NSString stringWithFormat:@"%i", totalSent],
                            @"nombreTachesTotal" : [NSString stringWithFormat:@"%i", totalCount]
                            };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PTBTachesEnvoyees" object:infos];
}




- (BOOL)sendTacheWithTache:(Tache *)tache {
    
    
    
    
    
    
    return true;
}








//- (NSData *)tacheToData {
//    NSString *boundary = @"---------------------------14737809831466499882746641449";
//    
//    NSMutableData *body = [NSMutableData data];
//    
//    // Pour commencer la requete
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    
//    // Image
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@.jpg\"\r\n", [self getNomImageCommentaire]] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[NSData dataWithData:UIImageJPEGRepresentation(_imageCommentaire, keyCompression)]];
//    
//    // Id Tache
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"id\"\r\n\r\n%@", _idTache] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    // Id Chantier
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"idChantier\"\r\n\r\n%@", _idChantier] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    // Commentaire
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"commentaire\"\r\n\r\n%@", _commentaire] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    // Pour terminer la requete
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    return body;
//}
//
//+ (void)sendHttpPostTacheWithData:(NSData *)body
//                  toUrlWithString:(NSString *)stringURL
//                         delegate:(id<NSURLSessionDataDelegate>)delegate {
//    
//    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: delegate delegateQueue: [NSOperationQueue mainQueue]];
//    
//    
//    NSURL * url = [NSURL URLWithString:stringURL];
//    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
//    
//    [request setHTTPMethod:@"POST"];
//    
//    NSString *boundary = @"---------------------------14737809831466499882746641449";
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//    
//    // Body donnee en parametres
//    [request setHTTPBody:body];
//    
//    
//    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request];
//    [dataTask resume];
//    
//    
//}
//
//
//
//
//- (NSString *)getNomImageCommentaire {
//    return [NSString stringWithFormat:@"image-%@-%@", _idChantier, _idTache];
//}


@end
