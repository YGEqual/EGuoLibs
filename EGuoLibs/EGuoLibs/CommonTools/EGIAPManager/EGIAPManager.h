//
//  EGIAPManager.h
//  EGuoLibs
//
//  Created by EGuo on 2020/7/8.
//  Copyright © 2020 小王同学. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SuccessIAPBlock)(void);

typedef void(^FailedIAPBlock)(NSString *error);

@interface EGIAPManager : NSObject

+(instancetype)sharedManager;

/// 是否可以进行购买 
- (BOOL)isCanApplePay;


/// 发起支付
/// @param productid 购买产品id
/// @param successBlock 成功
/// @param failedIAPBlock 失败
-(void)initiateApplePayment:(NSString *)productid successBlock:(SuccessIAPBlock)successBlock failedIAPBlock:(FailedIAPBlock)failedIAPBlock;

@end

NS_ASSUME_NONNULL_END
