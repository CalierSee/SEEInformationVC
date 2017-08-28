//
//  SEEPickerViewController.m
//  demo
//
//  Created by 景彦铭 on 2017/1/14.
//  Copyright © 2017年 景彦铭. All rights reserved.
//

#import "SEEPickerViewController.h"

static NSString * SEEPickerViewDismissNotification = @"SEEPickerViewDismissNotification";

@interface SEEPickerViewPresentationController : UIPresentationController

@end

@interface SEEPickerViewTransitioning: NSObject <UIViewControllerTransitioningDelegate>

@end

@interface SEEPickerViewController () <UIPickerViewDelegate,UIPickerViewDataSource>

/**
 选择视图
 */
@property(nonatomic,strong)UIPickerView * pickerView;

/**
 取消按钮
 */
@property(nonatomic,strong)UIButton * cancelButton;

/**
 确定按钮
 */
@property(nonatomic,strong)UIButton * okButton;

/**
 标题Label
 */
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)NSString * titleString;

/**
 顶部视图
 */
@property(nonatomic,strong)UIView * titleView;

/**
 代理  数据源
 */
@property(nonatomic,weak)id <SEEPickerViewControllerDelegate>delegate;
@property(nonatomic,weak)id <SEEPickerViewControllerDataSource> dataSource;


/**
 转场代理
 */
@property(nonatomic,strong)SEEPickerViewTransitioning * transition;

@property(nonatomic,strong)NSMutableArray <NSDictionary *> * info ;

@end

@implementation SEEPickerViewController

- (instancetype)initWithTitle:(NSString *)title dataSource:(id<SEEPickerViewControllerDataSource>)dataSource {
    return [self initWithTitle:title delegate:nil dataSource:dataSource];
}

- (instancetype)initWithTitle:(NSString *)title delegate:(id<SEEPickerViewControllerDelegate>)delegate dataSource:(id<SEEPickerViewControllerDataSource>)dataSource {
    if (self = [super init]) {
        self.titleString = title;
        self.delegate = delegate;
        self.dataSource = dataSource;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        _transition = [[SEEPickerViewTransitioning alloc]init];
        self.transitioningDelegate = _transition;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelButtonClick) name:SEEPickerViewDismissNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pickerView];
    [self.view addSubview:self.titleView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SEEPickerViewDismissNotification object:nil];
}

#pragma mark - private method

- (void)reloadData {
    [self.pickerView reloadAllComponents];
    for (NSInteger i  = 0; i < [self numberOfComponentsInPickerView:self.pickerView]; i++) {
        [self didSelectRow:0 forComponent:i];
    }
}

- (void)didSelectRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@(component),SEEPickerViewControllerComponentKey,@(row),SEEPickerViewControllerRowKey,[self pickerView:self.pickerView titleForRow:row forComponent:component],SEEPickerViewControllerContentKey, nil];
    if (self.info.count >= component + 1) {
        [self.info removeObjectAtIndex:component];
        [self.info insertObject:dict atIndex:component];
    }
    else {
        [self.info addObject:dict];
    }
}

- (void)selectRow:(NSInteger)row forComponent:(NSInteger)component {
    [self selectRow:row forComponent:component animated:NO];
}

- (void)selectRow:(NSInteger)row forComponent:(NSInteger)component animated:(BOOL)animated {
    [self didSelectRow:row forComponent:component];
    [self.pickerView selectRow:row inComponent:component animated:animated];
}

#pragma mark - Action
- (void)cancelButtonClick {
    if ([_delegate respondsToSelector:@selector(pickerViewControllerDidCancel:)]) {
        [_delegate pickerViewControllerDidCancel:self];
    }
}

- (void)okButtonClick {
    if ([_delegate respondsToSelector:@selector(pickerViewController:DidPickInfo:)]) {
        [_delegate pickerViewController:self DidPickInfo:_info];
    }
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self didSelectRow:row forComponent:component];
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if ([_dataSource respondsToSelector:@selector(numberOfComponentsInPickerViewController:)]) {
        return [_dataSource numberOfComponentsInPickerViewController:self];
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([_dataSource respondsToSelector:@selector(pickerViewController:numberOfRowsInComponent:)]) {
        return [_dataSource pickerViewController:self numberOfRowsInComponent:component];
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([_dataSource respondsToSelector:@selector(pickerViewController:titleForRow:forComponent:)]) {
        return [_dataSource pickerViewController:self titleForRow:row forComponent:component];
    }
    return @"";
}

#pragma mark - getter & setter

- (UIView *)titleView {
    if (_titleView == nil) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, titleViewHeight)];
        _titleView.backgroundColor = [UIColor whiteColor];
        //创建确定取消按钮以及标题Label
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = _titleString;
        _titleLabel.textColor = [UIColor colorWithRed:199 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [_titleLabel sizeToFit];
        _titleLabel.frame = CGRectMake((_titleView.frame.size.width - _titleLabel.frame.size.width) / 2, (_titleView.frame.size.height - _titleLabel.frame.size.height) / 2, _titleLabel.frame.size.width, _titleLabel.frame.size.height);
        //=============  取消按钮  =============//
        _cancelButton = [[UIButton alloc]init];
        [_cancelButton setTitle:@"  取消  " forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelButton sizeToFit];
        _cancelButton.layer.cornerRadius = _cancelButton.frame.size.height / 2;
        _cancelButton.tag = SEEPickerViewPickTypeCancel;
        _cancelButton.frame = CGRectMake(_cancelButton.frame.origin.x, _cancelButton.frame.origin.y, _cancelButton.frame.size.width + 20, _cancelButton.frame.size.height);
        _cancelButton.frame = CGRectMake(_titleLabel.frame.origin.x - _cancelButton.frame.size.width - 50, (_titleView.frame.size.height - _cancelButton.frame.size.height) / 2, _cancelButton.frame.size.width, _cancelButton.frame.size.height);
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        //=============  确定按钮  =============//
        _okButton = [[UIButton alloc]init];
        [_okButton setTitle:@"  确定  " forState:UIControlStateNormal];
        _okButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_okButton sizeToFit];
        _okButton.layer.cornerRadius = _okButton.frame.size.height / 2;
        _okButton.tag = SEEPickerViewPickTypeOK;
        _okButton.frame = CGRectMake(_okButton.frame.origin.x, _okButton.frame.origin.y, _okButton.frame.size.width + 20, _okButton.frame.size.height);
        _okButton.frame = CGRectMake(_titleLabel.frame.origin.x + _titleLabel.frame.size.width + 50, _cancelButton.frame.origin.y, _okButton.frame.size.width, _okButton.frame.size.height);
        [_okButton addTarget:self action:@selector(okButtonClick) forControlEvents:UIControlEventTouchUpInside];
        //=============  添加  =============//
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _okButton.backgroundColor = okButtonBackgroundColor;
        _cancelButton.backgroundColor = cancelButtonBackgroundColor;
        [_titleView addSubview:_titleLabel];
        [_titleView addSubview:_cancelButton];
        [_titleView addSubview:_okButton];
    }
    return _titleView;
}

- (UIPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, pickerViewControllerHeight)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

- (NSMutableArray<NSDictionary *> *)info {
    if (_info == nil) {
        _info = [NSMutableArray array];
    }
    return _info;
}

@end

#pragma mark - SEEPickerViewTransitioning implementation

@implementation SEEPickerViewTransitioning

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[SEEPickerViewPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
}

@end

#pragma mark - 

@implementation SEEPickerViewPresentationController

- (CGRect)frameOfPresentedViewInContainerView {
    return CGRectMake(0, [UIScreen mainScreen].bounds.size.height - pickerViewControllerHeight, [UIScreen mainScreen].bounds.size
                      .width, pickerViewControllerHeight);
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
    [[NSNotificationCenter defaultCenter]postNotificationName:SEEPickerViewDismissNotification object:nil];
}

@end
