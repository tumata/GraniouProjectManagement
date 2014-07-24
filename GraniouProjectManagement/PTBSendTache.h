//
//  PTBSendTaches.h
//  GraniouProjectManagement
//
//  Created by Yeti LLC on 7/24/14.
//  Copyright (c) 2014 Graniou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTBSendTache : NSOperation

//
// Cette classe lance la notification : "PTBTachesEnvoyees"
// et contient l'objet :
// infos -> NSDictionnary {
//          @"nombreTachesTotal": @"stringRepr"
//          @"nombreTachesEnvoyees": @"stringRepr"
//

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSNumber *identifiant;
@property (weak, nonatomic) id<NSURLSessionDataDelegate>connectionDelegate;


@end
