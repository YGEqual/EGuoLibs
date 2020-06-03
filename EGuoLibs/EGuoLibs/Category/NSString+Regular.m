//
//  NSString+Regular.m
//  EGuoLibs
//
//  Created by E.Guo on 2020/5/28.
//  Copyright © 2020 E.Guo. All rights reserved.
//
//  正则表达式学习网站：https://www.runoob.com/regexp/regexp-syntax.html 可定制化自己要的特殊的一些正则表达式的方法

//  须知：
//  + 号代表前面的字符必须至少出现一次（1次或多次）
//  * 号代表字符可以不出现，也可以出现一次或者多次（0次、或1次、或多次）
//  colou?r 可以匹配 color 或者 colour，? 问号代表前面的字符最多只可以出现一次（0次、或1次）
//
//  ^    匹配输入字符串开始的位置。
//  $    匹配输入字符串结尾的位置


#import "NSString+Regular.h"

@implementation NSString (Regular)

/// 仅包含数字
- (BOOL)isOnlyContainNumber{
    NSString *regular = @"[0-9]+";
    return [self isValidateByRegex:regular];
}

/// 包含数字 且必须是多少位之内的
- (BOOL)isOnlyContainNumber:(int)min max:(int)max{
    NSString *regular = [NSString stringWithFormat:@"[0-9]{%d,%d}",min,max];
    return [self isValidateByRegex:regular];
}

/// 仅包含小写字母
- (BOOL)isOnlyContainLowerLetter{
    NSString *regular = @"[a-z]+";
    return [self isValidateByRegex:regular];
}

/// 仅包含大写字母
- (BOOL)isOnlyContainUpperLetter{
    NSString *regular = @"[A-Z]+";
    return [self isValidateByRegex:regular];
}

/// 仅包含字母(小写字母+ 大写字母)
- (BOOL)isOnlyContainLetter{
    NSString *regular = @"[a-zA-Z]+";
    return [self isValidateByRegex:regular];
}

/// 包含字母 且必须是多少位之内的
- (BOOL)isOnlyContainLetter:(int)min max:(int)max{
    NSString *regular = [NSString stringWithFormat:@"[a-zA-Z]{%d,%d}",min,max];
    return [self isValidateByRegex:regular];
}

/// 仅包含数字 + 字母（大小写）
- (BOOL)isContainNumAndLetter{
    NSString *regular = @"^[A-Za-z0-9]+$";
    return [self isValidateByRegex:regular];
}

// 判断是否为手机号 1开头 0-9 结尾 且11位
- (BOOL)isPhoneNumber{
    NSString *regular = @"^[1-9][0-9]{10}$";
    return [self isValidateByRegex:regular];
}

//中文字符
- (BOOL)isOnlyContainChinese{
    NSString *regular = @"[\u4e00-\u9fa5]+";
    return [self isValidateByRegex:regular];
}

//是否是身份证号
- (BOOL)isPersonIDNumber{
    NSString *regular = @"\\d{17}[\\d|x]|\\d{15}";
    return [self isValidateByRegex:regular];
}

// 是否为email地址  \为双重转义字符
- (BOOL)isEmailAddress{
    NSString *regular = @"\\w[-\\w.+]*@([A-Za-z0-9][-A-Za-z0-9]+\\.)+[A-Za-z]{2,14}";
    return [self isValidateByRegex:regular];
}

#pragma mark - 正则相关
- (BOOL)isValidateByRegex:(NSString *)regex{
    NSPredicate * pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

@end
