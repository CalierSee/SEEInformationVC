//
//  NSObject+information.m
//  SEEInformationView
//
//  Created by 景彦铭 on 2017/6/3.
//  Copyright © 2017年 景彦铭. All rights reserved.
//

#import "NSObject+information.h"

@implementation NSObject (information)

+(BOOL)isNull:(id)object
{
    // 判断是否为空串
    if ([object isEqual:[NSNull null]]) {
        return YES;
    }
    //判断是否为NSNull对象
    else if ([object isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    //如果是数组  判断是否元素为0
    else if ([object isKindOfClass:[NSArray class]]) {
        return !((NSArray *)object).count;
    }
    //如果是字典  判断是否键值对为0
    else if ([object isKindOfClass:[NSDictionary class]]) {
        return !((NSDictionary *)object).count;
    }
    //如果是字符串 判断字符数是否为0
    else if ([object isKindOfClass:[NSString class]]) {
        return !((NSString *)object).length;
    }
    //判断是否为nil
    else if (object==nil){
        return YES;
    }
    return NO;
}

- (NSNumber *)convertToNumber {
    if ([NSObject isNull:self]) {
        return @(MAXFLOAT);
    }
    if ([self isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)self;
    }
    else if ([self isKindOfClass:[NSString class]]){
        return @(((NSString *)self).doubleValue);
    }
    return @(MAXFLOAT);
}

- (NSString *)convertToString {
    if ([NSObject isNull:self]) {
        return @"";
    }
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    }
    else if ([self isKindOfClass:[NSNumber class]]) {
        return ((NSNumber *)self).description;
    }
    return @"";
}

+ (NSString *)convertToString:(id)obj {
    if ([self isNull:obj]) {
        return @"";
    }
    return [obj convertToString];
}

+ (NSNumber *)convertToNumber:(id)obj {
    if ([self isNull:obj]) {
        return @(MAXFLOAT);
    }
    return [obj convertToNumber];
}

@end
