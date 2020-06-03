# EGuoLibs
Objective-C Libs
demo内附实现方法及调用方法

1、NSString+Regular ：iOS 正则表达式的Category，主要用于检测字母、数字和数字+字母组合、手机号、Email、身份证号ID、中文
方法包含：
```
/// 仅包含数字
- (BOOL)isOnlyContainNumber;
/// 包含数字 且必须是多少位之内的
- (BOOL)isOnlyContainNumber:(int)min max:(int)max;

/// 仅包含字母
-(BOOL)isOnlyContainLetter;
/// 仅包含小写字母
- (BOOL)isOnlyContainLowerLetter;
/// 仅包含大写字母
- (BOOL)isOnlyContainUpperLetter;
/// 包含字母 且必须是多少位之内的
- (BOOL)isOnlyContainLetter:(int)min max:(int)max;

/// 仅包含数字 + 字母（大小写）
- (BOOL)isContainNumAndLetter;

//是否为手机号
- (BOOL)isPhoneNumber;
//中文字符
- (BOOL)isOnlyContainChinese;
//是否是身份证号
- (BOOL)isPersonIDNumber;
// 是否为email地址
- (BOOL)isEmailAddress;
```
2、UIView+EGKitToast：Toast自定义toast显示文字、loading等

3、iOS 数据持久化：保存plist文件，读取plist文件、存储到指定文件目录下，归档解档
