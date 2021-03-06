//
//  PTBWriteCommentVC.m
//  GraniouProjectManagement
//
//  Created by the Manticore iOS View Generator on 2014-07-15.
//  Copyright (c) 2014 GraniouProjectManagement. All rights reserved.
//

#import "PTBWriteCommentVC.h"

@interface PTBWriteCommentVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) NSString *commentaire;

- (IBAction)actionValider:(id)sender;
- (IBAction)actionCancel:(id)sender;

@end

@implementation PTBWriteCommentVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([[UIScreen mainScreen]bounds].size.height < 500) {
        [self registerForKeyboardNotifications];
    }
    
    _textView.text = _commentaire;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCommentaire:(NSString *)commentaire {
    _commentaire = [commentaire copy];
}


#pragma mark - Keyboard related stuff

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 40.0, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    [_scrollView setContentOffset:CGPointMake(0, 40) animated:YES];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - Actions

- (IBAction)actionValider:(id)sender {
    
    NSString *testLongueur = [_textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    testLongueur = [testLongueur stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    testLongueur = [testLongueur stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if (testLongueur.length > 1) {
        _commentaire = nil;
        
        NSString *result = [_textView.text stringByReplacingOccurrencesOfString:@"\n\n" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"\r\r" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"\n\r" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"\r " withString:@"\r"];
        result = [result stringByReplacingOccurrencesOfString:@"\n " withString:@"\n"];
        
        [self.delegate exitSavingComment:result];
    }
}

- (IBAction)actionCancel:(id)sender {
    _commentaire = nil;
    [self.delegate exitCancelling];
}
@end
