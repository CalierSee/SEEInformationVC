//
//  SEEAddressPickerViewController.h
//  SEEInformationView
//
//  Created by 景彦铭 on 2017/6/6.
//  Copyright © 2017年 景彦铭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//=============  上半部取消确定按钮视图高度  =============//
#define titleViewHeight 80
//=============  选择视图高度  =============//
#define pickerViewControllerHeight [UIScreen mainScreen].bounds.size.height/3

#define okButtonBackgroundColor [UIColor colorWithRed:1 green:72 / 255.0 blue:0 alpha:1]
#define cancelButtonBackgroundColor  [UIColor grayColor]


/**
 确定按钮以及取消按钮
 - PickTypeCancel: 取消
 - pickTypeOK: 确定
 */
typedef NS_ENUM(NSInteger,SEEAddressPickerViewPickType) {
    SEEAddressPickerViewPickTypeCancel = 0,
    SEEAddressPickerViewPickTypeOK = 1
};


@protocol SEEAddressPickerViewControllerDelegate;


@interface SEEAddressPickerViewController : UIViewController

/**
 取消按钮
 */
@property(nonatomic,strong,readonly)UIButton * cancelButton;

/**
 确定按钮
 */
@property(nonatomic,strong,readonly)UIButton * okButton;

- (instancetype)init NS_UNAVAILABLE;

//无动画
- (instancetype)initWithDelegate:(nullable id <SEEAddressPickerViewControllerDelegate>)delegate;
- (instancetype)initWithDelegate:(id<SEEAddressPickerViewControllerDelegate>)delegate proviceId:(NSNumber *)provice cityId:(NSNumber *)city areaId:(NSNumber *)area;
- (instancetype)initWithDelegate:(id<SEEAddressPickerViewControllerDelegate>)delegate proviceName:(NSString *)provice cityName:(NSString *)city areaName:(NSString *)area;

//有动画  控制器出现后调用才有效
- (void)selectWithProviceId:(NSNumber *)provice cityId:(NSNumber *)city areaId:(NSNumber *)area animate:(BOOL)animate;
- (void)selectWithProviceName:(NSString *)provice cityName:(NSString *)city areaName:(NSString *)area animate:(BOOL)animate;


//地区id和名字的转换
+ (void)convertProviceId:(NSNumber *)provice cityId:(NSNumber *)city areaId:(NSNumber *)area complete:(void(^)(NSString * provice, NSString * city, NSString * area))complete;

+ (void)convertProviceName:(NSString *)provice cityName:(NSString *)city areaName:(NSString *)area complete:(void(^)(NSNumber * provice, NSNumber * city, NSNumber * area))complete;

@end

//省id
static NSString * const SEEAddressPickerViewControllerProviceIdKey = @"SEEAddressPickerViewControllerProviceIdKey";
//市id
static NSString * const SEEAddressPickerViewControllerCityIdKey = @"SEEAddressPickerViewControllerCityIdKey";
//区id
static NSString * const SEEAddressPickerViewControllerAreaIdKey = @"SEEAddressPickerViewControllerAreaIdKey";

//省名
static NSString * const SEEAddressPickerViewControllerProviceNameKey = @"SEEAddressPickerViewControllerProviceNameKey";
//市名
static NSString * const SEEAddressPickerViewControllerCityNameKey = @"SEEAddressPickerViewControllerCityNameKey";
//区名
static NSString * const SEEAddressPickerViewControllerAreaNameKey = @"SEEAddressPickerViewControllerAreaNameKey";

//省市区
static NSString * const SEEAddressPickerViewControllerNameKey = @"SEEAddressPickerViewControllerNameKey";


@protocol SEEAddressPickerViewControllerDelegate <NSObject>
@optional
- (void)addressPickerViewControllerDidCancel:(SEEAddressPickerViewController *)vc;

//字典key值如上
- (void)addressPickerViewController:(SEEAddressPickerViewController *)vc DidPickInfo:(NSDictionary *)info;

@end


NS_ASSUME_NONNULL_END

