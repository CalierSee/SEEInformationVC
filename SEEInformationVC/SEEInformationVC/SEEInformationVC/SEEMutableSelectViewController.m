//
//  SEEMutableSelectViewController.m
//  SEEInformationView
//
//  Created by 景彦铭 on 2017/6/3.
//  Copyright © 2017年 景彦铭. All rights reserved.
//

#import "SEEMutableSelectViewController.h"

static NSString * const SEEMutableSelectViewControllerDismissNotification = @"SEEMutableSelectViewControllerDismissNotification";

@interface SEEInformationPresentationController : UIPresentationController

@end

@interface SEEMutableSelectViewController () <UIViewControllerTransitioningDelegate>

@property(nonatomic,strong)NSArray <NSString *> * titles;

@property(nonatomic,strong)NSArray <id> * values;

@property(nonatomic,weak)id delegate;

@property(nonatomic,strong)UIScrollView * scrollView;

@property(nonatomic,strong)NSMutableArray <NSString *> * selectedTitles;

@property(nonatomic,strong)NSMutableArray <id> * selectedValues;

@property(nonatomic,strong)NSMutableArray <NSNumber *> * selectedIndexs;

@end

@implementation SEEMutableSelectViewController


- (instancetype)initWithTitles:(NSArray<NSString *> *)titles values:(NSArray<id> *)values selectedItems:(nullable NSArray<id> *)items delegate:(nonnull id<SEEMutableSelectViewControllerDelegate>)delegate{
    if (self = [super init]) {
        self.titles = titles;
        self.values = values;
        self.delegate = delegate;
        self.selectedValues = items.mutableCopy;
        if (self.selectedValues == nil) {
            self.selectedValues = [NSMutableArray array];
        }
        self.selectedTitles = [NSMutableArray array];
        self.selectedIndexs = [NSMutableArray array];
        [self see_selected];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(see_cancelButtonClick) name:SEEMutableSelectViewControllerDismissNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self see_loadUI];
    [self see_addButton];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SEEMutableSelectViewControllerDismissNotification object:nil];
}

#pragma mark - private method

- (void)see_loadUI {
    UIButton * okButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2, 0, [UIScreen mainScreen].bounds.size.width / 2, 40)];
    [okButton setTitle:@"确定" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okButton setBackgroundColor:[UIColor colorWithRed:1 green:72 / 255.0 blue:0 alpha:1]];
    okButton.layer.borderColor = [UIColor colorWithRed:199 /255.0 green:199 /255.0 blue:199 /255.0 alpha:1].CGColor;
    okButton.layer.borderWidth = 1;
    [okButton addTarget:self action:@selector(see_doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    okButton.tag = 1;
    [self.view addSubview:okButton];
    
    UIButton * cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 2, 40)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1] forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor whiteColor]];
    cancelButton.layer.borderColor = [UIColor colorWithRed:199 /255.0 green:199 /255.0 blue:199 /255.0 alpha:1].CGColor;
    cancelButton.layer.borderWidth = 1;
    [cancelButton addTarget:self action:@selector(see_cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.tag = 0;
    [self.view addSubview:cancelButton];
}

- (void)see_addButton {
    CGFloat minumMargin = 10;
    CGFloat margin[self.titles.count];
    CGFloat buttonWidth[self.titles.count];
    CGFloat lineIndex[self.titles.count];
    CGFloat totalWidth = minumMargin;
    NSInteger index = 0;
    lineIndex[0] = 0;
    for (NSInteger i  = 0; i < self.titles.count; i++) {
        NSString * obj = self.titles[i];
        CGFloat width = [self see_widthWithString:obj] + 20;
        *(buttonWidth + i) = width;
        totalWidth += width + minumMargin;
        if (i == lineIndex[index]) {
            margin[i] = minumMargin;
        }
        else {
            margin[i] = margin[i - 1] + buttonWidth[i - 1] + minumMargin;
        }
        if (totalWidth > [UIScreen mainScreen].bounds.size.width) {
            CGFloat moreWidth = ([UIScreen mainScreen].bounds.size.width - totalWidth + (width + minumMargin)) / (i - lineIndex[index] + 1);
            for (NSInteger j  = lineIndex[index]; j < i; j++) {
                if (j == lineIndex[index]) {
                    margin[j] = minumMargin + moreWidth;
                }
                else {
                    margin[j] = margin[j - 1] + (buttonWidth[j - 1] + minumMargin + moreWidth);
                }
            }
            index ++;
            lineIndex[index] = i;
            i--;
            totalWidth = minumMargin;
        }
    }
    index = 1;
    CGFloat y = 10;
    for (NSInteger i  = 0; i < self.titles.count; i++) {
        NSString * obj = self.titles[i];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setTitle:obj forState:UIControlStateNormal];
        [button sizeToFit];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.layer.cornerRadius = 13;
        button.layer.borderColor = [UIColor colorWithRed:199 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:1].CGColor;
        [button setTitleColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundImage:[self see_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[self see_imageWithColor:[UIColor colorWithRed:1 green:72 / 255.0 blue:0 alpha:1]] forState:UIControlStateSelected];
        button.layer.borderWidth = 1;
        button.clipsToBounds = YES;
        if (i == lineIndex[index]) {
            index ++;
            y = y + 10 + 30;
        }
        button.frame = CGRectMake(margin[i], y, buttonWidth[i], 26);
        [button addTarget:self action:@selector(see_tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectedIndexs enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.integerValue == i) {
                button.selected = YES;
                *stop = YES;
            }
        }];
        [self.scrollView addSubview:button];
    }
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, y + 40);
}

- (void)see_selected {
    [self.selectedValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       [self.values enumerateObjectsUsingBlock:^(id  _Nonnull objs, NSUInteger idxs, BOOL * _Nonnull stops) {
           if ([obj isEqual:objs]) {
               [self.selectedIndexs addObject:@(idxs)];
               *stops = YES;
           }
       }];
    }];
}

- (CGFloat)see_widthWithString:(NSString *)string {
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 0;
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.paragraphSpacing = 0;
    return [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14],NSParagraphStyleAttributeName: style} context:nil].size.width;
}

- (UIImage *)see_imageWithColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, CGRectMake(0, 0, 1, 1));
    [color setFill];
    CGContextFillPath(context);
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - action method
- (void)see_doneButtonClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mutableSelectViewController:didChooseInfo:)]) {
        [self.selectedIndexs sortUsingComparator:^NSComparisonResult(NSNumber *  _Nonnull obj1, NSNumber *  _Nonnull obj2) {
            return obj1.integerValue > obj2.integerValue;
        }];
        [self.selectedTitles removeAllObjects];
        [self.selectedValues removeAllObjects];
        [self.selectedIndexs enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.selectedTitles addObject:self.titles[obj.integerValue]];
            [self.selectedValues addObject:self.values[obj.integerValue]];
        }];
        
        [self.delegate mutableSelectViewController:self didChooseInfo:@{SEEMutableSelectViewControllerInfoIndexKey: self.selectedIndexs,SEEMutableSelectViewControllerInfoTitleKey: self.selectedTitles,SEEMutableSelectViewControllerInfoValueKey: self.selectedValues}];
    }
}

- (void)see_cancelButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mutableSelectViewControllerDidCancle:)]) {
        [self.delegate mutableSelectViewControllerDidCancle:self];
    }
}

- (void)see_tagButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.selectedIndexs addObject:@(sender.tag)];
    }
    else {
        [self.selectedIndexs enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqual:@(sender.tag)]) {
                [self.selectedIndexs removeObjectAtIndex:idx];
            }
        }];
    }
}


#pragma mark - UIViewControllerTransitioningDelegate

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source {
    
    SEEInformationPresentationController * presentC = [[SEEInformationPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    return presentC;
    
}

#pragma mark - getter & setter
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, MutableSelectViewControllerHeight - 40)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

@end

@implementation SEEInformationPresentationController

- (CGRect)frameOfPresentedViewInContainerView {
    return CGRectMake(0,[UIScreen mainScreen].bounds.size.height - MutableSelectViewControllerHeight, [UIScreen mainScreen].bounds.size.width, MutableSelectViewControllerHeight);
}

- (void)presentationTransitionWillBegin {
    UIButton * bgButton = [[UIButton alloc]initWithFrame:[UIScreen mainScreen].bounds];
    bgButton.backgroundColor = [UIColor blackColor];
    bgButton.alpha = 0.3;
    [bgButton addTarget:self action:@selector(bgButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:bgButton];
}

- (void)bgButtonClick:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:SEEMutableSelectViewControllerDismissNotification object:nil];
}



@end
