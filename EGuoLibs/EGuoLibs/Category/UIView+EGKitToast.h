//
//  UIView+Toast.h
//  EGuoLibs
//
//  Created by E.Guo on 2020/6/2.
//  Copyright © 2020 E.Guo. All rights reserved.
//
//  toastview 展示
//  适用于toast提示，和定制化toastview
//  适用于展示loading 和带有image的loadview

#import <UIKit/UIKit.h>

extern NSString * const EGKitToastPositionTop;
extern NSString * const EGKitToastPositionCenter;
extern NSString * const EGKitToastPositionBottom;

@interface UIView (EGKitToast)

// each makeToast method creates a view and displays it as toast
- (void)egkit_makeToast:(NSString *)message;
- (void)egkit_makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position;
- (void)egkit_makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position image:(UIImage *)image;
- (void)egkit_makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position title:(NSString *)title;
- (void)egkit_makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position title:(NSString *)title image:(UIImage *)image;

// displays toast with an activity spinner
- (void)egkit_makeToastActivity;
- (void)egkit_makeToastActivity:(id)position;
- (void)egkit_hideToastActivity;

// the showToast methods display any view as toast
- (void)egkit_showToast:(UIView *)toast;
- (void)egkit_showToast:(UIView *)toast duration:(NSTimeInterval)interval position:(id)point;
- (void)egkit_showToast:(UIView *)toast duration:(NSTimeInterval)interval position:(id)point
      tapCallback:(void(^)(void))tapCallback;

@end
