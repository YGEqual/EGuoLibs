//
//  EGProgressHud.h
//  EGuoLibs
//
//  Created by 王义国 on 2020/7/10.
//  Copyright © 2020 小王同学. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGProgressHud : NSObject
+(void)showToastHUDView:(NSString *)title;
+(void)showToastHUDView:(NSString *)title afterDelay:(NSTimeInterval)delay;

//指示视图
+ (void)showIndicator;
+ (void)hideIndicator;
@end

NS_ASSUME_NONNULL_END
