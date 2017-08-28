//
//  SEEInformationVCDataFormatter.h
//  SEEInformationView
//
//  Created by 景彦铭 on 2017/6/7.
//  Copyright © 2017年 景彦铭. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SEEInformationVCDataFormatter;

@protocol SEEInformationVCDataFormatterDataSource <NSObject>

- (void)formatter:(SEEInformationVCDataFormatter *)formatter needTitleForSection:(NSInteger)section;

@end

@interface SEEInformationVCDataFormatter : NSObject



@end
