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
+(void)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailedBlock)failure;
/// GET方法
/// @param url url
/// @param parameters parameters
/// @param progress 请求的进度
/// @param success 成功回调
/// @param failure 失败回调
+(void)GET:(NSString *)url parameters:(NSDictionary *)parameters progress:(_Nullable HttpProgress)progress success:(SuccessBlock)success failure:(FailedBlock)failure;

/// POST方法
/// @param url url
/// @param parameters parameters
/// @param success 成功回调
/// @param failure 失败回调
+(void)POST:(NSString *)url parameters:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailedBlock)failure;
/// POST方法
/// @param url url
/// @param parameters parameters
/// @param progress 请求的进度
/// @param success 成功回调
/// @param failure 失败回调
+(void)POST:(NSString *)url parameters:(NSDictionary *)parameters progress:(_Nullable HttpProgress)progress success:(SuccessBlock)success failure:(FailedBlock)failure;

/**
 *  上传图片的接口 -- 包括了图片的本地存储之后的上传
 *
 *  @param image         需要上传的图片
 *  @param url           上传图片的url(内部已经包含了网络地址和端口号等部分信息)
 *  @param parameters          参数
 *  @param picname          上传图片的名字
 *  @param success   上传成功之后的回调
 *  @param failure 上传失败之后的回调
 */
+(void)uploadImage:(UIImage *)image url:(NSString *)url parameters:(NSMutableDictionary *)parameters progress:(HttpProgress)progress picName:(NSString *)picname success:(SuccessBlock)success failure:(FailedBlock)failure;

/** 检测网络连接状况 */
+ (void)netWorkMonjor;
@end

NS_ASSUME_NONNULL_END
