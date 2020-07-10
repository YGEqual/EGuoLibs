//
//  EGFileHandle.h
//  EGuoLibs
//
//  Created by EGuo on 2020/7/10.
//  Copyright © 2020 小王同学. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGFileHandle : NSObject
+(instancetype)sharedHandle;

/// 新建文件夹
/// @param filePath 文件路径
- (void)createFolderWithFile:(NSString *)filePath;

/// 移除文件夹
/// @param filePath 文件路径
- (void)removeFolderWithFile:(NSString *)filePath;

//复制文件
- (void)copyFlolderFrom:(NSString *)filePath toPath:(NSString *)toPath;

//拷贝文件
- (void)copyFileWithFile:(NSString *)fileName from:(NSString *)filePath toPath:(NSString *)toPath;
//移动文件夹
- (void)moveFolderFrom:(NSString *)filePath toPath:(NSString *)toPath;

//移动文件
- (void)moveFileWithFile:(NSString *)fileName from:(NSString *)filePath to:(NSString *)toPath;

@end

NS_ASSUME_NONNULL_END
