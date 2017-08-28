//
//  SEEMutableSelectViewController.h
//  SEEInformationView
//
//  Created by 景彦铭 on 2017/6/3.
//  Copyright © 2017年 景彦铭. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MutableSelectViewControllerHeight [UIScreen mainScreen].bounds.size.height/3

NS_ASSUME_NONNULL_BEGIN
@class SEEMutableSelectViewController;
//选中的title数组
static NSString * const SEEMutableSelectViewControllerInfoTitleKey = @"SEEMutableSelectViewControllerInfoTitleKey";
//选中的title对应的value数组
static NSString * const SEEMutableSelectViewControllerInfoValueKey = @"SEEMutableSelectViewControllerInfoValueKey";
//选中的title对应的下标数组
static NSString * const SEEMutableSelectViewControllerInfoIndexKey = @"SEEMutableSelectViewControllerInfoIndexKey";

@protocol SEEMutableSelectViewControllerDelegate <NSObject>
//取消
- (void)mutableSelectViewControllerDidCancle:(SEEMutableSelectViewController *)vc;
//选择完成
- (void)mutableSelectViewController:(SEEMutableSelectViewController *)vc didChooseInfo:(NSDictionary <NSString *, NSArray *> *)info;

@end


@interface SEEMutableSelectViewController : UIViewController

- (instancetype)initWithTitles:(NSArray <NSString *> *)titles values:(nullable NSArray <id> *)values selectedItems:(nullable NSArray <id> *)items delegate:(id <SEEMutableSelectViewControllerDelegate>)delegate;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
