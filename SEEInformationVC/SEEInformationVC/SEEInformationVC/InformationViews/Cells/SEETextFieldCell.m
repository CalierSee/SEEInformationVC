//
//  SEETextFieldCell.m
//  SEEInformationView
//
//  Created by 景彦铭 on 2017/6/3.
//  Copyright © 2017年 景彦铭. All rights reserved.
//

#import "SEETextFieldCell.h"

@interface SEETextFieldCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;


@end

@implementation SEETextFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _textField.delegate = self;
    // Initialization code
}

- (void)configureCellWithModel:(SEEInformationDtlModel *)model info:(NSDictionary *)info delegate:(id<SEEInformationBaseCellDelegate>)delegate indexPath:(NSIndexPath *)indexPath {
    [super configureCellWithModel:model info:info delegate:delegate indexPath:indexPath];
    self.textField.placeholder = model.placeHolder;
    self.textField.text = [info objectForKey:model.property];
    self.textField.keyboardType = model.keyboardType == 1 ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
}

#pragma mark - delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.responder.didChangeValue) {
        [self.delegate cell:self didChangeValue:textField.text atIndexPath:self.indexPath];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
