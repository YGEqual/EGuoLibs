//
//  EGHttpSecurityHandle.m
//  EGuoLibs
//
//  Created by EGuo on 2020/7/10.
//  Copyright © 2020 小王同学. All rights reserved.
//

#import "EGHttpSecurityHandle.h"

@implementation EGHttpSecurityHandle

+(instancetype)sharedHandle{
    static dispatch_once_t onceToken;
    static EGHttpSecurityHandle *_handle = nil;
    dispatch_once(&onceToken, ^{
        _handle = [[super allocWithZone:NULL]init];
    });
    return _handle;
}

#pragma mark - 代理检查
+ (BOOL)getDelegateStatus{
    NSDictionary *proxySettings = CFBridgingRelease((__bridge CFTypeRef _Nullable)((__bridge NSDictionary *)CFNetworkCopySystemProxySettings()));
    NSArray *proxies = CFBridgingRelease((__bridge CFTypeRef _Nullable)((__bridge NSArray *)CFNetworkCopyProxiesForURL((__bridge CFURLRef)[NSURL URLWithString:@"http://www.google.com"], (__bridge CFDictionaryRef)proxySettings)));
    NSDictionary *settings = [proxies objectAtIndex:0];
    EGLog(@"host=%@", [settings objectForKey:(NSString *)kCFProxyHostNameKey]);
    EGLog(@"port=%@", [settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
    EGLog(@"type=%@", [settings objectForKey:(NSString *)kCFProxyTypeKey]);
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
        //没有设置代理
        return NO;
    }else{
        //设置代理了
        return YES;
    }
}

#pragma mark - 越狱检查
+ (BOOL)getJailbrokenStatus{
    // 检查是否存在越狱常用文件
    NSArray *jailFilePaths = @[@"/Applications/Cydia.app",
                               @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                               @"/bin/bash",
                               @"/usr/sbin/sshd",
                               @"/etc/apt"];
    for (NSString *filePath in jailFilePaths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            return YES;
        }
    }

    // 检查是否安装了越狱工具Cydia
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]]){
        return YES;
    }

    // 检查是否有权限读取系统应用列表
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Applications/"]){
        NSArray *applist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/User/Applications/"
                                                                               error:nil];
        NSLog(@"applist = %@",applist);
        return YES;
    }

    //  检测当前程序运行的环境变量
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    if (env != NULL) {
        return YES;
    }
    return NO;
}

#pragma mark - 初始化
+(id)allocWithZone:(struct _NSZone *)zone{
    return [EGHttpSecurityHandle sharedHandle];
}

-(id)copyWithZone:(struct _NSZone *)zone{
    return [EGHttpSecurityHandle sharedHandle];
}

@end
