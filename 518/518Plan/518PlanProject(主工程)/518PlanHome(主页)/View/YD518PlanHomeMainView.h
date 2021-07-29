//
//  YD518PlanHomeMainView.h
//  518
//
//  Created by 郎烨 on 2021/7/27.
//

#import <UIKit/UIKit.h>
#import "YD518PlanHomeViewModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 缓存的Block
typedef void(^YD518PlanDidClickCell)(YD518PlanHomeItemModel *itemModel);

@interface YD518PlanHomeMainView : UIView

@property (nonatomic, copy) YD518PlanDidClickCell plan518DidClickCell;

- (instancetype)initWithViewModel:(YD518PlanHomeViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
