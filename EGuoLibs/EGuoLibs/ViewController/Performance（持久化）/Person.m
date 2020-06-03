//
//  Person.m
//  EGuoLibs
//
//  Created by E.Guo on 2020/6/2.
//  Copyright © 2020 E.Guo. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>

@implementation Person

//归档
-(void)encodeWithCoder:(NSCoder *)coder{
    NSArray *propertys = [[self class] propertyNames];
    for (NSString *key in propertys) {
        [coder encodeObject:[self valueForKey:key] forKey:key];
    }
}

//解档
-(instancetype)initWithCoder:(NSCoder *)coder{
    if (self = [super init]) {
        NSArray *propertys = [[self class] propertyNames];
        for (NSString *key in propertys) {
            //  解档
            if ([coder decodeObjectForKey:key]) {
            //  赋值
                [self setValue:[coder decodeObjectForKey:key] forKey:key];
            }
        }
    }
    return self;
}

//通过runtime获取其的成员变量值 需注意释放free()
+(NSArray *)propertyNames
{
    unsigned int outCount;
    objc_property_t * propertyLists = class_copyPropertyList([self class], &outCount);
    
    NSMutableArray * propertyKeys = [NSMutableArray array];
    for (int i = 0;i<outCount;i++ ) {
        [propertyKeys addObject:[NSString stringWithUTF8String:property_getName(propertyLists[i])]];
    }
    free(propertyLists);
    return propertyKeys;
}

@end
