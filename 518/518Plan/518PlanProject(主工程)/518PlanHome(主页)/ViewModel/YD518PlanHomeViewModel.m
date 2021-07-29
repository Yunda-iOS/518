//
//  YD518PlanHomeViewModel.m
//  518
//
//  Created by 郎烨 on 2021/7/27.
//

#import "YD518PlanHomeViewModel.h"

#define keyURL   @"types"

@interface YD518PlanHomeViewModel ()

@property (nonatomic, strong) YD518PlanHomeModel *model;

@end

@implementation YD518PlanHomeViewModel

- (void)initiateNetworkRequestForTheHomePage:(YD518PlanHttpSuccess)success {
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:YD518PLANKEY forKey:@"key"];
    
    id result = [NXNetWorkHelper readURL:keyURL params:dict];
    if (result != nil) {
        self.model = [YD518PlanHomeModel modelWithDictionary:result];
        !success ? : success();
        return;
    }
    
    [NXNetWorkHelper POST:keyURL parameters:dict responseCache:^(id responseCache) {} success:^(id responseObject) {
        self.model = [YD518PlanHomeModel modelWithDictionary:responseObject];
        !success ? : success();
    } failure:^(NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
}

- (YD518PlanHomeModel *)get518FuCaiSourcePlanHomeModel {
    return self.model;
}

- (YD518PlanHomeModel *)model {
    if (_model == nil) {
        _model = [YD518PlanHomeModel new];
    }
    return _model;
}

@end
