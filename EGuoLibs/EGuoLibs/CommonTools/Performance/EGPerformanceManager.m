//
//  EGPerformanceManager.m
//  EGuoLibs
//
//  Created by E.Guo on 2020/6/2.
//  Copyright © 2020 E.Guo. All rights reserved.
//

#import "EGPerformanceManager.h"

#define EG_DIRECTORY   CACHES_DIRECTORY(@"eg.plist")

@implementation EGPerformanceManager

+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static EGPerformanceManager *_manager = nil;
    dispatch_once(&onceToken, ^{
        _manager = [[super allocWithZone:NULL]init];
    });
    return _manager;
}

#pragma mark - plist持久化
-(void)writeToThePlist:(nonnull NSString *)targetPath fileData:(nonnull id)fileData{
    if (targetPath) {
        [fileData writeToFile:targetPath atomically:YES];
    }
}

//读取数据
-(id)readFromThePlist:(NSString *)targetPath{
    if (!targetPath) {
        return nil;
    }
    NSArray *fileArray = [NSArray arrayWithContentsOfFile:targetPath];
    if (fileArray) {
        return fileArray;
    }
    return [NSDictionary dictionaryWithContentsOfFile:targetPath];
}

//写入Document目录下数据 - 可通过itunes进行同步
-(void)writeToDocumentPlist:(nullable NSString *)targetPath fileData:(nonnull id)fileData{
    [self writeToThePlist:DOCUMENT_PATH(targetPath) fileData:fileData];
}

//写入在缓存目录下的数据
-(void)writeToCachePlist:(nullable NSString *)targetPath fileData:(nonnull id)fileData{
    [self writeToThePlist:CACHES_PATH(targetPath) fileData:fileData];
}

//写入在temp目录下的临时数据
-(void)writeToTempPlist:(nullable NSString *)targetPath fileData:(nonnull id)fileData{
    [self writeToThePlist:TEMP_PATH(targetPath) fileData:fileData];
}

//读取Document数据
-(id)readFromDocumentPlist:(NSString *)targetPath{
    return [self readFromThePlist:DOCUMENT_PATH(targetPath)];
}
//读取缓存数据
-(id)readFromCachePlist:(NSString *)targetPath{
    return [self readFromThePlist:CACHES_PATH(targetPath)];
}
//读取temp数据
-(id)readFromTempPlist:(NSString *)targetPath{
    return [self readFromThePlist:TEMP_PATH(targetPath)];
}

#pragma mark - 初始化
+(id)allocWithZone:(struct _NSZone *)zone{
    return [EGPerformanceManager sharedManager];
}

-(id)copyWithZone:(struct _NSZone *)zone{
    return [EGPerformanceManager sharedManager];
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

#pragma mark - 请阅读
//下面为一个单例对象的标准写法，
//+(instancetype)sharedManager{
//    static dispatch_once_t onceToken;
//    static EGPerformanceManager *_manager = nil;
//    dispatch_once(&onceToken, ^{
//        _manager = [[super allocWithZone:NULL]init];
//    });
//    return _manager;
//}
//
//#pragma mark - 初始化
//+(id)allocWithZone:(struct _NSZone *)zone{
//    return [EGPerformanceManager sharedManager];
//}
//
//-(id)copyWithZone:(struct _NSZone *)zone{
//    return [EGPerformanceManager sharedManager];
//}

@end
