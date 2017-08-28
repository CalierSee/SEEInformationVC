//
//  SEEInformationBaseCell.h
//  SEEInformationView
//
//  Created by 景彦铭 on 2017/6/3.
//  Copyright © 2017年 景彦铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEEInformationVC.h"
#import "NSObject+information.h"

@class SEEInformationDtlModel;
@class SEEInformationBaseCell;

typedef struct responder{
    BOOL didChangeValue;
    BOOL needShowSelectView;
    BOOL deleteImage;
}Responder;

@protocol SEEInformationBaseCellDelegate <NSObject>
//配置cell
- (void)cell:(SEEInformationBaseCell *)cell didChangeValue:(id)value atIndexPath:(NSIndexPath *)indexPath;
//选择cell需要弹出选择窗口
- (void)selectCell:(SEEInformationBaseCell *)cell needShowSelectViewWithType:(SEEInformationShowType)type indexPath:(NSIndexPath *)indexPath;

- (void)imageCell:(SEEInformationBaseCell *)cell needDeleteImageAtIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath;

@end

@interface SEEInformationBaseCell : UITableViewCell

@property (nonatomic,assign)BOOL edit;

//代理
@property(nonatomic,weak,readonly)id <SEEInformationBaseCellDelegate> delegate;
@property (nonatomic,assign)Responder responder;

//当前cell的indexPath
@property(nonatomic,strong,readonly)NSIndexPath * indexPath;

@property (nonatomic,assign,readonly)SEEInformationShowType type;

- (void)setEdit:(BOOL)edit;

- (void)configureCellWithModel:(SEEInformationDtlModel *)model info:(NSDictionary *)info delegate:(id<SEEInformationBaseCellDelegate>)delegate indexPath:(NSIndexPath *)indexPath;

@end
