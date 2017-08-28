//
//  SEECustomViewCell.m
//  SEEInformationView
//
//  Created by 景彦铭 on 2017/6/5.
//  Copyright © 2017年 景彦铭. All rights reserved.
//

#import "SEECustomViewCell.h"

@interface SEECustomViewCell ()

@property (weak, nonatomic) IBOutlet UIView *customView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *customViewHeightLayout;

@end

@implementation SEECustomViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)configureCellWithView:(UIView *)view height:(CGFloat)height {
    if (height != 0) {
        self.customViewHeightLayout.constant = height;
        [self.customView addSubview:view];
        [self layoutIfNeeded];
    }
}

@end
