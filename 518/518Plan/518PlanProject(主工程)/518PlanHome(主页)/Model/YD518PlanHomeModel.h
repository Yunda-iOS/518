//
//  YD518PlanHomeModel.h
//  518
//
//  Created by 郎烨 on 2021/7/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YD518PlanHomeItemModel : NSObject
/// 彩票ID
@property (nonatomic, copy) NSString *lottery_id;
/// 彩票名称
@property (nonatomic, copy) NSString *lottery_name;
/// 彩票类型，1:福利彩票 2:体育彩票
@property (nonatomic, copy) NSString *lottery_type_id;
/// 描述信息
@property (nonatomic, copy) NSString *remarks;

@end

@interface YD518PlanHomeModel : NSObject

@property (nonatomic, strong) NSMutableArray<YD518PlanHomeItemModel *> *result;

@end

NS_ASSUME_NONNULL_END
