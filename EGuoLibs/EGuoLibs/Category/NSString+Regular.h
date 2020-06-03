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
/// 仅包含数字
- (BOOL)isOnlyContainNumber;
/// 包含数字 且必须是多少位之内的
- (BOOL)isOnlyContainNumber:(int)min max:(int)max;

/// 仅包含字母
-(BOOL)isOnlyContainLetter;
/// 仅包含小写字母
- (BOOL)isOnlyContainLowerLetter;
/// 仅包含大写字母
- (BOOL)isOnlyContainUpperLetter;
/// 包含字母 且必须是多少位之内的
- (BOOL)isOnlyContainLetter:(int)min max:(int)max;

/// 仅包含数字 + 字母（大小写）
- (BOOL)isContainNumAndLetter;

//是否为手机号
- (BOOL)isPhoneNumber;
//中文字符
- (BOOL)isOnlyContainChinese;
//是否是身份证号
- (BOOL)isPersonIDNumber;
// 是否为email地址
- (BOOL)isEmailAddress;

@end

NS_ASSUME_NONNULL_END
