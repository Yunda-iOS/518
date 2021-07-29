//
//  YD518PlanFuCai3DViewModel.m
//  518
//
//  Created by 郎烨 on 2021/7/27.
//

#import "YD518PlanFuCai3DViewModel.h"
#import "YD518PlanFuCai3DModel.h"
#import "YD518PlanFuCai3DProbabilityModel.h"
#import "NXNetWorkHelper.h"
#import "NXBaseModel.h"

#define BUNDLE_USER_PATH [[NSBundle mainBundle] pathForResource:@"fuCai3D" ofType:@"plist"]

#define keyURL   @"history"

@interface YD518PlanFuCai3DViewModel ()

/// 福彩3D的基础数据
@property (nonatomic, strong) NSArray *fuCai3DBasicArray;
/// 福彩3D的原始数据
@property (nonatomic, strong) NSArray *fuCai3DData;
/// 福彩3D的模型数据
@property (nonatomic, strong) NSMutableArray *fuCai3DArray;
/// 福彩3D的全部可能数据 和 每个可能数据的概率
@property (nonatomic, strong) NSMutableArray *fuCai3DProbabilityArray;

/// 当前的页数
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation YD518PlanFuCai3DViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.currentPage = 2;
        [self processing3DDataOfFucai];
    }
    return self;
}

- (void)initiateTheNetworkRequestFucai3D:(YD518PlanHomeItemModel *)itemModel {
    
    NSDictionary *params = @{@"key":YD518PLANKEY,
                             @"lottery_id" : itemModel.lottery_id,
                             @"page_size":@50,
                             @"page":@(2)
    };
    [NXNetWorkHelper POST:keyURL parameters:params responseCache:^(id responseCache) {} success:^(id responseObject) {
        NXBaseModel *baseModel = [NXBaseModel modelWithDictionary:responseObject];
        NSLog(@"%@",baseModel.result);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
}

- (void)readLocalData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fucai" ofType:@"json"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    YD518PlanFuCai3DModel *model = [YD518PlanFuCai3DModel modelWithDictionary:dict];
    NSLog(@"%@",model);
}


- (NSArray *)obtainProcessedFucai3DData {
    return self.fuCai3DArray;
}

/// 处理福彩3D数据：返回数据出现的频次
- (void)processing3DDataOfFucai {
//    self.fuCai3DData = [[NSArray alloc] initWithContentsOfFile:BUNDLE_USER_PATH];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fucai" ofType:@"json"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    YD518PlanFuCai3DModel *model = [YD518PlanFuCai3DModel modelWithDictionary:dict];
    self.fuCai3DData = model.result.lotteryResList;
    
    
    
    
    NSMutableArray *hundredthArray = [NSMutableArray new];
    NSMutableArray *tenhArray = [NSMutableArray new];
    NSMutableArray *bitArray = [NSMutableArray new];
    
    for (int i = 0; i < self.fuCai3DData.count; i++) {
        YD518PlanFuCai3DDictItemModel *itemModel = self.fuCai3DData[i];
        
        NSArray *fuCai3DHistoryArray = [itemModel.lottery_res componentsSeparatedByString:@","];
        [hundredthArray addObject:fuCai3DHistoryArray.firstObject];
        [tenhArray addObject:fuCai3DHistoryArray[1]];
        [bitArray addObject:fuCai3DHistoryArray.lastObject];
    }
    
    for (int i = 0; i < self.fuCai3DBasicArray.count; i++) {
        YD518PlanFuCai3DModel *luckListItemModel = [YD518PlanFuCai3DModel new];
        
        int luckNumber = [self.fuCai3DBasicArray[i] intValue];
        for (int j = 0; j < hundredthArray.count; j++) {
            int luckHundredNumber = [hundredthArray[j] intValue];
            if (luckNumber == luckHundredNumber) {
                luckListItemModel.hundredth++;
            }
        }
        
        for (int j = 0; j < tenhArray.count; j++) {
            int luckHundredNumber = [tenhArray[j] intValue];
            if (luckNumber == luckHundredNumber) {
                luckListItemModel.tenh++;
            }
        }
        
        for (int j = 0; j < bitArray.count; j++) {
            int luckHundredNumber = [bitArray[j] intValue];
            if (luckNumber == luckHundredNumber) {
                luckListItemModel.bit++;
            }
        }
        NSLog(@"%f=%f=%f",luckListItemModel.hundredth, luckListItemModel.tenh, luckListItemModel.bit);
        [self.fuCai3DArray addObject:luckListItemModel];
    }
    [self calculateTheProbabilityOfLuckyNumbers];
}

/// 总概率计算方法
- (void)calculateTheProbabilityOfLuckyNumbers {
    /// 最终的最小概率的模型
    YD518PlanFuCai3DProbabilityModel *minProbabilityModel = [YD518PlanFuCai3DProbabilityModel new];
    
    NSNumber *numberCount = [NSNumber numberWithInteger:self.fuCai3DData.count];
    double doubleCount = [numberCount doubleValue];
    
    for (int i = 0; i < self.fuCai3DArray.count; i++) {
        YD518PlanFuCai3DModel *fiveModel = self.fuCai3DArray[i];
        double fiveProbability = fiveModel.hundredth / doubleCount;
        for (int j = 0; j < self.fuCai3DArray.count; j++) {
            YD518PlanFuCai3DModel *oneModel = self.fuCai3DArray[j];
            double oneProbability = oneModel.tenh / doubleCount;
            for (int k = 0; k < self.fuCai3DArray.count; k++) {
                YD518PlanFuCai3DModel *eightModel = self.fuCai3DArray[k];
                double eightProbability = eightModel.bit / doubleCount;
                
                /// 生成全部概率数据
                YD518PlanFuCai3DProbabilityModel *probabilityModel = [YD518PlanFuCai3DProbabilityModel new];
                probabilityModel.resultContent = [NSString stringWithFormat:@"%d, %d, %d",i, j, k];
                probabilityModel.probabilityResult = fiveProbability * oneProbability * eightProbability;
                
                if (minProbabilityModel.probabilityResult == 0 || (minProbabilityModel.probabilityResult > probabilityModel.probabilityResult)) {
                    minProbabilityModel = probabilityModel;
                }
//                NSLog(@"最小结果：%@, 最小概率%f",probabilityModel.resultContent, probabilityModel.probabilityResult);
                [self.fuCai3DProbabilityArray addObject:probabilityModel];
            }
        }
    }
//    NSLog(@"最小结果：%@, 最小概率%f",minProbabilityModel.resultContent, minProbabilityModel.probabilityResult);
    [self generateAllProbabilityData];
}

/// 数据从小到大进行排序
- (void)generateAllProbabilityData {
    
    NSMutableArray *array = self.fuCai3DProbabilityArray;
    
    for (int i = 0; i < array.count - 1; i++) {
        // n-1-i 表示每轮对应交换完后的数字不用再比了
        for (int j = 0; j < array.count - 1 - i; j++) {
            YD518PlanFuCai3DProbabilityModel *probabilityModel1 = array[j];
            YD518PlanFuCai3DProbabilityModel *probabilityModel2 = array[j + 1];
            if (probabilityModel1.probabilityResult > probabilityModel2.probabilityResult) { // 从大到小      >是从小到大
                [array exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
            }
        }
    }
    
    for (int i = 0; i < array.count; i++) {
        YD518PlanFuCai3DProbabilityModel *probabilityModel = array[i];
        NSLog(@"最小结果：%@, 最小概率%f, 当前出现的位置：%d", probabilityModel.resultContent, probabilityModel.probabilityResult, i);
    }
}

/// 福彩3D的基础数据
- (NSArray *)fuCai3DBasicArray {
    if (_fuCai3DBasicArray == nil) {
        _fuCai3DBasicArray = [NSArray arrayWithObjects:@0, @1, @2, @3, @4, @5, @6, @7, @8, @9, nil];
    }
    return _fuCai3DBasicArray;
}

/// 福彩3D的原始数据
- (NSArray *)fuCai3DData {
    if (_fuCai3DData == nil) {
        _fuCai3DData = [NSMutableArray array];
    }
    return _fuCai3DData;
}

/// 福彩3D的模型数据
- (NSMutableArray *)fuCai3DArray {
    if (_fuCai3DArray == nil) {
        _fuCai3DArray = [NSMutableArray array];
    }
    return _fuCai3DArray;
}

/// 福彩3D的全部可能数据 和 每个可能数据的概率
- (NSMutableArray *)fuCai3DProbabilityArray {
    if (_fuCai3DProbabilityArray == nil) {
        _fuCai3DProbabilityArray = [NSMutableArray array];
    }
    return _fuCai3DProbabilityArray;
}

@end
