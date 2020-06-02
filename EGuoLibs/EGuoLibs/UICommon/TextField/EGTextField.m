//
//  EGTextField.m
//  EGuoLibs
//
//  Created by E.Guo on 2020/6/2.
//  Copyright © 2020 E.Guo. All rights reserved.
//

#import "EGTextField.h"

@implementation EGTextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setMainUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setMainUI];
    }
    return self;
}

// UI
- (void)setMainUI{
    self.backgroundColor = UIColorGray;
    self.layer.borderColor = UIColorGreen.CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5.f;
}

- (void)hiddenInputView{
    //输入视图为系统默认键盘
    self.inputView = nil;
    self.inputAccessoryView = nil;
    UITextInputAssistantItem* item = [self inputAssistantItem];
    item.leadingBarButtonGroups = @[];
    item.trailingBarButtonGroups = @[];
    
    UIToolbar *topView = [[UIToolbar alloc]initWithFrame:CGRectZero];
    [topView setBarStyle:UIBarStyleBlackTranslucent];
    [self setInputAccessoryView:topView];
}

@end
