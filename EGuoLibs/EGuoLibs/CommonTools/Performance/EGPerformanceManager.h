//
//  EGPerformanceManager.h
//  EGuoLibs
//
//  Created by E.Guo on 2020/6/2.
//  Copyright © 2020 E.Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGPerformanceManager : NSObject

+(instancetype)sharedManager;

//目录自己定 - 存
-(void)writeToThePlist:(nonnull NSString *)targetPath fileData:(nonnull id)fileData;
//读取数据
-(id )readFromThePlist:(NSString *)targetPath;

//需要自己加 .plist
//写入Document目录下数据 - 可通过itunes进行同步
-(void)writeToDocumentPlist:(nullable NSString *)targetPath fileData:(nonnull id)fileData;

//写入在缓存目录下的数据
-(void)writeToCachePlist:(nullable NSString *)targetPath fileData:(nonnull id)fileData;

//写入在temp目录下的临时数据
-(void)writeToTempPlist:(nullable NSString *)targetPath fileData:(nonnull id)fileData;


//读取Document数据
-(id)readFromDocumentPlist:(NSString *)targetPath;
//读取缓存数据
-(id)readFromCachePlist:(NSString *)targetPath;
//读取temp数据
-(id)readFromTempPlist:(NSString *)targetPath;

//-(void)writeUserDefault:(NSString *)keyValue forKeyPath:(NSString *)keyPath;
//
//-(nullable id)readUserDefaultValue:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
