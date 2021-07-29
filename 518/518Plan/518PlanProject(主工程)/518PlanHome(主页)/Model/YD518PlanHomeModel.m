//
//  YD518PlanHomeModel.m
//  518
//
//  Created by 郎烨 on 2021/7/27.
//

#import "YD518PlanHomeModel.h"

@implementation YD518PlanHomeItemModel

@end

@implementation YD518PlanHomeModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"result":[YD518PlanHomeItemModel class],
             @"reasonList":[self class]
             };
}

@end

