//
//  RegularVC.m
//  EGuoLibs
//
//  Created by E.Guo on 5050/5/28.
//  Copyright © 5050 E.Guo. All rights reserved.
//

#import "RegularVC.h"
#import "NSString+Regular.h"
#import "EGButton.h"
#import "UIView+EGKitToast.h"
#import "EGTextField.h"

@interface RegularVC ()
@property(nonatomic, strong) EGTextField *verifyTF;
@property(nonatomic, strong) EGButton *numberBtn;//验证纯数字
@property(nonatomic, strong) EGButton *letterBtn;//验证纯字母
@property(nonatomic, strong) EGButton *numberAndLetterBtn;//验证数字+字母

@end

@implementation RegularVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.verifyTF = [[EGTextField alloc]init];
        [self.verifyTF hiddenInputView];
        
        self.numberBtn = [EGButton buttonWithType:UIButtonTypeCustom];
        self.numberBtn.btntitle = @"是否为纯数字";
        [self.numberBtn addTarget:self action:@selector(numberAction:)];
        
        self.letterBtn = [EGButton buttonWithType:UIButtonTypeCustom];
        self.letterBtn.btntitle = @"是否为纯字母";
        [self.letterBtn addTarget:self action:@selector(letterAction:)];
        
        self.numberAndLetterBtn = [EGButton buttonWithType:UIButtonTypeCustom];
        self.numberAndLetterBtn.btntitle = @"是否为数字+字母";
        [self.numberAndLetterBtn addTarget:self action:@selector(numLetAction:)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.verifyTF];
    [self.view addSubview:self.numberBtn];
    [self.view addSubview:self.letterBtn];
    [self.view addSubview:self.numberAndLetterBtn];
    
    [self.verifyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(UINavBarHeight + 20.f);
        make.left.equalTo(self.view.mas_left).offset(50.f);
        make.right.equalTo(self.view.mas_right).offset(-50.f);
        make.height.equalTo(@44.f);
    }];
    
    [self.numberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verifyTF.mas_bottom).offset(20.f);
        make.left.equalTo(self.view.mas_left).offset(50.f);
        make.right.equalTo(self.view.mas_right).offset(-50.f);
        make.height.equalTo(@44.f);
    }];
    [self.letterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberBtn.mas_bottom).offset(20.f);
        make.left.equalTo(self.view.mas_left).offset(50.f);
        make.right.equalTo(self.view.mas_right).offset(-50.f);
        make.height.equalTo(@44.f);
    }];
    [self.numberAndLetterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.letterBtn.mas_bottom).offset(20.f);
        make.left.equalTo(self.view.mas_left).offset(50.f);
        make.right.equalTo(self.view.mas_right).offset(-50.f);
        make.height.equalTo(@44.f);
    }];
}

#pragma mark - Action
//纯数字
- (void)numberAction:(UIButton *)button{
    [self.view endEditing:YES];
    BOOL isYES = [self.verifyTF.text isOnlyContainNumber];
    [self.view egkit_makeToast:isYES?@"仅包含数字":@"不仅包含数字"];
}

//纯字母
- (void)letterAction:(UIButton *)button{
    [self.view endEditing:YES];
    BOOL isYES = [self.verifyTF.text isOnlyContainLetter];
    [self.view egkit_makeToast:isYES?@"仅包含字母":@"不仅包含字母"];
}

//数字+字母
- (void)numLetAction:(UIButton *)button{
    [self.view endEditing:YES];
    BOOL isYES = [self.verifyTF.text isOnlyContainLetter];
    [self.view egkit_makeToast:isYES?@"仅包含数字+字母":@"不仅包含数字+字母"];
}


@end
