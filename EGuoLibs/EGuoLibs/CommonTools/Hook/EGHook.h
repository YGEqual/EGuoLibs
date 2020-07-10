//
//  EGHook.h
//  EGuoLibs
//
//  Created by 王义国 on 2020/7/10.
//  Copyright © 2020 小王同学. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGHook : NSObject

/// 不同类的方法交换 - 字符串形式
/// @param originalClass 要交换的类
/// @param originalMethod 要交换的方法
/// @param targetClass target类
/// @param targetMethodname target的方法
+(void)swizzlingMethod:(NSString *)originalClass methodName:(NSString *)originalMethod targetClass:(NSString *)targetClass targetMethodName:(NSString *)targetMethodname;

/// 不同类的方法交换 - 类形式
/// @param originalClass 要交换的类 class
/// @param originalSelector 要交换的方法SEL
/// @param targetClass target类 class
/// @param targetSelector target的方法SEL
+(void)swizzlingMethodFromClass:(Class)originalClass originalMethod:(SEL)originalSelector targetClass:(Class)targetClass targetMethod:(SEL)targetSelector;

/// 同一类的方法交换
/// @param originalClass 交换方法的类
/// @param originalSelector 待交换的方法
/// @param targetSelector 交换的方法
+(void)swizzlingMethodFromClass:(Class)originalClass originalMethod:(SEL)originalSelector targetMethod:(SEL)targetSelector;

@end

NS_ASSUME_NONNULL_END
