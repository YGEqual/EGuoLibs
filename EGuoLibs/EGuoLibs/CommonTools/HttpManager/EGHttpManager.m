//
//  EGHttpManager.m
//  EGuoLibs
//
//  Created by EGuo on 2020/7/10.
//  Copyright © 2020 小王同学. All rights reserved.
//

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
-(void)GET:(NSString *)url parameters:(NSDictionary *)parameters progress:(HttpProgress)progress success:(SuccessBlock)success failure:(FailedBlock)failure{
    
}

/// POST方法
/// @param url url
/// @param parameters parameters
/// @param success 成功回调
/// @param failure 失败回调
-(void)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailedBlock)failure{
    
}
/// POST方法
/// @param url url
/// @param parameters parameters
/// @param progress 请求的进度
/// @param success 成功回调
/// @param failure 失败回调
-(void)POST:(NSString *)url parameters:(NSDictionary *)parameters progress:(HttpProgress)progress success:(SuccessBlock)success failure:(FailedBlock)failure{
    
}

#pragma mark - 初始化
+(id)allocWithZone:(struct _NSZone *)zone{
    return [EGHttpManager sharedManager];
}

-(id)copyWithZone:(struct _NSZone *)zone{
    return [EGHttpManager sharedManager];
}

@end
