//
//  YD518PlanHomeViewModel.h
//  518
//
//  Created by 郎烨 on 2021/7/27.
//

#import <Foundation/Foundation.h>
#import "YD518PlanHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 缓存的Block
typedef void(^YD518PlanHttpSuccess)(void);

@interface YD518PlanHomeViewModel : NSObject

/// 发起首页的网络请求
- (void)initiateNetworkRequestForTheHomePage:(YD518PlanHttpSuccess)success;

/// 发起首页的网络请求
- (YD518PlanHomeModel *)get518FuCaiSourcePlanHomeModel;

@end

NS_ASSUME_NONNULL_END
