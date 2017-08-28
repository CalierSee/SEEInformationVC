//
//  NSObject+information.h
//  SEEInformationView
//
//  Created by 景彦铭 on 2017/6/3.
//  Copyright © 2017年 景彦铭. All rights reserved.
//

#import <Foundation/Foundation.h>

#define isNull(obj) [NSObject isNull:obj]

#define convertToString(obj) [NSObject convertToString:obj]

#define convertToNumber(obj) [NSObject convertToNumber:obj]

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (information)

+(BOOL)isNull:(id)object;

- (NSString *)convertToString;

- (NSNumber *)convertToNumber;

+ (NSString *)convertToString:(id)obj;

+ (NSNumber *)convertToNumber:(id)obj;

@end

NS_ASSUME_NONNULL_END
