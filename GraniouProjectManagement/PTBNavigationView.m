//
//  PTBNavigationView.m
//  GraniouProjectManagement
//
//  Created by Yeti LLC on 7/17/14.
//  Copyright (c) 2014 Graniou. All rights reserved.
//

#import "PTBNavigationView.h"

@interface PTBNavigationView()

@property (strong, nonatomic) IBOutlet UIView *view;

@end

@implementation PTBNavigationView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // 1. Load xib
        [[NSBundle mainBundle] loadNibNamed:@"PTBNavigationView" owner:self options:nil];
        
        // 2. add as subview
        [self addSubview:self.view];
        
        // 3. Custom stuff
        [self customInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // 1. Load the interface from .xib
        [[NSBundle mainBundle] loadNibNamed:@"PTBNavigationView" owner:self options:nil];
        // 2. Add as subview
        [self addSubview:self.view];
        
        // 3. Custom stuff
        [self customInitialization];
        
    }
    return self;
}

- (void)customInitialization {
    [_boutonDroit setHidden:true];
}


#pragma mark - Handling fast - pressed button

- (void)disableMultiTimesPressedButton {
    [_view setUserInteractionEnabled:false];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(setInteractionStop) userInfo:nil repeats:NO];
}

- (void)setInteractionStop {
    [_view setUserInteractionEnabled:true];
}

- (void)setStatusBarSameColor {
    _statusBarView.backgroundColor = _navigationBar.backgroundColor;
}

#pragma mark - touches events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:_boutonGauche];
    if (point.x < 70) {
        [self disableMultiTimesPressedButton];
        [self.delegate navigationViewDidPressLeftButton];
    }
    if (point.x > 250) {
        [self disableMultiTimesPressedButton];
        if ([self.delegate respondsToSelector:@selector(navigationViewDidPressRightButton)]) {
            [self.delegate navigationViewDidPressRightButton];
        }
    }
}

@end
