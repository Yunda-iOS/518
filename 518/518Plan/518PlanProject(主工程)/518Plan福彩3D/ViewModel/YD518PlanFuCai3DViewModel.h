//
//  YD518PlanFuCai3DViewModel.h
//  518
//
//  Created by 郎烨 on 2021/7/27.
//

#import <Foundation/Foundation.h>
#import "YD518PlanHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YD518PlanFuCai3DViewModel : NSObject

/// 获取处理完的福彩3D数据
- (NSArray *)obtainProcessedFucai3DData;

/// 发起福彩3D的网络请求
- (void)initiateTheNetworkRequestFucai3D:(YD518PlanHomeItemModel *)itemModel;

@end

NS_ASSUME_NONNULL_END
