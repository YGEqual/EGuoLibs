//
//  EGProgressHud.m
//  EGuoLibs
//
//  Created by 王义国 on 2020/7/10.
//  Copyright © 2020 小王同学. All rights reserved.
//

#import "EGProgressHud.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface EGProgressHud()
@property(nonatomic,strong)MBProgressHUD * toastHUD;

@property(nonatomic,strong)UIView * indicatorView;
@end

@implementation EGProgressHud
static EGProgressHud * hud;
+ (instancetype)shareProgressHud
{
   
    static dispatch_once_t once ;
    dispatch_once(&once, ^{
        hud = [EGProgressHud new];
    });
    return hud;
}
+ (void)showToastHUDView:(NSString *)title
{
    [[EGProgressHud shareProgressHud] showToastHUDView:title];
}
- (void)showToastHUDView:(NSString *)title
{
    [self showToastHUDView:title afterDelay:1.5];
}

+ (void)showToastHUDView:(NSString *)title afterDelay:(NSTimeInterval)delay
{
    [[EGProgressHud shareProgressHud] showToastHUDView:title afterDelay:delay];
}

- (void)showToastHUDView:(NSString *)title afterDelay:(NSTimeInterval)delay
{
    if (_toastHUD != nil)
    {
        [_toastHUD removeFromSuperview];
    }
    
    _toastHUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    _toastHUD.mode = MBProgressHUDModeText;
    _toastHUD.removeFromSuperViewOnHide = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:_toastHUD];
    _toastHUD.detailsLabel.text = title;
    [_toastHUD showAnimated:YES];
    [_toastHUD hideAnimated:YES afterDelay:delay];
    _toastHUD.alpha = 0.9f;
}

#pragma mark - 懒加载
- (UIView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [UIView new];
        _indicatorView.frame = [UIScreen mainScreen].bounds;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 80)];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5.0f;
        view.backgroundColor = [UIColor darkGrayColor];
        view.alpha = 0.8;
        view.center = _indicatorView.center;
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(40, 15, 30, 30)];
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [indicator startAnimating];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 110, 30)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont systemFontOfSize:14];
        lab.text = @"购买中请稍候";
        
        [view addSubview:indicator];
        [view addSubview:lab];
        
        [_indicatorView addSubview:view];
    }
    return _indicatorView;
}

+ (void)showIndicator{
    [[EGProgressHud shareProgressHud] show];
}

- (void)show {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow addSubview:[EGProgressHud shareProgressHud].indicatorView];
    });
}

+ (void)hideIndicator
{
    [[EGProgressHud shareProgressHud] hide];
}

- (void)hide
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[EGProgressHud shareProgressHud].indicatorView removeFromSuperview];
    });
}

@end
