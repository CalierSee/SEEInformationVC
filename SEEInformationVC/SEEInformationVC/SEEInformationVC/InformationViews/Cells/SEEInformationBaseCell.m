//
//  SEEInformationBaseCell.m
//  SEEInformationView
//
//  Created by 景彦铭 on 2017/6/3.
//  Copyright © 2017年 景彦铭. All rights reserved.
//

#import "SEEInformationBaseCell.h"
#import "SEEInformationVC.h"
@interface SEEInformationBaseCell ()

@property (weak, nonatomic) IBOutlet UIImageView *mustLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic,weak)id delegate;

@property(nonatomic,strong)NSIndexPath * indexPath;

@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@property (nonatomic,assign)SEEInformationShowType type;

@end

@implementation SEEInformationBaseCell {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)configureCellWithModel:(SEEInformationDtlModel *)model info:(NSDictionary *)info delegate:(id<SEEInformationBaseCellDelegate>)delegate indexPath:(NSIndexPath *)indexPath {
    self.mustLabel.hidden = !model.isMust;
    self.titleLabel.text = model.title;
    self.delegate = delegate;
    self.indexPath = indexPath;
    self.unitLabel.text = model.unit;
    self.type = model.showType;
}

- (void)setEdit:(BOOL)edit {
    _edit = edit;
    self.contentView.userInteractionEnabled = edit;
}


#pragma mark - getter & setter
- (void)setDelegate:(id)delegate {
    _delegate = delegate;
    if (delegate == nil) {
        return;
    }
    _responder.didChangeValue = [_delegate respondsToSelector:@selector(cell:didChangeValue:atIndexPath:)];
    _responder.needShowSelectView = [_delegate respondsToSelector:@selector(selectCell:needShowSelectViewWithType:indexPath:)];
    _responder.deleteImage = [_delegate respondsToSelector:@selector(imageCell:needDeleteImageAtIndex:indexPath:)];
}
@end
