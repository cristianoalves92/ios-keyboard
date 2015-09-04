//
//  ScrollTestViewController.m
//  Keyboard Tests
//
//  Created by Cristiano Alves on 04/09/15.
//  Copyright (c) 2015 Cristiano Alves. All rights reserved.
//

#import "ScrollTestViewController.h"

@interface ScrollTestViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomContraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UITextField *activeTextField;

@end

@implementation ScrollTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self observeKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - observe Keyboard

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
        
        self.scrollViewBottomContraint.constant += keyboardSize.height;
        
        [UIView animateWithDuration:animationDuration animations:^{
            [self.view layoutIfNeeded];
            CGPoint scrollPoint = self.scrollView.contentOffset;
            
            scrollPoint.y = self.activeTextField.frame.origin.y - self.scrollView.frame.size.height + self.activeTextField.frame.size.height + 8;
            
            if(scrollPoint.y > 0) {
                
                [self.scrollView setContentOffset:scrollPoint animated:NO];
                
            }
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *info = [notification userInfo];
    NSValue *keyboardFrameValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardFrame = [keyboardFrameValue CGRectValue];
    CGSize keyboardSize = keyboardFrame.size;
    
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.scrollViewBottomContraint.constant -= keyboardSize.height;
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        [self.view layoutIfNeeded];
    }];
    
}

#pragma mark - textField delegate methods

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
    self.activeTextField = textField;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    
    self.activeTextField = nil;
}

- (bool) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}


@end
