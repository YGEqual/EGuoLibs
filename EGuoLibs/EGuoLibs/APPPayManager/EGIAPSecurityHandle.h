//
//  EGIAPSecurityHandle.h
//  EGuoLibs
//
//  Created by 王义国 on 2020/7/9.
//  Copyright © 2020 小王同学. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGIAPSecurityHandle : NSObject
+(instancetype)sharedHandle;

//保存购买信息 用于订单追寻
-(void)saveReceipt:(NSString *)receipt;

//验证receipt失败,App启动后再次验证
- (void)sendFailedIAPFiles;

//验证成功就从plist中移除凭证
-(void)removeReceipt;
@end

NS_ASSUME_NONNULL_END
