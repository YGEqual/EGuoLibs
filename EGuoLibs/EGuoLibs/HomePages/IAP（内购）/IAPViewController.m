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
#import "EGHttpManager.h"

@interface IAPViewController ()

@end

@implementation IAPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[EGIAPManager sharedManager]initiateApplePayment:@"dasada" successBlock:^{
//        EGLog(@"成功");
//    } failedIAPBlock:^(NSString * _Nonnull error) {
//        EGLog(@"error = %@",error);
//        [EGProgressHud showIndicator];
//    }];
//    [[EGIAPManager sharedManager]initiateApplePayment:@"dasada" successBlock:^{
//        EGLog(@"成功");
//    } failedIAPBlock:^(NSString * _Nonnull error) {
//        EGLog(@"失败");
//    }];
    
    [EGHttpManager POST:@"" parameters:@{@"1":@"2"} success:^(id  _Nonnull response, BOOL status, NSInteger code) {
        EGLog(@"成功");
    } failure:^(NSError * _Nonnull error) {
        EGLog(@"%@", [NSString stringWithFormat:@"失败：%ld - %@",(long)error.code,error.localizedDescription]);
    }];
}

@end
