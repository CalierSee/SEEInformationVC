//
//  SEEInformationHeaderView.h
//  SEEInformationView
//
//  Created by 景彦铭 on 2017/6/3.
//  Copyright © 2017年 景彦铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SEEInformationHeaderView : UIView

- (void)configureWithTitle:(NSString *)title;

@property (weak, nonatomic,readonly) IBOutlet UIView *leadView;

@property (weak, nonatomic,readonly) IBOutlet UILabel *titleLabel;

@end
