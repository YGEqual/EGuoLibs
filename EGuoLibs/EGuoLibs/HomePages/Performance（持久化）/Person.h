//
//  Person.h
//  EGuoLibs
//
//  Created by E.Guo on 2020/6/2.
//  Copyright © 2020 E.Guo. All rights reserved.
//

//  归档 NSCoding是必须要继承的协议

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject<NSCoding>

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *nickName;
@property (nonatomic, assign) int age;
@property (nonatomic, assign) BOOL isMan;

@end

NS_ASSUME_NONNULL_END
