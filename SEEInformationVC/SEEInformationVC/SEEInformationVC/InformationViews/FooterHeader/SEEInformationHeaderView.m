//
//  SEEInformationHeaderView.m
//  SEEInformationView
//
//  Created by 景彦铭 on 2017/6/3.
//  Copyright © 2017年 景彦铭. All rights reserved.
//

#import "SEEInformationHeaderView.h"

@interface SEEInformationHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *leadView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SEEInformationHeaderView

- (void)configureWithTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end
