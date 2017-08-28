//
//  SEEInformation.h
//  SEEInformationView
//
//  Created by 景彦铭 on 2017/6/7.
//  Copyright © 2017年 景彦铭. All rights reserved.
//

#ifndef SEEInformation_h
#define SEEInformation_h


/*
 本框架需要  IQKeyboard  YYModel 框架支持
 IQKeyboard 防止文本框被键盘遮挡
 YYModel 将json数据转为本框架中使用的模型数据 详见宏 SEEInformationModelsWithJson(jsonData)
 
 本地列表数据列表见文件 information_list.plist

 各个显示类型对应的模型可配置的参数以及info字典中返回的数据结构如下
 ====SEEInformationShowTypeTextField, //单行文本
 参数
 property  //key值
 showType = SEEInformationShowTypeTextField //显示类型
 title //标题
 unit // 单位
 isMust //是否为必填项
 placeHolder //占位字符
 keyboardType //弹出键盘的类型  注意如果输入小数弹出全键盘
 regularString //文本检查正则表达式 如果为空则对输入的数据不进行检查
 
 info返回值结构
 "property值":"textField.text"
 
 
 ====SEEInformationShowTypeTextView,  //多行文本
 property  //key值
 showType = SEEInformationShowTypeTextView //显示类型
 title //标题
 unit // 单位
 isMust //是否为必填项
 placeHolder //占位字符
 keyboardType //弹出键盘的类型
 
 info返回值结构
 "property值":"textView.text"
 
 ====SEEInformationShowTypeSelectView,  //单选
 property  //key值
 showType = SEEInformationShowTypeSelectView //显示类型
 title //标题
 unit // 单位
 isMust //是否为必填项
 placeHolder //占位字符
 valueStrings //选项的中文名称 此参数为字符串数组
 values //选项的值 此参数为任意类型值的数组
 
 info返回值结构
 "property值":"values[选中]"
 
 ====SEEInformationShowTypeMutableSelectView,  //多选
 property  //key值
 showType = SEEInformationShowTypeMutableSelectView //显示类型
 title //标题
 unit // 单位
 isMust //是否为必填项
 placeHolder //占位字符
 valueStrings //选项的中文名称 此参数为字符串数组
 values //选项的值 此参数为任意类型值的数组
 
 info返回值结构
 "property值": [
    "values[选中1]",
    "values[选中2]",
    ...
 ]
 
 ====SEEInformationShowTypeDate,  //日期选择
 ====SEEInformationShowTypeTime,  //时间选择
 ====SEEInformationShowTypeDateAndTime, //日期和时间选择
 property  //key值
 showType  //显示类型
 title //标题
 isMust //是否为必填项
 placeHolder //占位字符
 isSupportFailure //是否支持选择未来的日期 默认不支持
 
 info返回值结构
 "property值":"选中的时间对应的时间戳"
 
 ====SEEInformationShowTypeAddress,  //选择地区
 property  //key值
 showType = SEEInformationShowTypeAddress //显示类型
 title //标题
 isMust //是否为必填项
 placeHolder //占位字符
 
 info返回值结构
 "property值": {
"SEEAddressPickerViewControllerProviceIdKey": "省id",
"SEEAddressPickerViewControllerCityIdKey": "市id",
"SEEAddressPickerViewControllerAreaIdKey": "区id",
"SEEAddressPickerViewControllerProviceNameKey": "省名",
"SEEAddressPickerViewControllerCityNameKey": "市名",
"SEEAddressPickerViewControllerAreaNameKey": "区名",
"SEEAddressPickerViewControllerNameKey": "省市区名字全拼",
 }
 
 ====SEEInformationShowTypeImage,  //选择图片
 property  //key值
 showType = SEEInformationShowTypeImage //显示类型
 title //标题
 isMust //是否为必填项
 maxCount //图片上传支持的最大张数
 "property值": [
 "图片1",
 "图片2",
 ...
 "图片maxCount"
 ]   //注意 数据类型为UIImage
 
 
 ====SEEInformationShowTypeCustomView  //自定义视图
 property  //key值
 showType = SEEInformationShowTypeCustomView //显示类型
 
 info返回值结构
 "property值":"值"  //此处的值为数据源方法 
 - (id)informationViewController:(SEEInformationVC *)vc valueAtIndexPath:(NSIndexPath *)indexPath; 
 返回的值
 
 */

//此处宏基于YYModel框架
#define SEEInformationModelsWithJson(jsonData) [NSArray yy_modelArrayWithClass:[SEEInformationModel class] json:jsonData]

#define SEEInformationDtlModelsWithJson(jsonData) [NSArray yy_modelArrayWithClass:[SEEInformationDtlModel class] json:jsonData]

//主控制器
#import "SEEInformationVC.h"
//数据判空
#import "NSObject+information.h"
//单选控制器
#import "SEEPickerViewController.h"
//多选控制器
#import "SEEMutableSelectViewController.h"
//时间选择控制器
#import "SEEDatePickerViewController.h"
//地址选择控制器
#import "SEEAddressPickerViewController.h"

#endif /* SEEInformation_h */
