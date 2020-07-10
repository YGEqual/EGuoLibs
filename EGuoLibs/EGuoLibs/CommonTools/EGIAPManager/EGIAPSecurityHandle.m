//
//  EGIAPSecurityHandle.m
//  EGuoLibs
//
//  Created by EGuo on 2020/7/9.
//  Copyright © 2020 小王同学. All rights reserved.
//

#import "EGIAPSecurityHandle.h"
#import "NSString+Regular.h"
#import "EGPerformanceManager.h"
#import "EGFileHandle.h"

@interface EGIAPSecurityHandle()

@end

@implementation EGIAPSecurityHandle

+(instancetype)sharedHandle{
    static dispatch_once_t onceToken;
    static EGIAPSecurityHandle *_handle = nil;
    dispatch_once(&onceToken, ^{
        _handle = [[super allocWithZone:NULL]init];
    });
    return _handle;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[EGFileHandle sharedHandle]createFolderWithFile:AppStoreInfoLocalFilePath];
    }
    return self;
}

//持久化存储用户购买凭证(这里最好还要存储当前日期，用户id等信息，用于区分不同的凭证)
- (void)saveReceipt:(NSString *)receipt{
    NSString *fileName = [NSString getUUIDString];
    NSString *savedPath = [AppStoreInfoLocalFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    
#warning 根据后台自定自己的值 用于判断
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //购买凭证 - 可根据后台配置自己的数据 但必须要有购买凭证，给后台告诉他让他去苹果服务器验证
    [dict setObject:receipt forKey:@"transactionReceipt"];
    [dict setObject:@"date" forKey:@"date"];
    [dict setObject:@"userid" forKey:@"userid"];
    
    [[EGPerformanceManager sharedManager]writeToThePlist:savedPath fileData:dict];
}

#warning didFinishLaunchingWithOptions方法中调用
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//
//    //从服务器验证receipt失败之后，在程序再次启动的时候，使用保存的receipt再次到服务器验证
//    if ([fileManager fileExistsAtPath:AppStoreInfoLocalFilePath]) {
//        //如果在改路下不存在文件，说明就没有保存验证失败后的购买凭证，也就是说发送凭证成功。
//        //存在购买凭证，说明发送凭证失败，再次发起验证
//        [self sendFailedIAPFiles];
//    }
//}

//验证receipt失败,App启动后再次验证
- (void)sendFailedIAPFiles{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;

    //搜索该目录下的所有文件和目录
    NSArray *cacheFileNameArray = [fileManager contentsOfDirectoryAtPath:AppStoreInfoLocalFilePath error:&error];

    if (error == nil)
    {
        for (NSString *name in cacheFileNameArray)
        {
            if ([name hasSuffix:@".plist"])//如果有plist后缀的文件，说明就是存储的购买凭证
            {
                NSString *filePath = [NSString stringWithFormat:@"%@/%@", AppStoreInfoLocalFilePath, name];
                [self sendAppStoreRequestBuyPlist:filePath];
            }
        }
    }else{
        EGLog(@"搜索AppStoreInfoLocalFilePath error:%@", [error domain]);
    }
}

-(void)sendAppStoreRequestBuyPlist:(NSString *)plistPath
{
    
//    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];

#warning 这里的参数请根据自己公司后台服务器接口定制，和持久化保存购买凭证保持一致
//    //这里的参数请根据自己公司后台服务器接口定制，但是必须发送的是持久化保存购买凭证
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//              [dic objectForKey:USERID],                           USERID,
//              [dic objectForKey:DATE],                             DATE,                                                                                                         [dic objectForKey:Request_transactionReceipt],      Request_transactionReceipt,
//                                                                       nil];

//    AFHTTPSessionManager manager]GET:@"后台服务器地址"  parameters:params    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        //凭证有效
//        if(YES){
//            [self removeReceipt]
//        }else{
//          //凭证无效
//          //你要做的事
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }
}

//验证成功就从plist中移除凭证
-(void)removeReceipt{
    [[EGFileHandle sharedHandle]removeFolderWithFile:AppStoreInfoLocalFilePath];
}

#pragma mark - 初始化
+(id)allocWithZone:(struct _NSZone *)zone{
    return [EGIAPSecurityHandle sharedHandle];
}

-(id)copyWithZone:(struct _NSZone *)zone{
    return [EGIAPSecurityHandle sharedHandle];
}


@end
