//
//  SEEDatePickerViewController.h
//  SEEInformationView
//
//  Created by 景彦铭 on 2017/6/5.
//  Copyright © 2017年 景彦铭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


//=============  上半部取消确定按钮视图高度  =============//
#define titleViewHeight 80
//=============  选择视图高度  =============//
#define datePickerViewControllerHeight [UIScreen mainScreen].bounds.size.height/3


/**
 确定按钮以及取消按钮
 - PickTypeCancel: 取消
 - pickTypeOK: 确定
 */
typedef NS_ENUM(NSInteger,SEEDatePickerViewPickType) {
    SEEDatePickerViewPickTypeCancel = 0,
    SEEDatePickerViewPickTypeOK = 1
};

@class SEEDatePickerViewController;

@protocol SEEDatePickerViewControllerDelegate <NSObject>

- (void)datePickerViewControllerDidCancel:(SEEDatePickerViewController *)vc;

- (void)datePickerViewController:(SEEDatePickerViewController *)vc didPickeInfo:(NSDictionary *)info;

@end
//日期中文 yyyy年MM月dd日 HH:mm:ss
static NSString * const SEEDatePickerViewControllerDataStringKey = @"SEEDatePickerViewControllerDataStringKey";
//时间戳  1970
static NSString * const SEEDatePickerViewControllerTimeIntervalSince1970Key = @"SEEDatePickerViewControllerTimeIntervalSince1970Key";

@interface SEEDatePickerViewController : UIViewController

- (instancetype)initWithTimeInteval:(NSTimeInterval)time mode:(UIDatePickerMode)mode isSupportFailure:(BOOL)isSupportFailure isSupportPass:(BOOL)isSupportPass delegate:(id <SEEDatePickerViewControllerDelegate>)delegate;

/**
 取消按钮
 */
@property(nonatomic,strong,readonly)UIButton * cancelButton;

/**
 确定按钮
 */
@property(nonatomic,strong,readonly)UIButton * okButton;

- (instancetype)init NS_UNAVAILABLE;

- (void)selectTimeWithTimeInterval:(NSTimeInterval)timeInterval;

@end

NS_ASSUME_NONNULL_END
