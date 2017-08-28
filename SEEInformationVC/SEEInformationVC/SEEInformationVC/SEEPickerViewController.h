//
//  SEEPickerViewController.h
//  demo
//
//  Created by 景彦铭 on 2017/1/14.
//  Copyright © 2017年 景彦铭. All rights reserved.
// 自定义选择器
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
typedef NS_ENUM(NSInteger,SEEPickerViewPickType) {
    SEEPickerViewPickTypeCancel = 0,
    SEEPickerViewPickTypeOK = 1
};


@protocol SEEPickerViewControllerDelegate;
@protocol SEEPickerViewControllerDataSource;


@interface SEEPickerViewController : UIViewController

/**
 取消按钮
 */
@property(nonatomic,strong,readonly)UIButton * cancelButton;

/**
 确定按钮
 */
@property(nonatomic,strong,readonly)UIButton * okButton;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithTitle:(NSString *)title dataSource:(id <SEEPickerViewControllerDataSource>)dataSource;

- (instancetype)initWithTitle:(NSString *)title delegate:(nullable id <SEEPickerViewControllerDelegate>)delegate dataSource:(id <SEEPickerViewControllerDataSource>)dataSource;

- (void)reloadData;

- (void)selectRow:(NSInteger)row forComponent:(NSInteger)component;

- (void)selectRow:(NSInteger)row forComponent:(NSInteger)component animated:(BOOL)animated;

@end


//=============  组号  =============//
static const NSString * SEEPickerViewControllerComponentKey = @"SEEPickerViewControllerComponentKey";
//=============  行号  =============//
static const NSString * SEEPickerViewControllerRowKey = @"SEEPickerViewControllerRowKey";
//=============  内容  =============//
static const NSString * SEEPickerViewControllerContentKey = @"SEEPickerViewControllerContentKey";

@protocol SEEPickerViewControllerDelegate <NSObject>
@optional
- (void)pickerViewControllerDidCancel:(SEEPickerViewController *)vc;

//字典key值如上
- (void)pickerViewController:(SEEPickerViewController *)vc DidPickInfo:(NSArray <NSDictionary *> *)info;

@end



@protocol SEEPickerViewControllerDataSource <NSObject>
@optional
- (NSInteger)numberOfComponentsInPickerViewController:(SEEPickerViewController *)vc;
@required
- (NSInteger)pickerViewController:(SEEPickerViewController *)vc numberOfRowsInComponent:(NSInteger)component;

- (NSString *)pickerViewController:(SEEPickerViewController *)vc titleForRow:(NSInteger)row forComponent:(NSInteger)component;

@end

NS_ASSUME_NONNULL_END
