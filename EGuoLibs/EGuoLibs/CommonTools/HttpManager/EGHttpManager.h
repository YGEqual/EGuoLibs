//
//  EGHttpManager.h
//  EGuoLibs
//
//  Created by EGuo on 2020/7/10.
//  Copyright © 2020 小王同学. All rights reserved.
//

#import <Foundation/Foundation.h>
// 网络请求头文件
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^HttpProgress)(NSProgress *progress);

typedef void(^SuccessBlock)(id response,BOOL status,NSInteger code);

typedef void(^FailedBlock)(NSError *error);

@interface EGHttpManager : NSObject

+(instancetype)sharedManager;

/// GET方法
/// @param url url
/// @param parameters parameters
/// @param success 成功回调
/// @param failure 失败回调
-(void)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailedBlock)failure;
/// GET方法
/// @param url url
/// @param parameters parameters
/// @param progress 请求的进度
/// @param success 成功回调
/// @param failure 失败回调
-(void)GET:(NSString *)url parameters:(NSDictionary *)parameters progress:(_Nullable HttpProgress)progress success:(SuccessBlock)success failure:(FailedBlock)failure;

/// POST方法
/// @param url url
/// @param parameters parameters
/// @param success 成功回调
/// @param failure 失败回调
-(void)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailedBlock)failure;
/// POST方法
/// @param url url
/// @param parameters parameters
/// @param progress 请求的进度
/// @param success 成功回调
/// @param failure 失败回调
-(void)POST:(NSString *)url parameters:(NSDictionary *)parameters progress:(_Nullable HttpProgress)progress success:(SuccessBlock)success failure:(FailedBlock)failure;


@end

NS_ASSUME_NONNULL_END
