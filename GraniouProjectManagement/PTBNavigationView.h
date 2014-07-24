//
//  PTBNavigationView.h
//  GraniouProjectManagement
//
//  Created by Yeti LLC on 7/17/14.
//  Copyright (c) 2014 Graniou. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PTBNavigationViewDelegate <NSObject>
@required
- (void)navigationViewDidPressLeftButton;
@optional
- (void)navigationViewDidPressRightButton;
@end

@interface PTBNavigationView : UIView

@property (nonatomic, weak) id<PTBNavigationViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *statusBarView;
@property (weak, nonatomic) IBOutlet UIView *navigationBar;

// Enabled by default - text "< retour"
@property (weak, nonatomic) IBOutlet UIImageView *boutonGauche;

// Hidden by default - empty text
@property (weak, nonatomic) IBOutlet UIButton *boutonDroit;

// Titre - empty text by default
@property (weak, nonatomic) IBOutlet UILabel *titre;



@end
