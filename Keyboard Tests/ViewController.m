//
//  ViewController.m
//  Keyboard Tests
//
//  Created by Cristiano Alves on 04/09/15.
//  Copyright (c) 2015 Cristiano Alves. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonVerticalSpaceConstraint;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self observeKeyboard];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - observe keyboard

- (void)observeKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Keyboard notification

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *info = [notification userInfo];
    
    NSValue *keyboardFrameValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSValue *keyboardBegin = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    NSValue *keyboardFinish= [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardBeginFrame = [keyboardBegin CGRectValue];
    CGRect keybordFinishFrame = [keyboardFinish CGRectValue];
    
    if(keyboardBeginFrame.origin.y > keybordFinishFrame.origin.y) {
        
        CGRect keyboardFrame = [keyboardFrameValue CGRectValue];
        CGSize keyboardSize = keyboardFrame.size;
        
        NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

        self.buttonVerticalSpaceConstraint.constant += keyboardSize.height;
        
        [UIView animateWithDuration:animationDuration animations:^{
            
            [self.view layoutIfNeeded];
        }];
        
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {

    NSDictionary *info = [notification userInfo];
    NSValue *keyboardFrameValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardFrame = [keyboardFrameValue CGRectValue];
    CGSize keyboardSize = keyboardFrame.size;
    
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.buttonVerticalSpaceConstraint.constant -= keyboardSize.height;
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        [self.view layoutIfNeeded];
    }];
    
}

#pragma mark - button action

- (IBAction)hideKeyboardButtonAction:(id)sender {
    
    [self.textView endEditing:YES];
}

@end
