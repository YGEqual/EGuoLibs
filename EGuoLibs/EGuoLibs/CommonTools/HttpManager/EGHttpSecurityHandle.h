//
//  EGHttpSecurityHandle.h
//  EGuoLibs
//
//  Created by EGuo on 2020/7/10.
//  Copyright © 2020 小王同学. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGHttpSecurityHandle : NSObject
+(instancetype)sharedHandle;

/// iPhone是否设置了代理检查
+ (BOOL)getDelegateStatus;
/// iPhone越狱检查
+ (BOOL)getJailbrokenStatus;
@end

NS_ASSUME_NONNULL_END
