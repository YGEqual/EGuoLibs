//
//  APPPayManager.m
//  EGuoLibs
//
//  Created by 王义国 on 2020/7/8.
//  Copyright © 2020 小王同学. All rights reserved.
//
// 苹果要求，内购的虚拟货币是必须要走IAP的，所以基于这种需求，可以把IAP的方式做活，思路如下：
//1.用户进入购买虚拟物品页面，App从后台服务器获取产品列表然后显示给用户
//2.用户点击购买购买某一个虚拟物品，APP就发送该虚拟物品的productid到Apple服务器
//3.Apple服务器根据APP发送过来的productid返回相应的物品的信息（描述，价格等）
//4.用户点击确认键购买该物品，购买请求发送到Apple服务器
//5.Apple服务器完成购买后，返回用户一个完成购买的凭证
//6.APP发送这个凭证到后台服务器验证
//7.后台服务器把这个凭证发送到Apple验证，Apple返回一个字段给后台服务器表明该凭证是否有效
//8.后台服务器把验证结果在发送到APP，APP根据验证结果做相应的处理


//命名规则：
//内部方法 - (void)_方法名;
//外部方法 - (void)方法名;

#import "EGIAPManager.h"
//苹果内购
#import <StoreKit/StoreKit.h>
#import "GTMBase64.h"


#ifdef DEBUG // 处于开发阶段

#define VERIFY_RECEIPT_STATUS NO
#define VERIFY_RECEIPT_URL @"https://sandbox.itunes.apple.com/verifyReceipt"

#else// 处于发布阶段

#define VERIFY_RECEIPT_STATUS YES
#define VERIFY_RECEIPT_URL @"https://buy.itunes.apple.com/verifyReceipt"

#endif  /* DEBUG */


@interface EGIAPManager()<SKPaymentTransactionObserver,SKProductsRequestDelegate>
{
    NSString *_currentProductId;//当前购买的产品id
    
    SuccessIAPBlock _successIAPBlock;
    FailedIAPBlock  _failedIAPBlock;
}
@property(nonatomic, copy) NSString *receipt;

@end

@implementation EGIAPManager

+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static EGIAPManager *_manager = nil;
    dispatch_once(&onceToken, ^{
        _manager = [[super allocWithZone:NULL]init];
    });
    return _manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

#pragma mark - publick method
- (BOOL)isCanApplePay{
    if ([SKPaymentQueue canMakePayments]) {
        return YES;
    }
    return NO;
}

//发起支付
-(void)initiateApplePayment:(NSString *)productid successBlock:(SuccessIAPBlock)successBlock failedIAPBlock:(FailedIAPBlock)failedIAPBlock{
    //是否有IAP购买权限
    if ([self isCanApplePay]) {
        _successIAPBlock = successBlock;
        _failedIAPBlock = failedIAPBlock;
        [self _startIAPApplePayment:productid successBlock:successBlock failedIAPBlock:failedIAPBlock];
    } else {
        failedIAPBlock(@"用户禁止应用内付费购买");
    }
}

//内部方法
- (void)_startIAPApplePayment:(NSString *)productid successBlock:(SuccessIAPBlock)successBlock failedIAPBlock:(FailedIAPBlock)failedIAPBlock{
    _currentProductId = productid;
    
    //增加请求苹果的loading
    //[MyProgressHud showIndicator];
    
    NSMutableArray * purchasesArray = [NSMutableArray array];
    [purchasesArray addObject:productid];
    
    NSSet * set = [NSSet setWithArray:purchasesArray];
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    //提示 购买失败
    //[self show:@"购买失败"];
    _failedIAPBlock(@"购买失败,请重试");
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

#pragma mark - SKProductsRequestDelegate
- (void)paymentQueue:(nonnull SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStateFailed:
                {
                    [self failedTransaction:transaction];
                }
                    break;
            case SKPaymentTransactionStatePurchasing:
                {
                    EGLog(@"商品添加进列表！");
                }
                    break;
            case SKPaymentTransactionStatePurchased:
                {
                    //交易完成
                    EGLog(@"苹果支付成功！");
                    self.receipt = [GTMBase64 stringByEncodingData:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]]];
                    [self getIOSVerifyStutasHttpRequestWithtransaction:transaction receipt:self.receipt andPaytype:VERIFY_RECEIPT_STATUS];//把self.receipt发送到服务器验证是否有效
                    [self completeTransaction:transaction];
                }
                    break;
            case SKPaymentTransactionStateDeferred:
                {
                    EGLog(@"交易延迟");
                }
                    break;
            case SKPaymentTransactionStateRestored:
                {
                    //之前购买过此类产品
                    EGLog(@"之前购买过此类产品");
                    [self restoreTransaction:transaction];
                }
                    break;
            default:
            {
                
            }
                break;
        }
    }
}

//查询成功后的回调
- (void)productsRequest:(nonnull SKProductsRequest *)request didReceiveResponse:(nonnull SKProductsResponse *)response {
    if(response.products.count==0){
      EGLog(@"请求商品信息失败！");
        _failedIAPBlock(@"请求商品信息失败！");
//      [MyProgressHud hideIndicator];
//      [MyProgressHud showToastHUDView:@"请求商品信息失败！"];
      return;
    }
    EGLog(@"请求商品信息成功！发起购买");
    SKProduct * product = [response.products firstObject];
    EGLog(@"产品ID:%@",product.productIdentifier);
    EGLog(@"产品价格：%@",product.price);

    SKPayment * payment = [SKPayment paymentWithProduct:product];
    EGLog(@"发送购买请求");
//    [MyProgressHud hideIndicator];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//查询失败后的回调
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    ///  隐藏各种提示和loading
    EGLog(@"[error localizedDescription] = %@",[error localizedDescription]);
//    [self showMessage:[error localizedDescription]];
    _failedIAPBlock([error localizedDescription]);
}

#pragma mark - 初始化
+(id)allocWithZone:(struct _NSZone *)zone{
    return [EGIAPManager sharedManager];
}

-(id)copyWithZone:(struct _NSZone *)zone{
    return [EGIAPManager sharedManager];
}

//移除监听
-(void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

#pragma mark - 网络请求
/**
 内购的后台验证验证

 @param receipt 验证字段
 @param paytype 当前验证字段 0：沙盒环境；1：生产环境
 */
- (void)getIOSVerifyStutasHttpRequestWithtransaction:(SKPaymentTransaction *)transaction receipt:(id)receipt andPaytype:(BOOL)paytype
{
    //验证完成之后删除订单
    [self completeTransaction:transaction];
}

@end
