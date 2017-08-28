//
//  SEEMutableSelectViewCell.m
//  SEEInformationView
//
//  Created by 景彦铭 on 2017/6/3.
//  Copyright © 2017年 景彦铭. All rights reserved.
//

#import "SEEMutableSelectViewCell.h"

@interface SEEMutableSelectViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *contentButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayout;

@end

@implementation SEEMutableSelectViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configureCellWithModel:(SEEInformationDtlModel *)model info:(NSDictionary *)info delegate:(id<SEEInformationBaseCellDelegate>)delegate indexPath:(NSIndexPath *)indexPath {
    [super configureCellWithModel:model info:info delegate:delegate indexPath:indexPath];
    [self.contentButton setTitle:model.placeHolder forState:UIControlStateNormal];
    [self.contentButton setTitleColor:[UIColor colorWithRed:199 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:1] forState:UIControlStateNormal];
    NSArray * value = [info objectForKey:model.property];
    if (![NSObject isNull:value] && value.count != 0) {
        NSMutableString * title = [NSMutableString string];
        [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [model.values enumerateObjectsUsingBlock:^(id  _Nonnull objs, NSUInteger idxs, BOOL * _Nonnull stops) {
                if ([obj isEqual:objs]) {
                    *stops = YES;
                    [title appendFormat:@" %@ |",model.valueStrings[idxs]];
                }
            }];
        }];
        [self.contentButton setTitleColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1] forState:UIControlStateNormal];
        [title deleteCharactersInRange:NSMakeRange(title.length - 1, 1)];
        [self.contentButton setTitle:title.copy forState:UIControlStateNormal];
    }
    self.contentButton.titleLabel.numberOfLines = 0;
    CGSize size = [self.contentButton.titleLabel sizeThatFits:CGSizeMake(self.contentButton.frame.size.width, MAXFLOAT)];
    if (size.height < 29) {
        size.height = 29;
        [self.contentButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    }
    else {
        [self.contentButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    self.heightLayout.constant = size.height;
}

- (IBAction)see_contentButtonClick:(UIButton *)sender {
    if (self.responder.needShowSelectView) {
        [self.delegate selectCell:self needShowSelectViewWithType:self.type indexPath:self.indexPath];
    }
}

@end
