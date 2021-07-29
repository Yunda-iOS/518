//
//  NXNetWorkHelper.h
//  AiTouYun
//
//  Created by 郎烨 on 2018/1/2.
//  Copyright © 2018年 junjie.liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NXNetworkCache.h"

FOUNDATION_EXTERN NSString *kFaildCodeNetwork; // 断网
FOUNDATION_EXTERN NSString *kFaildCodeTimeout;

typedef NS_ENUM(NSUInteger, NXNetworkStatusType) {
    /// 未知网络
    NXNetworkStatusUnknown,
    /// 无网络
    NXNetworkStatusNotReachable,
    /// 手机网络
    NXNetworkStatusReachableViaWWAN,
    /// WIFI网络
    NXNetworkStatusReachableViaWiFi
};

typedef NS_ENUM(NSUInteger, NXRequestSerializer) {
    /// 设置请求数据为JSON格式
    NXRequestSerializerJSON,
    /// 设置请求数据为二进制格式
    NXRequestSerializerHTTP,
};

typedef NS_ENUM(NSUInteger, NXResponseSerializer) {
    /// 设置响应数据为JSON格式
    NXResponseSerializerJSON,
    /// 设置响应数据为二进制格式
    NXResponseSerializerHTTP,
};

/// 请求成功的Block
typedef void(^NXHttpRequestSuccess)(id responseObject);
/// 请求失败的Block
typedef void(^NXHttpRequestFailed)(NSError *error);
/// 缓存的Block
typedef void(^NXHttpRequestCache)(id responseCache);
/// 网络状态的Block
typedef void(^NXNetworkStatus)(NXNetworkStatusType status);


@class AFHTTPSessionManager;

@interface NXNetWorkHelper : NSObject

/// 有网YES, 无网:NO
+ (BOOL)isNetwork;
/// 手机网络:YES, 反之:NO
+ (BOOL)isWWANNetwork;
/// WiFi网络:YES, 反之:NO
+ (BOOL)isWiFiNetwork;
/// 实时获取网络状态,通过Block回调实时获取(此方法可多次调用)
+ (void)networkStatusWithBlock:(NXNetworkStatus)networkStatus;
/// 取消指定URL的HTTP请求
+ (void)cancelRequestWithURL:(NSString *)URL;
/// 开启日志打印 (Debug级别)
+ (void)openLog;
/// 关闭日志打印,默认关闭
+ (void)closeLog;
/// 是否取消之前的所有网络请求
+ (void)setIsCloseCancelAllRequest:(BOOL)isYES;

/**
 *  GET请求,无缓存
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                         parameters:(id)parameters
                            success:(NXHttpRequestSuccess)success
                            failure:(NXHttpRequestFailed)failure;
/**
 *  GET请求,无缓存,有提示框
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(id)parameters
                        isShowLoadingView:(BOOL)isShow
                           success:(NXHttpRequestSuccess)success
                           failure:(NXHttpRequestFailed)failure;

/**
 *  POST请求,无缓存
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(id)parameters
                            success:(NXHttpRequestSuccess)success
                            failure:(NXHttpRequestFailed)failure;

/**
 *  POST请求,自动缓存
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(id)parameters
                      responseCache:(NXHttpRequestCache)responseCache
                            success:(NXHttpRequestSuccess)success
                            failure:(NXHttpRequestFailed)failure;


/**
 *  POST请求,无缓存,有提示框
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(id)parameters
                          isShowLoadingView:(BOOL)isShow
                            success:(NXHttpRequestSuccess)success
                            failure:(NXHttpRequestFailed)failure;

/**
 *  POST请求,自动缓存,有提示框
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(id)parameters
                      isShowLoadingView:(BOOL)isShow
                      responseCache:(NXHttpRequestCache)responseCache
                            success:(NXHttpRequestSuccess)success
                            failure:(NXHttpRequestFailed)failure;

/**
 *  POST请求无缓存,有提示框, code码：9999、3001处理
 *  商品详情页,手机号快速登录接口,
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(id)parameters
                      isShowLoading:(BOOL)isShow
                            success:(NXHttpRequestSuccess)success
                            failure:(NXHttpRequestFailed)failure;

/**
 POST请求,无缓存,有提示框,可以传入数组或者json字符串

 @param URL 请求的接口地址
 @param parameters 传入的数组或者json字符串
 @param isShow 是否显示hud
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)POST:(NSString *)URL bodyParameters:(id)parameters isShowLoadingView:(BOOL)isShow success:(NXHttpRequestSuccess)success failure:(NXHttpRequestFailed)failure;

#pragma mark - 设置AFHTTPSessionManager相关属性
#pragma mark 注意: 因为全局只有一个AFHTTPSessionManager实例,所以以下设置方式全局生效

/**
 *  设置请求超时时间:默认为30S
 *  因为全局只有一个AFHTTPSessionManager实例,所以以下设置方式全局生效，在特殊时候的时候，网络成功之后修改为默认值
 *  @param time 时长
 */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time;

/// 是否有缓存内容
+ (id)readURL:(NSString *)URL params:(NSDictionary *)params;

@end
