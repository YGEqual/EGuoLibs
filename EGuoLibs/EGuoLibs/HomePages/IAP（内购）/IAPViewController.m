//
//  IAPViewController.m
//  EGuoLibs
//
//  Created by EGuo on 2020/7/9.
//  Copyright © 2020 小王同学. All rights reserved.
//

#import "IAPViewController.h"
#import "EGIAPManager.h"
#import "EGIAPSecurityHandle.h"
#import "EGProgressHud.h"

@interface IAPViewController ()

@end

@implementation IAPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[EGIAPManager sharedManager]initiateApplePayment:@"dasada" successBlock:^{
        EGLog(@"成功");
    } failedIAPBlock:^(NSString * _Nonnull error) {
        EGLog(@"error = %@",error);
        [EGProgressHud showIndicator];
    }];
}

@end
