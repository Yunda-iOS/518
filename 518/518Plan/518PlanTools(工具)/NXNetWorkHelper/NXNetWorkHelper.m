//
//  NXNetWorkHelper.m
//  AiTouYun
//
//  Created by 郎烨 on 2018/1/2.
//  Copyright © 2018年 junjie.liu. All rights reserved.
//

#import "NXNetWorkHelper.h"
#import "SVProgressHUD.h"
#import "NXBaseModel.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

/// 基本地址
#define kBaseURL   @"http://apis.juhe.cn/lottery/"
/// 基本地址后面加上接口地址
#define kNetBaseURL(_ref) [NSString stringWithFormat:@"%@%@",kBaseURL,(_ref)]

NSString *kFaildCodeNetwork = @"-1009"; /// 断网
NSString *kFaildCodeTimeout = @"-1001"; /// 请求超时
NSString *RESCODE_TOKEN_FAILED = @"1000"; /// token验证失败，失效
NSString *RESCODE_SUCESS = @"0000"; /// 返回成功
NSString *kNetWorkCancelled = @"-999"; /// 请求超时
NSString *RESCODE_TOKEN_VISITOR = @"1001"; /// token为空，标识游客

@implementation NXNetWorkHelper

static BOOL _isOpenLog;   // 是否已开启日志打印
static BOOL _isCancelRequest;   // 是否已开启日志打印
static NSMutableArray *_allSessionTask;
static AFHTTPSessionManager *_sessionManager;

+ (void)POST:(NSString *)URL bodyParameters:(id)parameters isShowLoadingView:(BOOL)isShow success:(NXHttpRequestSuccess)success failure:(NXHttpRequestFailed)failure {
    if (isShow) {
        [SVProgressHUD show];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    }
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:kNetBaseURL(URL) parameters:parameters error:nil];
    request.timeoutInterval = 60.f;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"%@",responseObject);
        [SVProgressHUD dismiss];
        if (!error) {
            if ([responseObject[@"resCode"] isEqualToString:RESCODE_SUCESS]) {
                !success ? : success(responseObject);
            } else if ([responseObject[@"resCode"] isEqualToString:RESCODE_TOKEN_FAILED]) {
                [NXNetWorkHelper presentLoginViewControllerWithCode:RESCODE_TOKEN_FAILED];
                return;
            } else if ([responseObject[@"resCode"] isEqualToString:RESCODE_TOKEN_VISITOR]) {
                [NXNetWorkHelper presentLoginViewControllerWithCode:RESCODE_TOKEN_VISITOR];
            } else {
                [SVProgressHUD dismissWithDelay:2.0f];
                [SVProgressHUD showInfoWithStatus:responseObject[@"resMsg"]];
            }
        } else {
            NSString *errorCode = [NSString stringWithFormat:@"%zd",error.code];
            NSLog(@"------errorCode%@",errorCode);
            [SVProgressHUD dismissWithDelay:2.0f];
            !failure ? : failure(error);
            NSLog(@"请求失败error=%@", error);
        }
    }];
    [task resume];
}

#pragma mark - 开始监听网络
+ (void)networkStatusWithBlock:(NXNetworkStatus)networkStatus {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                networkStatus ? networkStatus(NXNetworkStatusUnknown) : nil;
                if (_isOpenLog) NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                networkStatus ? networkStatus(NXNetworkStatusNotReachable) : nil;
                if (_isOpenLog) NSLog(@"无网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                networkStatus ? networkStatus(NXNetworkStatusReachableViaWWAN) : nil;
                if (_isOpenLog) NSLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                networkStatus ? networkStatus(NXNetworkStatusReachableViaWiFi) : nil;
                if (_isOpenLog) NSLog(@"WIFI");
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (BOOL)isNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)isWWANNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (BOOL)isWiFiNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

+ (void)openLog {
    _isOpenLog = YES;
}

+ (void)closeLog {
    _isOpenLog = NO;
}

+ (void)setIsCloseCancelAllRequest:(BOOL)isYES {
    _isCancelRequest = isYES;
}

+ (void)cancelAllRequest {
    // 锁操作
    @synchronized(self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self allSessionTask] removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)URL {
    if (!URL) { return; }
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[self allSessionTask] removeObject:task];
                *stop = YES;
            }
        }];
    }
}

#pragma mark - GET请求无缓存
+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(id)parameters
                           success:(NXHttpRequestSuccess)success
                           failure:(NXHttpRequestFailed)failure {
    return [self GET:URL parameters:parameters isShowLoadingView:NO success:success failure:failure];
}

#pragma mark - GET请求无缓存,有提示框
+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(id)parameters
                 isShowLoadingView:(BOOL)isShow
                           success:(NXHttpRequestSuccess)success
                           failure:(NXHttpRequestFailed)failure{
    if (isShow) {
        [SVProgressHUD show];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    }
    NSURLSessionTask *sessionTask = [_sessionManager GET:URL parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success(responseObject)%@",responseObject);
        if (isShow) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorCode = [NSString stringWithFormat:@"%zd",error.code];
        NSLog(@"errorCode%@",errorCode);
        if (isShow) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    return sessionTask;
    
}

#pragma mark - POST请求无缓存
+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(id)parameters
                   success:(NXHttpRequestSuccess)success
                   failure:(NXHttpRequestFailed)failure {
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    return [self POST:kNetBaseURL(URL) parameters:mutableDic responseCache:nil success:success failure:failure];
}

#pragma mark - POST请求自动缓存
+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(id)parameters
             responseCache:(NXHttpRequestCache)responseCache
                   success:(NXHttpRequestSuccess)success
                   failure:(NXHttpRequestFailed)failure {
    if (_isCancelRequest == NO) {[NXNetWorkHelper cancelAllRequest];}
    // 读取缓存
    responseCache!=nil ? responseCache([NXNetworkCache httpCacheForURL:kNetBaseURL(URL) parameters:parameters]) : nil;
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:kNetBaseURL(URL) parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        //对数据进行异步缓存
        responseCache!=nil ? [NXNetworkCache setHttpCache:responseObject URL:kNetBaseURL(URL) parameters:parameters] : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSString *errorCode = [NSString stringWithFormat:@"%zd",error.code];
        NSLog(@"errorCode%@",errorCode);
        [SVProgressHUD dismissWithDelay:2.0f];
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    return sessionTask;
}
#pragma mark - POST请求无缓存,有提示框
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(id)parameters
                  isShowLoadingView:(BOOL)isShow
                            success:(NXHttpRequestSuccess)success
                            failure:(NXHttpRequestFailed)failure {
    return [self POST:URL parameters:parameters isShowLoadingView:YES responseCache:nil success:success failure:failure];
}
#pragma mark - POST请求自动缓存,有提示框
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(id)parameters isShowLoadingView:(BOOL)isShow
                      responseCache:(NXHttpRequestCache)responseCache
                            success:(NXHttpRequestSuccess)success
                            failure:(NXHttpRequestFailed)failure {
    if (isShow) {
        [SVProgressHUD show];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    }
    if (_isCancelRequest == NO) {
        [NXNetWorkHelper cancelAllRequest];
    }
    //读取缓存
    responseCache!=nil ? responseCache([NXNetworkCache httpCacheForURL:URL parameters:parameters]) : nil;
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success(responseObject)%@",responseObject);
        if (isShow) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }

        NXBaseModel *baseModel = [NXBaseModel modelWithDictionary:responseObject];
        if ([baseModel.reason isEqualToString:RESCODE_TOKEN_FAILED]) {
            [NXNetWorkHelper presentLoginViewControllerWithCode:RESCODE_TOKEN_FAILED];
            return;
        }
        if ([baseModel.reason isEqualToString:RESCODE_TOKEN_VISITOR]) {
            [NXNetWorkHelper presentLoginViewControllerWithCode:RESCODE_TOKEN_VISITOR];
            return;
        }
        if (![baseModel.reason isEqualToString:RESCODE_SUCESS]) {
            [SVProgressHUD showErrorWithStatus:baseModel.reason];
            return ;
        }
        
        if (_isOpenLog) {NSLog(@"responseObject = %@",responseObject);}
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        //对数据进行异步缓存
        responseCache!=nil ? [NXNetworkCache setHttpCache:responseObject URL:URL parameters:parameters] : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorCode = [NSString stringWithFormat:@"%zd",error.code];
        NSLog(@"errorCode%@",errorCode);
        [SVProgressHUD dismissWithDelay:2.0f];
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    return sessionTask;
}

#pragma mark - POST请求无缓存,有提示框, code码：9999、3001处理
///商品详情页,手机号快速登录接口,
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(id)parameters
                      isShowLoading:(BOOL)isShow
                            success:(NXHttpRequestSuccess)success
                            failure:(NXHttpRequestFailed)failure {
    [_sessionManager.requestSerializer setValue:@"" forHTTPHeaderField:@"Authorization"];
    //    [_sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return [self POST:URL parameters:parameters isShowLoading:YES responseCache:nil success:success failure:failure];
}

#pragma mark - POST请求无缓存,有提示框, code码：9999、3001处理
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(id)parameters
                      isShowLoading:(BOOL)isShow
                      responseCache:(NXHttpRequestCache)responseCache
                            success:(NXHttpRequestSuccess)success
                            failure:(NXHttpRequestFailed)failure {
    if (isShow) {
        [SVProgressHUD show];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    }
    if (_isCancelRequest == NO) {
        [NXNetWorkHelper cancelAllRequest];
    }
    //读取缓存
    responseCache!=nil ? responseCache([NXNetworkCache httpCacheForURL:URL parameters:parameters]) : nil;
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success(responseObject)%@",responseObject);
        if (isShow) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
        
        NXBaseModel *baseModel = [NXBaseModel modelWithDictionary:responseObject];
        if ([baseModel.reason isEqualToString:RESCODE_TOKEN_FAILED]) {
            [NXNetWorkHelper presentLoginViewControllerWithCode:RESCODE_TOKEN_FAILED];
            return;
        }
        if ([baseModel.reason isEqualToString:RESCODE_TOKEN_VISITOR]) {
            [NXNetWorkHelper presentLoginViewControllerWithCode:RESCODE_TOKEN_VISITOR];
            return;
        }
        if (![baseModel.reason isEqualToString:RESCODE_SUCESS]) {
            success ? success(responseObject) : nil;
            return;
        }
        
        if (_isOpenLog) {NSLog(@"responseObject = %@",responseObject);}
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        //对数据进行异步缓存
        responseCache!=nil ? [NXNetworkCache setHttpCache:responseObject URL:URL parameters:parameters] : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorCode = [NSString stringWithFormat:@"%zd",error.code];
        NSLog(@"errorCode%@",errorCode);
        [SVProgressHUD dismissWithDelay:2.0f];
        if (_isOpenLog) {NSLog(@"error = %@",error);}
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    return sessionTask;
}


/**
 存储着所有的请求task数组
 */
+ (NSMutableArray *)allSessionTask {
    if (!_allSessionTask) {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}

#pragma mark - 推出登录页
+ (void)presentLoginViewControllerWithCode:(NSString *)codeStr {
    
//    NXLoginViewController *loginVC = [[NXLoginViewController alloc] init];
//    loginVC.dismissCodeType = codeStr;
//    NXNavigationViewController *navVC = [[NXNavigationViewController alloc] initWithRootViewController:loginVC];
//
//    UIViewController *result = nil;
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    if (window.windowLevel != UIWindowLevelNormal) {
//        NSArray *windows = [[UIApplication sharedApplication] windows];
//        for(UIWindow *tmpWin in windows) {
//            if (tmpWin.windowLevel == UIWindowLevelNormal) {
//                window = tmpWin;
//                break;
//            }
//        }
//    }
//    id nextResponder = nil;
//    UIViewController *appRootVC = window.rootViewController;
//    if (appRootVC.presentedViewController) {
//        nextResponder = appRootVC.presentedViewController;
//    } else {
//        UIView *frontView = [[window subviews] objectAtIndex:1];
//        nextResponder = [frontView nextResponder];
//    }
//
//    if ([nextResponder isKindOfClass:[UITabBarController class]]){
//        UITabBarController *tabbar = (UITabBarController *)nextResponder;
//        UINavigationController *nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
//        [nav presentViewController:navVC animated:YES completion:nil];
//    } else if ([nextResponder isKindOfClass:[UINavigationController class]]) {
//        UIViewController *nav = (UIViewController *)nextResponder;
//        result = nav.childViewControllers.lastObject;
//        [nav presentViewController:navVC animated:YES completion:nil];
//    } else if ([nextResponder isKindOfClass:[UIViewController class]]) {
//        UIViewController *nav = (UIViewController *)nextResponder;
//        [nav presentViewController:navVC animated:YES completion:nil];
//        result = nextResponder;
//    } else {
//        UIWindow *nav = (UIWindow *)nextResponder;
//        [nav.rootViewController presentViewController:navVC animated:YES completion:nil];
//        result = nextResponder;
//    }
}

#pragma mark - 初始化AFHTTPSessionManager相关属性
/**
 *  所有的HTTP请求共享一个AFHTTPSessionManager
 */
+ (void)initialize {
    _sessionManager = [AFHTTPSessionManager manager];
    _sessionManager.requestSerializer.timeoutInterval = 30.f;
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
//    _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

#pragma mark - 重置AFHTTPSessionManager相关属性
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time {
    _sessionManager.requestSerializer.timeoutInterval = time;
}

+ (void)openNetworkActivityIndicator:(BOOL)open {
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:open];
}

+ (id)readURL:(NSString *)URL params:(NSDictionary *)params {
    return [NXNetworkCache httpCacheForURL:kNetBaseURL(URL) parameters:params];
}
@end


#pragma mark - NSDictionary,NSArray的分类
/*
 ************************************************************************************
 *新建NSDictionary与NSArray的分类, 控制台打印json数据中的中文
 ************************************************************************************
 */

#ifdef DEBUG
@implementation NSArray (NX)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    [strM appendString:@")"];
    
    return strM;
}

@end

@implementation NSDictionary (NX)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [strM appendString:@"}\n"];
    
    return strM;
}
@end
#endif
