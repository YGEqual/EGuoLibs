//
//  AppDelegate.m
//  EGuoLibs
//
//  Created by E.Guo on 2020/5/28.
//  Copyright © 2020 E.Guo. All rights reserved.
//

#import "AppDelegate.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "EGIAPSecurityHandle.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //全应用点击输入内容外进行退出键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    //进行IAP验证购买问题
    NSFileManager *fileManager = [NSFileManager defaultManager];

    //从服务器验证receipt失败之后，在程序再次启动的时候，使用保存的receipt再次到服务器验证
    if ([fileManager fileExistsAtPath:AppStoreInfoLocalFilePath]) {
        //如果在改路下不存在文件，说明就没有保存验证失败后的购买凭证，也就是说发送凭证成功。
        //存在购买凭证，说明发送凭证失败，再次发起验证
        [[EGIAPSecurityHandle sharedHandle] sendFailedIAPFiles];
    }
    
    return YES;
}

#pragma mark - UISceneSession lifecycle
- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)){
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

@end
