//
//  EGHttpManager.m
//  EGuoLibs
//
//  Created by EGuo on 2020/7/10.
//  Copyright © 2020 小王同学. All rights reserved.
//
//  非网络的业务逻辑不要放在网络类中，放在网络回调当中，明确业务 和 类结构

#import "EGHttpManager.h"

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
-(void)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailedBlock)failure{
    [self GET:url parameters:parameters progress:nil success:success failure:failure];
}
/// GET方法
/// @param url url
/// @param parameters parameters
/// @param progress 请求的进度
/// @param success 成功回调
/// @param failure 失败回调
-(void)GET:(NSString *)url parameters:(NSDictionary *)parameters progress:(_Nullable HttpProgress)progress success:(SuccessBlock)success failure:(FailedBlock)failure{
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
-(void)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailedBlock)failure{
    [self POST:url parameters:parameters progress:nil success:success failure:failure];
}
/// POST方法
/// @param url url
/// @param parameters parameters
/// @param progress 请求的进度
/// @param success 成功回调
/// @param failure 失败回调
-(void)POST:(NSString *)url parameters:(NSDictionary *)parameters progress:(_Nullable HttpProgress)progress success:(SuccessBlock)success failure:(FailedBlock)failure{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestReturnCacheDataElseLoad;
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    sessionManager.requestSerializer.timeoutInterval = 60;
    [sessionManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html",@"text/javascript",nil]];
    //上传操作系统类型和当前版本号
    [sessionManager.requestSerializer setValue:@(NSURLRequestUseProtocolCachePolicy) forKey:@"cachePolicy"];
    [sessionManager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"device"];
    //获取当前系统的版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [sessionManager.requestSerializer setValue:app_Version forHTTPHeaderField:@"version"];
    
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

#pragma mark - 初始化
+(id)allocWithZone:(struct _NSZone *)zone{
    return [EGHttpManager sharedManager];
}

-(id)copyWithZone:(struct _NSZone *)zone{
    return [EGHttpManager sharedManager];
}

@end
