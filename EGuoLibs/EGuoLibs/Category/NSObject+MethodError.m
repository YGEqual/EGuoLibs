//
//  NSObject+MethodError.m
//  EGuoLibs
//
//  Created by EGuo on 2020/7/10.
//  Copyright © 2020 小王同学. All rights reserved.
//
//  解决unsignSelector 无方法实现的问题

#import "NSObject+MethodError.h"
#import "EGHook.h"
#import <objc/runtime.h>

@implementation NSObject (MethodError)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        [EGHook swizzlingMethodFromClass:class originalMethod:@selector(forwardingTargetForSelector:) targetMethod:@selector(yg_forwardingTargetForSelector:)];
    });
}

//1、因为我们做了方法交换，那么所有的方法都会走到我们这里
-(id)yg_forwardingTargetForSelector:(SEL)aSelector{
  //因为此方法是需要返回一个备用的消息接收者，所以我们可以去创建一个类，然后再去给这个类增加一个实现的方法就可以了
    //开始实现防崩溃的代码
    //判断本类是不是有方法，有方法就直接去调用方法
    BOOL isHaveMethod = NO;
    //不管是类方法还是实例方法，有就用本身，没有就给他来一个
    if (class_getInstanceMethod([self class], aSelector)) {
        isHaveMethod = YES;
    }
    //如果没有方法就返回了
    if (!isHaveMethod) {
        //1、创建备用类
        NSString *backup_str = @"backup_Class";
        Class backup_Class = NSClassFromString(backup_str);
        //2、给备用类加方法
        //class_addMethod(Class _Nullable cls, SEL _Nonnull name, IMP _Nonnull imp,const char * _Nullable types) 可以看一下这个方法的参数，第一个为类 第二个为方法编号，第三个是一个IMP方法映射，还有一个返回值
        if (!backup_Class)
        {
           Class superClass = [NSObject class];
           //objc_allocateClassPair:Creates a new class and metaclass.
           backup_Class = objc_allocateClassPair(superClass, "backup_Class", 0);
           /// 如果类没有对应的方法，则动态添加一个
           class_addMethod(backup_Class, aSelector, (IMP)sendMsg, "v@:");
           //注册到运行时环境(可点击进去 查看类的方法)
           objc_registerClassPair(backup_Class);
           /// 把消息转发到当前动态生成类的实例上
           return [[NSClassFromString(backup_str) alloc] init];
        }
        /// 如果类没有对应的方法，则动态添加一个
        if (!class_getInstanceMethod(NSClassFromString(backup_str), aSelector)) {
            class_addMethod(backup_Class, aSelector, (IMP)sendMsg, "v@:");
        }
        /// 把消息转发到当前动态生成类的实例上
        return [[NSClassFromString(backup_str) alloc] init];
    }
    //因为方法已经做了交换，所以必须要使用你交换过后的方法yg_forwardingTargetForSelector:
    return [self yg_forwardingTargetForSelector:aSelector];
}

//"v@:@",解释v-返回值void类型,@-self指针id类型,:-SEL指针SEL类型,@-函数第一个参数为id类型
void sendMsg(id self, SEL _cmd){
    EGLog(@"=== 快检查一下吧，你的%@好像没有实现 ===",NSStringFromSelector(_cmd));
}

@end
