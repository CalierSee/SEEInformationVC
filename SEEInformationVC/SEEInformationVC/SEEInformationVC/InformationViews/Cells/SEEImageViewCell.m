//
//  SEEImageViewCell.m
//  SEEInformationView
//
//  Created by 景彦铭 on 2017/6/6.
//  Copyright © 2017年 景彦铭. All rights reserved.
//

#import "SEEImageViewCell.h"

@interface SEEImageView : UIView

- (void)configureWithImages:(NSArray <UIImage *>*)images edit:(BOOL)edit;

@property(nonatomic,strong)NSArray <UIImage *> * images;

@property(nonatomic,strong)NSCache * caches;

@property(nonatomic,strong)UIImage * deleteImage;

@property(nonatomic,strong)NSMutableArray <UIButton *> * deleteButtons;

@property (nonatomic,copy) void (^deleteBlock)(NSInteger index);

@property (nonatomic,assign)BOOL edit;

@end

@implementation SEEImageView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.caches = [[NSCache alloc]init];
    self.caches.countLimit = 6;
    self.deleteButtons = [NSMutableArray array];
}

- (void)configureWithImages:(NSArray<UIImage *> *)images edit:(BOOL)edit{
    self.edit = edit;
    self.images = images;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [self.deleteButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    CGFloat margin = ([UIScreen mainScreen].bounds.size.width - 20) / 10 / 2;
    CGFloat y = 0;
    CGFloat x = 0;
    CGFloat wh = ([UIScreen mainScreen].bounds.size.width - 20) / 10 * 3;
    
    [self.images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage * image = [self see_cutImage:obj size:CGSizeMake(wh, wh)];
        CGRect rect = CGRectMake(x + (margin + wh) * (idx % 3), y + (margin + wh) * (idx / 3), wh, wh);
        [image drawInRect:rect];
        UIButton * deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setBackgroundImage:[self see_deleteImage] forState:UIControlStateNormal];
        deleteButton.frame = CGRectMake(rect.origin.x + rect.size.width - 16, rect.origin.y - 4, 20, 20);
        [self addSubview:deleteButton];
        deleteButton.tag = idx;
        [deleteButton addTarget:self action:@selector(see_deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.deleteButtons addObject:deleteButton];
        deleteButton.hidden = !self.edit;
    }];
    
    
}

- (UIImage *)see_cutImage:(UIImage *)image size:(CGSize)size{
    if ([self.caches objectForKey:image]) {
        return [self.caches objectForKey:image];
    }
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    CGFloat scale = image.size.height / image.size.width;
    CGFloat scaleHeight = size.height;
    CGFloat scaleWidth = size.width;
    if (scale >= 1) {
        scaleHeight = scale * size.width;
    }
    else {
        scaleWidth = size.height / scale;
    }
    CGFloat x = -(scaleWidth - size.width) / 2;
    CGFloat y = -(scaleHeight - size.height) / 2;
    [image drawInRect:CGRectMake(x, y, scaleWidth,scaleHeight)];
    UIImage * result = UIGraphicsGetImageFromCurrentImageContext();
    [self.caches setObject:result forKey:image];
    UIGraphicsEndImageContext();
    return result;
}

- (UIImage *)see_deleteImage {
    if (self.deleteImage) {
        return self.deleteImage;
    }
    CGSize size = CGSizeMake(16, 16);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, size.width, size.height));
    [[UIColor redColor] setFill];
    CGContextFillPath(context);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRoundedRect(path, NULL, CGRectMake(3, size.height / 2 - 1, size.width - 6, 2), 1, 1);
    CGContextAddPath(context, path);
    CGPathRelease(path);
    [[UIColor whiteColor] setFill];
    CGContextFillPath(context);
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.deleteImage = image;
    return image;
}

- (void)see_deleteAction:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock(sender.tag);
    }
}

@end




@interface SEEImageViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayout;

@property (weak, nonatomic) IBOutlet SEEImageView *imagesView;

@property (weak, nonatomic) IBOutlet UIButton *contentButton;

@end


@implementation SEEImageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    __weak typeof(self) weakSelf = self;
    [self.imagesView setDeleteBlock:^(NSInteger index){
        if (weakSelf.responder.deleteImage) {
            [weakSelf.delegate imageCell:weakSelf needDeleteImageAtIndex:index indexPath:weakSelf.indexPath];
        }
    }];
}

- (void)configureCellWithModel:(SEEInformationDtlModel *)model info:(NSDictionary *)info delegate:(id<SEEInformationBaseCellDelegate>)delegate indexPath:(NSIndexPath *)indexPath {
    [super configureCellWithModel:model info:info delegate:delegate indexPath:indexPath];
    NSArray <UIImage *> * value = [info objectForKey:model.property];
    if (![NSObject isNull:value] && [value isKindOfClass:[NSArray class]]) {
        [self.imagesView configureWithImages:value edit:self.edit];
    }
    else {
        [self.imagesView configureWithImages:nil edit:self.edit];
    }
    CGFloat margin = ([UIScreen mainScreen].bounds.size.width - 20) / 10 / 2;
    CGFloat y = 0;
    CGFloat x = 0;
    CGFloat wh = ([UIScreen mainScreen].bounds.size.width - 20) / 10 * 3;
    if ([value isKindOfClass:[NSArray class]] && value.count == model.maxCount) {
        self.contentButton.hidden = YES;
        self.heightLayout.constant = y + (margin + wh) * ((value.count + 2) / 3);
    }
    else if ([value isKindOfClass:[NSArray class]]){
        if (self.edit) {
            self.contentButton.hidden = NO;
        }
        else {
            self.contentButton.hidden = YES;
        }
        self.contentButton.frame = CGRectMake(x + (margin + wh) * ((value.count) % 3), y + (margin + wh) * ((value.count) / 3), wh, wh);
        self.heightLayout.constant = self.contentButton.frame.size.height + self.contentButton.frame.origin.y;
    }
    else {
        self.contentButton.hidden = !self.edit;
    }
}

- (void)setEdit:(BOOL)edit {
    [super setEdit:edit];
    self.contentButton.hidden = !edit;
    
}

- (IBAction)see_contentButtonClick:(UIButton *)sender {
    if (self.responder.needShowSelectView) {
        [self.delegate selectCell:self needShowSelectViewWithType:self.type indexPath:self.indexPath];
    }
}

@end
