//
//  YD518PlanFuCai3DProbabilityModel.h
//  518
//
//  Created by 郎烨 on 2021/7/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YD518PlanFuCai3DProbabilityModel : NSObject

/// 福彩3D数据
@property (nonatomic, copy) NSString *resultContent;
/// 每个福彩3D数据出现的概率
@property (nonatomic, assign) double probabilityResult;

@end

NS_ASSUME_NONNULL_END
