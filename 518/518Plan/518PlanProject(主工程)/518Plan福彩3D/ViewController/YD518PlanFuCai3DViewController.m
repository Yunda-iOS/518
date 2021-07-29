//
//  YD518PlanFuCai3DViewController.m
//  518
//
//  Created by 郎烨 on 2021/7/27.
//

#import "YD518PlanFuCai3DViewController.h"
#import "YD518PlanFuCai3DViewModel.h"
#import "YD518PlanFuCai3DModel.h"


//#define BUNDLE_USER_PATH [[NSBundle mainBundle] pathForResource:@"fuCai3D" ofType:@"plist"]

@interface YD518PlanFuCai3DViewController ()

@property (nonatomic, strong) YD518PlanFuCai3DViewModel *fuCai3DViewModel;

@end

@implementation YD518PlanFuCai3DViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviTitle];
//    [self readLocalData];
    [self initialize518FuCai3DHomeUI];
//    [self.fuCai3DViewModel initiateTheNetworkRequestFucai3D:self.fuCaiItemModel];
    [self obtainProcessedFucai3DData];
}


#pragma Logic
/// 获取处理完的福彩3D数据
- (void)obtainProcessedFucai3DData {
    [self.fuCai3DViewModel obtainProcessedFucai3DData];
}

#pragma UI
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)setNaviTitle {
    self.title = @"福彩3D";
    self.navigationController.navigationBar.barTintColor = UIColor.redColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
           NSForegroundColorAttributeName:[UIColor purpleColor]}];
}

- (void)initialize518FuCai3DHomeUI {
    self.view.backgroundColor = UIColor.purpleColor;
}

- (YD518PlanFuCai3DViewModel *)fuCai3DViewModel {
    if (_fuCai3DViewModel == nil) {
        _fuCai3DViewModel = [YD518PlanFuCai3DViewModel new];
    }
    return _fuCai3DViewModel;
}

@end
