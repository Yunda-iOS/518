//
//  NXBaseObject.m
//  NCube
//
//  Created by kepuna on 2017/1/4.
//  Copyright © 2017年 junjie.liu. All rights reserved.
//

#import "NXBaseObject.h"
#import "NSObject+YYModel.h"

@implementation NXBaseObject

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [self modelEncodeWithCoder:aCoder];
}

- (id)copyWithZone:(NSZone *)zone{
    return [self modelCopy];
}

- (NSUInteger)hash{
    return [self modelHash];
}

- (BOOL)isEqual:(id)object{
    return [self modelIsEqual:object];
}

@end
