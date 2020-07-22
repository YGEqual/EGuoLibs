# EGuoLibs
Objective-C Libs
demo内附实现方法及调用方法

>1、NSString+Regular ：iOS 正则表达式的Category，主要用于检测字母、数字和数字+字母组合、手机号、Email、身份证号ID、中文
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
>2、UIView+EGKitToast：Toast自定义toast显示文字、loading等

>3、iOS 数据持久化：保存plist文件，读取plist文件、存储到指定文件目录下，具体文件：`EGPerformanceManager.h`
归档解档 案例如下：可以根据Person去做自己的归档解档的具体实现

![归档解档案例](https://upload-images.jianshu.io/upload_images/3365194-fcbc82d358b7b8ac.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

>4、EGHook.h用于实现Runtime中的方法交换
```
/// 不同类的方法交换 - 字符串形式
/// @param originalClass 要交换的类
/// @param originalMethod 要交换的方法
/// @param targetClass target类
/// @param targetMethodname target的方法
+(void)swizzlingMethod:(NSString *)originalClass methodName:
(NSString *)originalMethod targetClass:(NSString *)targetClass 
targetMethodName:(NSString *)targetMethodname;

/// 不同类的方法交换 - 类形式
/// @param originalClass 要交换的类 class
/// @param originalSelector 要交换的方法SEL
/// @param targetClass target类 class
/// @param targetSelector target的方法SEL
+(void)swizzlingMethodFromClass:(Class)originalClass 
originalMethod:(SEL)originalSelector targetClass:(Class)targetClass 
targetMethod:(SEL)targetSelector;

/// 同一类的方法交换
/// @param originalClass 交换方法的类
/// @param originalSelector 待交换的方法
/// @param targetSelector 交换的方法
+(void)swizzlingMethodFromClass:(Class)originalClass
 originalMethod:(SEL)originalSelector targetMethod:
(SEL)targetSelector;
```

>5、EGIAPManager用于iOS中虚拟货币的购买功能，即：IAP内购。EGIAPSecurityHandle该类配合EGIAPManager类实现了异常情况的订单本地化保存功能，用于防止漏单情况的产生，和服务器端进行结合判断订单是否已完成，做的一个优化。具体EGIAPManager.h文件代码如下：
```
+(instancetype)sharedManager;

/// 是否可以进行购买 
- (BOOL)isCanApplePay;


/// 发起支付
/// @param productid 购买产品id
/// @param successBlock 成功
/// @param failedIAPBlock 失败
-(void)initiateApplePayment:(NSString *)productid successBlock:
(SuccessIAPBlock)successBlock failedIAPBlock:
(FailedIAPBlock)failedIAPBlock;


-------------------割--------------------
// 具体EGIAPSecurityHandle文件代码如下：
+(instancetype)sharedHandle;

//保存购买信息 用于订单追寻
-(void)saveReceipt:(NSString *)receipt;

//验证receipt失败,App启动后再次验证
- (void)sendFailedIAPFiles;

//验证成功就从plist中移除凭证
-(void)removeReceipt;
```
>6、实现HttpManager网络类的操作，给予AFNetworking封装的网络类（目前有GET、POST方法，和图片上传），后续会完善文件等上传接口，.h代码如下：
```
#import <Foundation/Foundation.h>
// 网络请求头文件
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^HttpProgress)(NSProgress *progress);

typedef void(^SuccessBlock)(id response,BOOL status,NSInteger code);

typedef void(^FailedBlock)(NSError *error);

@interface EGHttpManager : NSObject

+(instancetype)sharedManager;

/// GET方法
/// @param url url
/// @param parameters parameters
/// @param success 成功回调
/// @param failure 失败回调
+(void)GET:(NSString *)url parameters:(NSDictionary *)parameters 
success:(SuccessBlock)success failure:(FailedBlock)failure;
/// GET方法
/// @param url url
/// @param parameters parameters
/// @param progress 请求的进度
/// @param success 成功回调
/// @param failure 失败回调
+(void)GET:(NSString *)url parameters:(NSDictionary *)parameters 
progress:(_Nullable HttpProgress)progress success:
(SuccessBlock)success failure:(FailedBlock)failure;

/// POST方法
/// @param url url
/// @param parameters parameters
/// @param success 成功回调
/// @param failure 失败回调
+(void)POST:(NSString *)url parameters:(NSDictionary *)parameters 
success:(SuccessBlock)success failure:(FailedBlock)failure;

/// POST方法
/// @param url url
/// @param parameters parameters
/// @param progress 请求的进度
/// @param success 成功回调
/// @param failure 失败回调
+(void)POST:(NSString *)url parameters:(NSDictionary *)parameters
 progress:(_Nullable HttpProgress)progress success:
(SuccessBlock)success failure:(FailedBlock)failure;

/**
 *  上传图片的接口 -- 包括了图片的本地存储之后的上传
 *
 *  @param image         需要上传的图片
 *  @param url           上传图片的url(内部已经包含了网络地址和端口号等部分信息)
 *  @param parameters          参数
 *  @param picname          上传图片的名字
 *  @param success   上传成功之后的回调
 *  @param failure 上传失败之后的回调
 */
+(void)uploadImage:(UIImage *)image url:(NSString *)url 
parameters:(NSMutableDictionary *)parameters progress:
(HttpProgress)progress picName:(NSString *)picname success:
(SuccessBlock)success failure:(FailedBlock)failure;

/** 检测网络连接状况 */
+ (void)netWorkMonjor;
```
EGHttpSecurityHandle类用于网络安全类，用于防代理和防越狱的手机进行网络请求，特增加的一个安全类
```
/// iPhone是否设置了代理检查
+ (BOOL)getDelegateStatus;
/// iPhone越狱检查
+ (BOOL)getJailbrokenStatus;
```

>7、EGLocationManager 用于定位的简单使用 获取到当前定位的信息
```
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EGLocationInfoDelegate <NSObject>

//自己增加想要的代理方法用，目前只实现一个返回城市的
-(void)didUpdatingSuccess;

//获取失败。包括权限获取失败等
-(void)didUpdatingError;

@end

@interface EGLocationManager : NSObject

/// 开始获取位置信息-WhenInUse
- (void)startGetLocationInfoWhenInUse;
/// 开始获取位置信息-Always
- (void)startGetLocationInfoAlways;
/// 刷新位置信息
- (void)reloadLocationInfo;
/// 停止获取位置信息
- (void)stopGetLocationInfo;


// 位置名
@property(nonatomic, copy, readonly) NSString *name;
// 街道
@property(nonatomic, copy, readonly) NSString *thoroughfare;
// 子街道
@property(nonatomic, copy, readonly) NSString *subThoroughfare;
// 市
@property(nonatomic, copy, readonly) NSString *locality;
// 区
@property(nonatomic, copy, readonly) NSString *subLocality;
// 国家
@property(nonatomic, copy, readonly) NSString *country;

@property (nonatomic, weak)id<EGLocationInfoDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
```

>8、EGLocalNotificationCenter 本地通知管理类，负责发送本地通知

```
@interface EGLocalNotificationCenter : NSObject

-(instancetype)initWithIdentifier:(NSString *)pushIdentifier;

/// 本地通知
/// @param title 标题
/// @param subtitle 子标题
/// @param body 内容
- (void)pushLocalNotificationWithTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body;

/// 本地定时事件通知
/// @param title 标题
/// @param body 内容
- (void)pushCalendarNotificationWithTitle:(NSString *)title body:(NSString *)body;

@end
```
