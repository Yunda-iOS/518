//
//  NXBaseModel.h
//  NCube
//
//  Created by kepuna on 2016/11/26.
//  Copyright © 2016年 junjie.liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NXBaseModel : NSObject


/**
 返回码
 */
@property (nonatomic, copy) NSString *error_code;

/**
 返回说明
 */
@property (nonatomic, copy) NSString *reason;

/**
 返回结果集
 */
@property (nonatomic, strong) NSObject *result;

@end
