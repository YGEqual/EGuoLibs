//
//  NSString+Regular.h
//  EGuoLibs
//
//  Created by E.Guo on 2020/5/28.
//  Copyright © 2020 E.Guo. All rights reserved.
//

//  用于正则表达式的判断
//  适用于密码、文本框判断、邮件、手机号判断

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Regular)

/// 仅包含字母
-(BOOL)isOnlyContainLetter;
/// 仅包含小写字母
- (BOOL)isOnlyContainLowerLetter;
/// 仅包含大写字母
- (BOOL)isOnlyContainUpperLetter;
/// 仅包含数字 
-(BOOL)isOnlyContainNumber;
/// 仅包含数字 + 字母（大小写）
- (void)isOnlyContainNumAndLetter;

@end

NS_ASSUME_NONNULL_END
