//
//  DefineHeader.h
//  EGuoLibs
//
//  Created by E.Guo on 2020/5/28.
//  Copyright © 2020 E.Guo. All rights reserved.
//

#ifndef DefineHeader_h
#define DefineHeader_h

#pragma mark - 屏幕尺寸
// 设备全屏尺寸
#define UIScreenSize         [UIScreen mainScreen].bounds.size
// 设备全屏宽度
#define UIScreenWidth        [UIScreen mainScreen].bounds.size.width
// 设备全屏高度
#define UIScreenHeight       [UIScreen mainScreen].bounds.size.height

#pragma mark - iPhone特性
// 判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

// 判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

// 判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

#define IS_IPHONE_Xr2 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1624), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

// 判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

#define UIStatusBarHeight ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES || IS_IPHONE_Xr2 == YES) ? 44.0 : 20.0)
#define UINavBarHeight ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES || IS_IPHONE_Xr2 == YES) ? 88.0 : 64.0)
#define UITabBarHeight ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES || IS_IPHONE_Xr2 == YES ) ? 83.0 : 49.0)
//底部视图的高度
#define KBottomViewHeight ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES || IS_IPHONE_Xr2 == YES ) ? 64.0 : 44.0)

#define IS_IPHONE_XResult (IS_IPHONE_X||IS_IPHONE_Xr ||IS_IPHONE_Xs ||IS_IPHONE_Xs_Max || IS_IPHONE_Xr2)? @"1" : @"0"

#define IS_IPHONE_XStyle [IS_IPHONE_XResult boolValue]

//判断iPhone6系列
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iphone6+系列
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

#define UIViewHeight  UIScreenHeight - UINavBarHeight - UITabBarHeight

#define UIViewHeight_DivedNavBar (UIScreenHeight - UINavBarHeight)


#pragma mark - Global Color
// 基础颜色
#define UIColorClear                [UIColor clearColor]
#define UIColorWhite                [UIColor whiteColor]
#define UIColorBlack                [UIColor blackColor]
#define UIColorGray                 [UIColor grayColor]
#define UIColorRed                  [UIColor redColor]
#define UIColorGreen                [UIColor greenColor]
#define UIColorBlue                 [UIColor blueColor]
#define UIColorYellow               [UIColor yellowColor]
#define UIColorOrange               [UIColor orangeColor]
#define UIButtonBgColor             UIColorFromRGB(0xa3848c)

//颜色的定义
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0f]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define UIColorFromRGB(rgbValue) UIColorFromRGBA(rgbValue, 1.0)

// 适用于16进制直接6位颜色
#define UICOLORFROMRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// 十六进制加上透明度的设定
#define UICOLORFROMRGBA(rgbValue,alphas) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphas]


#pragma mark - 文件根路径
// Cache缓存的主目录 -- 缓存地址
#define CACHES_DIRECTORY     [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
// CACHES的目录下的文件
#define CACHES_PATH(path) [CACHES_DIRECTORY stringByAppendingPathComponent:path]
// Document的主目录 -- 可以通过itunes 进行同步
#define DOCUMENT_DIRECTORY   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
// DOCUMENT的目录下的文件
#define DOCUMENT_PATH(path) [DOCUMENT_DIRECTORY stringByAppendingPathComponent:path]
// TEMP的主目录 -- 不需要同步的临时数据
#define TEMP_DIRECTORY   NSTemporaryDirectory()
// TEMP的目录下的文件
#define TEMP_PATH(path) [TEMP_DIRECTORY stringByAppendingPathComponent:path]

#pragma mark - Apple 内购路径
#define AppStoreInfoLocalFilePath [NSString stringWithFormat:@"%@/%@/", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],@"EGLibAppleIAP"]

#pragma mark - 自定义输出方法
#ifdef DEBUG // 处于开发阶段
    #if TARGET_IPHONE_SIMULATOR
        #define EGLog(...) NSLog(@"[%@:%d] %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent],__LINE__,[NSString stringWithFormat:__VA_ARGS__] )

    #elif TARGET_OS_IPHONE
        #define LRString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
        #define EGLog(...) printf("%s 第%d行: %s\n\n",[LRString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
    #endif

#else// 处于发布阶段

#define EGLog(...)

#endif  /* DEBUG */


#endif /* DefineHeader_h */
