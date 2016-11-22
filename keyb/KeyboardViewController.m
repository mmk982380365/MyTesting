//
//  KeyboardViewController.m
//  keyb
//
//  Created by MaMingkun on 16/10/8.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "KeyboardViewController.h"

@interface KeyboardViewController ()
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@property (nonatomic, strong) UIButton *helloBtn;
@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Perform custom UI setup here
    self.nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.nextKeyboardButton setTitle:NSLocalizedString(@"Next Keyboard", @"Title for 'Next Keyboard' button") forState:UIControlStateNormal];
    [self.nextKeyboardButton sizeToFit];
    self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.nextKeyboardButton addTarget:self action:@selector(handleInputModeListFromView:withEvent:) forControlEvents:UIControlEventAllTouchEvents];
    
    [self.view addSubview:self.nextKeyboardButton];
    
    [self.nextKeyboardButton.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.nextKeyboardButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    
    self.helloBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.helloBtn setTitle:@"hello" forState:UIControlStateNormal];
    [self.helloBtn sizeToFit];
    self.helloBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.helloBtn addTarget:self action:@selector(helloAct:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.helloBtn];
    
    [self.helloBtn.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.helloBtn.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
}

-(void)helloAct:(UIButton *)btn{
    [self.textDocumentProxy insertText:@"hello world!"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}

@end
