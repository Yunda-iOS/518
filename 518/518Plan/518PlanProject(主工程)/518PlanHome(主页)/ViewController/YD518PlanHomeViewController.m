//
//  YD518PlanHomeViewController.m
//  518
//
//  Created by 郎烨 on 2021/7/26.
//

#import "YD518PlanHomeViewController.h"
#import "YD518PlanFuCai3DViewController.h"
#import "YD518PlanHomeModel.h"
#import "YD518PlanHomeViewModel.h"
#import "YD518PlanHomeMainView.h"
#import "NXBaseModel.h"

#define keyURL   @"history"
@interface YD518PlanHomeViewController ()

@property (nonatomic, strong) YD518PlanHomeViewModel *viewModel;

@property (nonatomic, strong) YD518PlanHomeMainView *mainView;

@property (nonatomic, assign) NSInteger number;
@end

@implementation YD518PlanHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.number = 95;
//    [self testAction];
    
    [self initialize518HomeUI];
    [self bindJumpToOtherVCLogic];
    @weakify(self);
    self.mainView.plan518DidClickCell = ^(YD518PlanHomeItemModel * _Nonnull itemModel) {
        @strongify(self);
        YD518PlanFuCai3DViewController *fuCai3dVC = [YD518PlanFuCai3DViewController new];
        fuCai3dVC.fuCaiItemModel = itemModel;
        [self.navigationController pushViewController:fuCai3dVC animated:YES];
    };
    
}

- (void)testAction {
    NSDictionary *params = @{@"key":YD518PLANKEY,
                             @"lottery_id" : @"fcsd",
                             @"page_size":@50,
                             @"page":@(self.number)
    };
    [NXNetWorkHelper POST:keyURL parameters:params responseCache:^(id responseCache) {} success:^(id responseObject) {
        NXBaseModel *baseModel = [NXBaseModel modelWithDictionary:responseObject];
        NSLog(@"%ld",(long)self.number);
        self.number++;
        [self testAction];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma 逻辑
- (void)bindJumpToOtherVCLogic {
    
}

#pragma UI
- (void)initialize518HomeUI {
    self.view.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (YD518PlanHomeViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [YD518PlanHomeViewModel new];
    }
    return _viewModel;
}

- (YD518PlanHomeMainView *)mainView {
    if (_mainView == nil) {
        _mainView = [[YD518PlanHomeMainView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}

@end
