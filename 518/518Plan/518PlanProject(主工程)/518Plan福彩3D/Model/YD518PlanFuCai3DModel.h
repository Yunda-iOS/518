//
//  YD518PlanFuCai3DModel.h
//  518
//
//  Created by 郎烨 on 2021/7/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface YD518PlanFuCai3DDictItemModel : NSObject
/// 彩票ID
@property (nonatomic, copy) NSString *lottery_id;
/// 开奖结果
@property (nonatomic, copy) NSString *lottery_res;
/// 开奖期号
@property (nonatomic, copy) NSString *lottery_no;
/// 开奖日期
@property (nonatomic, copy) NSString *lottery_date;
/// 兑奖截止日期
@property (nonatomic, copy) NSString *lottery_exdate;
/// 本期销售额，可能为空
@property (nonatomic, copy) NSString *lottery_sale_amount;
/// 奖池滚存，可能为空
@property (nonatomic, copy) NSString *lottery_pool_amount;

@end



@interface YD518PlanFuCai3DDictModel : NSObject

/// 开奖结果列表
@property (nonatomic, strong) NSMutableArray<YD518PlanFuCai3DDictItemModel *> *lotteryResList;
/// 当前页数
@property (nonatomic, assign) NSInteger page;
/// 每页返回条数
@property (nonatomic, assign) NSInteger pageSize;
/// 总页数
@property (nonatomic, assign) NSInteger totalPage;

@end



@interface YD518PlanFuCai3DModel : NSObject

/// 百位
@property (nonatomic, assign) double hundredth;
/// 十位
@property (nonatomic, assign) double tenh;
/// 个位
@property (nonatomic, assign) double bit;



// 新增加的model属性
/// 返回说明
@property (nonatomic, copy) NSString *reason;
/// 返回码
@property (nonatomic, copy) NSString *error_code;
/// 返回结果集
@property (nonatomic, strong) YD518PlanFuCai3DDictModel *result;

@end

NS_ASSUME_NONNULL_END
