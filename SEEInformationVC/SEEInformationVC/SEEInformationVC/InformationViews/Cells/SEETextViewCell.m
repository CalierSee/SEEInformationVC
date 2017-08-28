//
//  SEETextViewCell.m
//  SEEInformationView
//
//  Created by 景彦铭 on 2017/6/3.
//  Copyright © 2017年 景彦铭. All rights reserved.
//

#import "SEETextViewCell.h"

@interface SEETextViewCell () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;

@end

@implementation SEETextViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.delegate = self;
    self.placeHolderLabel.hidden = NO;
}

- (void)configureCellWithModel:(SEEInformationDtlModel *)model info:(NSDictionary *)info delegate:(id<SEEInformationBaseCellDelegate>)delegate indexPath:(NSIndexPath *)indexPath {
    [super configureCellWithModel:model info:info delegate:delegate indexPath:indexPath];
    self.placeHolderLabel.text = model.placeHolder;
    self.placeHolderLabel.hidden = [NSObject isNull:[info objectForKey:model.property]] ? NO : [[info objectForKey:model.property] isEqualToString:@""] ? NO : YES;
    self.textView.text = [info objectForKey:model.property];
    CGSize size = [self.textView sizeThatFits:CGSizeMake(self.textView.bounds.size.width, MAXFLOAT)];
    if (size.height > 33) {
        self.textView.textAlignment = NSTextAlignmentLeft;
    }
    else {
        self.textView.textAlignment = NSTextAlignmentRight;
    }
    self.textView.scrollEnabled = NO;
    self.textViewHeight.constant = size.height;
    self.textView.keyboardType = model.keyboardType == 1 ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
}

#pragma mark - delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.textView.scrollEnabled = YES;
    if (self.textView.frame.size.height > 33) {
        self.textView.textAlignment = NSTextAlignmentLeft;
    }
    else {
        self.textView.textAlignment = NSTextAlignmentRight;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    self.placeHolderLabel.hidden = [NSObject isNull:textView.text] ? NO : [textView.text isEqualToString:@""] ? NO : YES;
    
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if (self.responder.didChangeValue) {
        [self.delegate cell:self didChangeValue:textView.text atIndexPath:self.indexPath];
    }
}

@end
