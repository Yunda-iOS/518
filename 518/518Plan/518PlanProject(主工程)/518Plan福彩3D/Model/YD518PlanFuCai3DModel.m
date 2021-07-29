//
//  YD518PlanFuCai3DModel.m
//  518
//
//  Created by 郎烨 on 2021/7/27.
//

#import "YD518PlanFuCai3DModel.h"



@implementation YD518PlanFuCai3DDictItemModel

@end



@implementation YD518PlanFuCai3DDictModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"lotteryResList":[YD518PlanFuCai3DDictItemModel class]
             };
}

@end



@implementation YD518PlanFuCai3DModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"result":[YD518PlanFuCai3DDictModel class]
             };
}

@end
