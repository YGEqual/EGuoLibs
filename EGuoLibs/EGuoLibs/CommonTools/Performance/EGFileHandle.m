//
//  EGFileHandle.m
//  EGuoLibs
//
//  Created by EGuo on 2020/7/10.
//  Copyright © 2020 小王同学. All rights reserved.
//

#import "EGFileHandle.h"

@implementation EGFileHandle

+(instancetype)sharedHandle{
    static dispatch_once_t onceToken;
    static EGFileHandle *_handle = nil;
    dispatch_once(&onceToken, ^{
        _handle = [[super allocWithZone:NULL]init];
    });
    return _handle;
}

#pragma mark - 文件夹
- (void)createFolderWithFile:(NSString *)filePath{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    BOOL isExit = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    
    if (!isExit || !isDir)
    {
        [fileManager createDirectoryAtPath:filePath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
}

//删除文件
- (void)removeFolderWithFile:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath])
    {
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

//复制文件
- (void)copyFlolderFrom:(NSString *)filePath toPath:(NSString *)toPath {
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:toPath])
    {
        [fileManager removeItemAtPath:toPath error:&error];
    }
    [fileManager copyItemAtPath:filePath toPath:toPath error:&error];
}

//拷贝文件
- (void)copyFileWithFile:(NSString *)fileName from:(NSString *)filePath toPath:(NSString *)toPath {
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * fileToPath = [toPath stringByAppendingPathComponent:fileName];
    
    if ([fileManager fileExistsAtPath:fileToPath])
    {
        [fileManager removeItemAtPath:fileToPath error:&error];
    }
    [fileManager copyItemAtPath:[filePath stringByAppendingPathComponent:fileName]
                         toPath:toPath
                          error:&error];
}

//移动文件夹
- (void)moveFolderFrom:(NSString *)filePath toPath:(NSString *)toPath {
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:toPath])
    {
        [fileManager removeItemAtPath:toPath error:&error];
    }
    [fileManager moveItemAtPath:filePath toPath:toPath error:&error];
}

//移动文件
- (void)moveFileWithFile:(NSString *)fileName from:(NSString *)filePath to:(NSString *)toPath{
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * fileToPath = [toPath stringByAppendingPathComponent:fileName];
    
    if ([fileManager fileExistsAtPath:fileToPath])
    {
        [fileManager removeItemAtPath:fileToPath error:&error];
    }
    [fileManager moveItemAtPath:[filePath stringByAppendingPathComponent:fileName]
                         toPath:toPath
                          error:&error];
}

#pragma mark - 初始化
+(id)allocWithZone:(struct _NSZone *)zone{
    return [EGFileHandle sharedHandle];
}

-(id)copyWithZone:(struct _NSZone *)zone{
    return [EGFileHandle sharedHandle];
}

@end
