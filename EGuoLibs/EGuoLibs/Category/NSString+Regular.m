//
//  NSString+Regular.m
//  EGuoLibs
//
//  Created by E.Guo on 2020/5/28.
//  Copyright © 2020 E.Guo. All rights reserved.
//

#import "NSString+Regular.h"

@implementation NSString (Regular)

/// 仅包含数字
- (BOOL)isOnlyContainNumber{
    NSString *regular = @"[0-9]+";
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

/// 仅包含数字 + 字母（大小写）
- (void)isOnlyContainNumAndLetter{
    
}

#pragma mark - 正则相关
- (BOOL)isValidateByRegex:(NSString *)regex{
    NSPredicate * pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

@end
