//
//  SEEInformationVC.h
//  SEEInformationView
//
//  Created by 景彦铭 on 2017/5/31.
//  Copyright © 2017年 景彦铭. All rights reserved.
//  数据填写表格视图
//  默认提供单行文本、多行文本、单选、多选四种视图，支持自定义，自定义视图配置文件中showType为SEEInformationShowTypeCustomView

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SEEInformationVC;

@protocol SEEInformationVCDataSource <NSObject>
//返回自定义cell中接收的用户数据
- (id)informationViewController:(SEEInformationVC *)vc valueAtIndexPath:(NSIndexPath *)indexPath;
//返回自定义cell的视图
- (UIView *)informationViewController:(SEEInformationVC *)vc customCellAtIndexPath:(NSIndexPath *)indexPath;
//返回自定义cell视图的高度
- (CGFloat)informationViewController:(SEEInformationVC *)vc heightAtIndexPath:(NSIndexPath *)indexPath;
//控制器向自定义cell中写入数据
- (void)informationViewController:(SEEInformationVC *)vc postValue:(id)value indexPath:(NSIndexPath *)indexPath;

@end

typedef struct {
    int valueAtIndexPath;
    int cellAtIndexPath;
    int heightAtIndexPath;
    int postValueAtIndexPtah;
}InformationVCResponder;


//数据填写方式
typedef NS_ENUM(NSUInteger, SEEInformationShowType) {
    SEEInformationShowTypeTextField = 0 , //单行文本
    SEEInformationShowTypeSelectView = 1 ,  //单选
    SEEInformationShowTypeMutableSelectView = 2 ,  //多选
    SEEInformationShowTypeAddress = 5 ,  //选择地区
    SEEInformationShowTypeTextView = 4 ,  //多行文本
    SEEInformationShowTypeDate = 8 ,  //日期选择
    SEEInformationShowTypeTime = 7 ,  //时间选择
    SEEInformationShowTypeDateAndTime = 9 , //日期和时间选择
    SEEInformationShowTypeImage = 6 ,  //选择图片
    SEEInformationShowTypeCustomView = 10 , //自定义视图
};

typedef NS_ENUM(NSUInteger, SEEInformationKeyboardType) {
    SEEInformationKeyboardTypeDefault, //全键盘
    SEEInformationKeyboardTypeNumberPad,  //数字键盘
};

@class SEEInformationDtlModel;

#pragma mark - informationModel
@interface SEEInformationModel : NSObject
//组名
@property (nonatomic,copy) NSString *title;
//该组包含的项目
@property(nonatomic,strong)NSArray <SEEInformationDtlModel *> * dtlList;

@end


#pragma mark - informationDtlModel
@interface SEEInformationDtlModel : NSObject
//请求json key值
@property (nonatomic,copy) NSString *property;
//显示类型  显示类型对应需要设置的参数如下
@property(nonatomic,assign) SEEInformationShowType showType;

/*
 全部类型
 */
//名称
@property (nonatomic,copy) NSString *title;
//单位
@property (nonatomic,copy) NSString *unit;
//是否必须输入
@property(nonatomic,assign)BOOL isMust;
//placeHolder
@property (nonatomic,copy) NSString *placeHolder;

/*
 SEEInformationShowTypeSelectView & SEEInformationShowTypeMutableSelectView
 */
//当显示类型为选择时选项的中文标题
@property (nonatomic,strong) NSArray <NSString *> *valueStrings;
//当显示类型为选择时选项的中文标题对应的值
@property(nonatomic,strong)NSArray <id> * values;
//选中某一个value时对应要展示的子项目
@property(nonatomic,strong)NSArray <NSString *> * subItems;
/*
 SEEInformationShowTypeTextField & SEEInformationShowTypeTextView
 */
//当输入文本时弹出的键盘类型
@property(nonatomic,assign) SEEInformationKeyboardType keyboardType;

//SEEInformationShowTypeTextField
//需要检查的正则表达式
@property (nonatomic,copy) NSString *regularString;

/* 是否支持选择未来的日期
SEEInformationShowTypeDate,  //日期选择
SEEInformationShowTypeTime,  //时间选择
SEEInformationShowTypeDateAndTime, //日期和时间选择
*/
@property (nonatomic,assign)BOOL isSupportFuture;
@property (nonatomic,assign)BOOL isSupportPass;

/*图片选择
 SEEInformationShowTypeImage
 */
//允许选择的最大图片数量
@property (nonatomic,assign)NSInteger maxCount;

@end








#pragma mark - informationVC

static NSString * const SEEInformationViewControllerCollectValueNotification = @"SEEInformationViewControllerCollectValueNotification";
// 控制器更新数值
#define SEEInformationViewControllerCollectValue [[NSNotificationCenter defaultCenter]postNotificationName:SEEInformationViewControllerCollectValueNotification object:nil]

@protocol SEEInformationBaseCellDelegate,SEEPickerViewControllerDelegate,SEEPickerViewControllerDataSource,SEEMutableSelectViewControllerDelegate,SEEDatePickerViewControllerDelegate,SEEAddressPickerViewControllerDelegate;

@interface SEEInformationVC : UIViewController <UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,SEEInformationBaseCellDelegate,SEEPickerViewControllerDelegate,SEEPickerViewControllerDataSource,SEEMutableSelectViewControllerDelegate,SEEDatePickerViewControllerDelegate,SEEAddressPickerViewControllerDelegate>
@property(nonatomic,strong,readonly)UITableView * tableView;

//弹出选择框的选择视图所在的indexPath
@property(nonatomic,strong,readonly)NSIndexPath * currentSelectIndexPath;

//数据字典
@property(nonatomic,strong,readonly)NSMutableDictionary * info;

@property(nonatomic,weak)id <SEEInformationVCDataSource> dataSource;
@property (nonatomic,assign)InformationVCResponder responder;

//列表项
@property(nonatomic,strong,readonly)NSArray <SEEInformationModel *> * informations;

//初始化
- (instancetype)init;
- (instancetype)initWithInformations:(nullable NSArray <SEEInformationModel *> *)informations info:(nullable NSDictionary *)info isEdit:(BOOL)flag NS_DESIGNATED_INITIALIZER;

//配置
- (void)configureInformations:(NSArray <SEEInformationModel *> *)informations;
- (void)configureInfo:(NSDictionary *)info;
- (void)configureIsEdit:(BOOL)flag;
- (void)configureInformations:(nullable NSArray <SEEInformationModel *> *)informations info:(nullable NSDictionary *)info isEdit:(BOOL)flag;
//更新本地数据与界面一致  针对自定义视图
- (void)updateInfo;
//是否为编辑模式
@property (nonatomic,assign,readonly)BOOL isEdit;



- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;


@end









NS_ASSUME_NONNULL_END
