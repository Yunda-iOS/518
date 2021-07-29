//
//  YD518PlanHomeMainView.m
//  518
//
//  Created by 郎烨 on 2021/7/27.
//

#import "YD518PlanHomeMainView.h"
#import "YD518PlanHomeModel.h"
#import "YD518PlanHomeViewMainCell.h"

@interface YD518PlanHomeMainView()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) YD518PlanHomeViewModel *viewModel;
@end

@implementation YD518PlanHomeMainView

- (instancetype)initWithViewModel:(YD518PlanHomeViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        [self initialUI];
        [self bindFucaiLogicAction];
    }
    return self;
}

- (void)bindFucaiLogicAction {
    [self.viewModel initiateNetworkRequestForTheHomePage:^{
        [self.mainTableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YD518PlanHomeModel *homeModel = [self.viewModel get518FuCaiSourcePlanHomeModel];
    return homeModel.result.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YD518PlanHomeViewMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YD518PlanHomeViewMainCell"];
    YD518PlanHomeModel *homeModel = [self.viewModel get518FuCaiSourcePlanHomeModel];
    YD518PlanHomeItemModel *itemModel = homeModel.result[indexPath.row];
    cell.fuCaiItemModel = itemModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self didselectRow:indexPath];
}

- (void)didselectRow:(NSIndexPath *)indexPath {
    YD518PlanHomeModel *homeModel = [self.viewModel get518FuCaiSourcePlanHomeModel];
    YD518PlanHomeItemModel *itemModel = homeModel.result[indexPath.row];
    !self.plan518DidClickCell ? : self.plan518DidClickCell(itemModel);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58 * 2;
}

- (void)initialUI {
    [self addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UITableView *)mainTableView {
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.backgroundColor = [UIColor purpleColor];
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsVerticalScrollIndicator = NO;
        [_mainTableView registerClass:[YD518PlanHomeViewMainCell class] forCellReuseIdentifier:@"YD518PlanHomeViewMainCell"];
    }
    return _mainTableView;
}

@end
