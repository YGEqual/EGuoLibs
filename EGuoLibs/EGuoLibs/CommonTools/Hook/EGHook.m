//
//  EGHook.m
//  EGuoLibs
//
//  Created by 王义国 on 2020/7/10.
//  Copyright © 2020 小王同学. All rights reserved.
//

#import "EGHook.h"
#import <objc/runtime.h>

@implementation EGHook

+(void)swizzlingMethod:(NSString *)originalClass methodName:(NSString *)originalMethod targetClass:(NSString *)targetClass targetMethodName:(NSString *)targetMethodname{
    //你想要交换的原方法
    Method orginalMethod = class_getClassMethod(NSClassFromString(originalClass), NSSelectorFromString(originalMethod));
    //你要交换的方法
    Method targetMethod = class_getClassMethod(NSClassFromString(targetClass), NSSelectorFromString(targetMethodname));
    
    //交换
    method_exchangeImplementations(orginalMethod, targetMethod);
}

+(void)swizzlingMethodFromClass:(Class)originalClass originalMethod:(SEL)originalSelector targetClass:(Class)targetClass targetMethod:(SEL)targetSelector{
    //你想要交换的原方法
    Method originalMethod = class_getClassMethod(originalClass, originalSelector);
    //你要交换的方法
    Method targetMethod = class_getClassMethod(targetClass, targetSelector);
    
    //交换
    method_exchangeImplementations(originalMethod, targetMethod);
}

+(void)swizzlingMethodFromClass:(Class)originalClass originalMethod:(SEL)originalSelector targetMethod:(SEL)targetSelector{
    //你想要交换的原方法
    Method originalMethod = class_getClassMethod(originalClass, originalSelector);
    //你要交换的方法
    Method targetMethod = class_getClassMethod(originalClass, targetSelector);

    //交换
    method_exchangeImplementations(originalMethod, targetMethod);
    
//    BOOL didAddMethod = class_addMethod(originalClass, originalSelector, method_getImplementation(targetMethod), method_getTypeEncoding(targetMethod));
//    if (didAddMethod) {
//        class_replaceMethod(originalClass, targetSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//    }else{
//        //交换
//        method_exchangeImplementations(originalMethod, targetMethod);
//    }
}

@end
