//
//  EGHttpManager.m
//  EGuoLibs
//
//  Created by EGuo on 2020/7/10.
//  Copyright © 2020 小王同学. All rights reserved.
//
//  非网络的业务逻辑不要放在网络类中，放在网络回调当中，明确业务 和 类结构

#import "EGHttpManager.h"
#import "EGProgressHud.h"

@implementation EGHttpManager

+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static EGHttpManager *_manager = nil;
    dispatch_once(&onceToken, ^{
        _manager = [[super allocWithZone:NULL]init];
    });
    return _manager;
}

#pragma mark - GET
/// GET方法
/// @param url url
/// @param parameters parameters
/// @param success 成功回调
/// @param failure 失败回调
+(void)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailedBlock)failure{
    [self GET:url parameters:parameters progress:nil success:success failure:failure];
}
/// GET方法
/// @param url url
/// @param parameters parameters
/// @param progress 请求的进度
/// @param success 成功回调
/// @param failure 失败回调
+(void)GET:(NSString *)url parameters:(NSDictionary *)parameters progress:(_Nullable HttpProgress)progress success:(SuccessBlock)success failure:(FailedBlock)failure{
    
    if (![self _isNetReachable]) {
        [EGProgressHud showToastHUDView:@"当前网络不可用"];
        if (failure) {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:202 userInfo:@{NSLocalizedDescriptionKey:@"当前网络不可用"}];
            failure(error);
        }
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        __block BOOL status = NO;
        //这个错误码 根据后台定义修改
        NSNumber *code = responseObject[@"code"];
        if ([responseObject[@"code"] isEqual:[NSNumber numberWithInt:200]]||[responseObject[@"result"] isEqualToString:@"success"]) {
            status = YES;
        }
        if (success) {
            success(responseObject,status,[code integerValue]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (failure) {
            failure(error);
        }
    }];
}

/// POST方法
/// @param url url
/// @param parameters parameters
/// @param success 成功回调
/// @param failure 失败回调
+(void)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailedBlock)failure{
    [self POST:url parameters:parameters progress:nil success:success failure:failure];
}
/// POST方法
/// @param url url
/// @param parameters parameters
/// @param progress 请求的进度
/// @param success 成功回调
/// @param failure 失败回调
+(void)POST:(NSString *)url parameters:(NSDictionary *)parameters progress:(_Nullable HttpProgress)progress success:(SuccessBlock)success failure:(FailedBlock)failure{
    //先判断网络是否可用
    if (![self _isNetReachable]) {
        [EGProgressHud showToastHUDView:@"当前网络不可用"];
        if (failure) {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:202 userInfo:@{NSLocalizedDescriptionKey:@"当前网络不可用"}];
            failure(error);
        }
        return;
    }
    
    AFHTTPSessionManager *sessionManager = [self _getSessionManager];
    
    EGLog(@"%@?%@",url,parameters);

    [sessionManager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        __block BOOL status = NO;
        NSNumber *code = responseObject[@"code"];
        //这个错误码 根据后台定义修改
        if ([responseObject[@"code"] isEqual:[NSNumber numberWithInt:200]]||[responseObject[@"result"] isEqualToString:@"success"]) {
            status = YES;
        }
        if (success) {
            success(responseObject,status,[code integerValue]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (failure) {
            failure(error);
        }
    }];
}

+(void)uploadImage:(UIImage *)image url:(NSString *)url parameters:(NSMutableDictionary *)parameters progress:(HttpProgress)progress picName:(NSString *)picname success:(SuccessBlock)success failure:(nonnull FailedBlock)failure{
    
    AFHTTPSessionManager *sessionManager = [self _getSessionManager];
    
    EGLog(@"%@?%@:picname:%@",url,parameters,picname);
    
    [sessionManager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        NSData *data = UIImageJPEGRepresentation(image, 0.1);
        if (!data) {
            data = [NSData data];
        }
        
        [formData appendPartWithFileData:data name:picname fileName:picname mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __block BOOL status = NO;
        NSNumber *code = responseObject[@"code"];
        //这个错误码 根据后台定义修改
        if ([responseObject[@"code"] isEqual:[NSNumber numberWithInt:200]]||[responseObject[@"result"] isEqualToString:@"success"]) {
            status = YES;
        }
        if (success) {
            success(responseObject,status,[code integerValue]);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure){
            failure(error);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

#pragma mark - 内部方法
//创建一个新的
+(AFHTTPSessionManager *)_getSessionManager{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //设置请求的序列化数据
    configuration.requestCachePolicy = NSURLRequestReturnCacheDataElseLoad;
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.requestSerializer.timeoutInterval = 60;
    //上传操作系统类型和当前版本号
    [sessionManager.requestSerializer setValue:@(NSURLRequestUseProtocolCachePolicy) forKey:@"cachePolicy"];
    [sessionManager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"device"];
    //获取当前系统的版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [sessionManager.requestSerializer setValue:app_Version forHTTPHeaderField:@"version"];
    
    //设置返回的序列化数据
//    /** 过滤nsnull参数 */
//    ((AFJSONResponseSerializer *)sessionManager.responseSerializer).removesKeysWithNullValues = YES;
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [sessionManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html",@"text/javascript",@"image/jpeg",@"image/png",@"text/plain",nil]];
    return sessionManager;
}

+(BOOL)_isNetReachable{
    /** 创建网络状态检测管理对象 */
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    return [manager isReachable];
}

/** 检测网络连接状况  返回网络是否可用*/
+ (void)netWorkMonjor
{
    /** 创建网络状态检测管理对象 */
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    /** 开启监听，否则不走block */
    [manager startMonitoring];

    /** 监听改变 */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown:
                {
                    EGLog(@"未知网络");
                    [EGProgressHud showToastHUDView:@"未知网络,网络不可用"];
                    return ;
                    break;
                }
            case AFNetworkReachabilityStatusNotReachable:

                {
                    EGLog(@"网络已断开");
                    [EGProgressHud showToastHUDView:@"网络已断开"];
                    return ;
                    break;
                }
            case AFNetworkReachabilityStatusReachableViaWWAN:
                {
                    EGLog(@"3G/4G网络已连接");
                    [EGProgressHud showToastHUDView:@"蜂窝数据网络已连接"];
                    return ;
                    break;
                }
            case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    [EGProgressHud showToastHUDView:@"WiFi网络已连接"];
                    return ;
                    break;
                }
            default:
                break;
        }
    }];
}

#pragma mark - 初始化
+(id)allocWithZone:(struct _NSZone *)zone{
    return [EGHttpManager sharedManager];
}

-(id)copyWithZone:(struct _NSZone *)zone{
    return [EGHttpManager sharedManager];
}

@end
