//
//  PTBAppModel.h
//  GraniouProjectManagement
//
//  Created by Yeti LLC on 7/11/14.
//  Copyright (c) 2014 Graniou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ManticoreViewFactory.h"

#define BaseURLString @"http://graniou-rail-project.fr/WebService/"

#define GetUsersURLString @"json_users.php"


#define SECTION_PROFILE        @"PTBProfileSectionVC"
#define SECTION_MONTEUR        @"PTBMonteurSectionVC"
#define VIEW_LOGIN             @"PTBLoginVC"
#define VIEW_ACCOUNT           @"PTBAccountVC"
#define VIEW_LOADING           @"PTBLoadingVC"
#define VIEW_TOPMENU           @"PTBTopMenuVC"
#define VIEW_CHANTIERMENU      @"PTBChantierMenuVC"  // 5
#define VIEW_TACHESTABLE       @"PTBTachesTableVC"
#define VIEW_TACHE             @"PTBTacheVC"
#define VIEW_TAKEPICTURE       @"PTBTakePictureVC"  // 10
#define VIEW_WRITECOMMENT      @"PTBWriteCommentVC"
#define VIEW_DOCUMENTSTABLE    @"PTBDocumentsTableVC"
#define VIEW_SHOWPDF           @"PTBShowPdfVC"



@interface PTBAppModel : NSObject

+ (PTBAppModel*)sharedModel;



-(void)loginOrWelcome: (MCIntent*)passThroughIntent;


@end
