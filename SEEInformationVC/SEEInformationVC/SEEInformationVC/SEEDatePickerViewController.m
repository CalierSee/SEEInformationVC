//
//  SEEDatePickerViewController.m
//  SEEInformationView
//
//  Created by 景彦铭 on 2017/6/5.
//  Copyright © 2017年 景彦铭. All rights reserved.
//

#import "SEEDatePickerViewController.h"


static NSString * SEEDatePickerViewDismissNotification = @"SEEDatePickerViewDismissNotification";

@interface SEEDatePickerViewPresentationController : UIPresentationController

@end

@interface SEEDatePickerViewTransitioning: NSObject <UIViewControllerTransitioningDelegate>

@end


@interface SEEDatePickerViewController ()

@property(nonatomic,strong)UIDatePicker * datePicker;

@property(nonatomic,weak)id <SEEDatePickerViewControllerDelegate> delegate;

@property(nonatomic,strong)SEEDatePickerViewTransitioning * transition;

@property(nonatomic,strong)NSMutableDictionary * info;

@property(nonatomic,strong)UIView * titleView;

@property (nonatomic,strong)NSDate * date;

@property (nonatomic,assign)UIDatePickerMode mode;

@property (nonatomic,assign)BOOL isSupportFailure;

@property (nonatomic,assign)BOOL isSupportPass;

@end

@implementation SEEDatePickerViewController

- (instancetype)initWithTimeInteval:(NSTimeInterval)time mode:(UIDatePickerMode)mode isSupportFailure:(BOOL)isSupportFailure  isSupportPass:(BOOL)isSupportPass delegate:(nonnull id<SEEDatePickerViewControllerDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        self.mode = mode;
        self.isSupportFailure = isSupportFailure;
        self.isSupportPass = isSupportPass;
        self.info = [NSMutableDictionary dictionary];
        self.date = [NSDate dateWithTimeIntervalSince1970:time];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        _transition = [[SEEDatePickerViewTransitioning alloc]init];
        self.transitioningDelegate = _transition;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelButtonClick) name:SEEDatePickerViewDismissNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.datePicker];
    [self.view addSubview:self.titleView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.datePicker setDate:self.date animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SEEDatePickerViewDismissNotification object:nil];
}

#pragma mark - public method
- (void)selectTimeWithTimeInterval:(NSTimeInterval)timeInterval {
    self.date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    [self.datePicker setDate:self.date animated:YES];
}


#pragma mark - Action
- (void)see_dateChange:(UIDatePicker *)sender {
    NSDate * date = sender.date;
    self.date = date;
}

- (void)cancelButtonClick {
    if ([_delegate respondsToSelector:@selector(datePickerViewControllerDidCancel:)]) {
        [_delegate datePickerViewControllerDidCancel:self];
    }
}

- (void)okButtonClick {
    if ([_delegate respondsToSelector:@selector(datePickerViewController:didPickeInfo:)]) {
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        switch (self.datePicker.datePickerMode) {
            case UIDatePickerModeDate:
                formatter.dateFormat = @"YYYY年MM月dd日";
                break;
            case UIDatePickerModeTime:
                formatter.dateFormat = @"HH:mm:ss";
                break;
            case UIDatePickerModeDateAndTime:
                formatter.dateFormat = @"YYYY年MM月dd日 HH:mm:ss";
                break;
            default:
                break;
        }
        NSTimeInterval timeInterval = self.date.timeIntervalSince1970;
        NSString * timeString = [formatter stringFromDate:self.date];
        [self.info setObject:@(timeInterval) forKey:SEEDatePickerViewControllerTimeIntervalSince1970Key];
        [self.info setObject:timeString forKey:SEEDatePickerViewControllerDataStringKey];
        [_delegate datePickerViewController:self didPickeInfo:self.info.copy];
    }
}

#pragma mark - getter & setter

- (UIView *)titleView {
    if (_titleView == nil) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, titleViewHeight)];
        _titleView.backgroundColor = [UIColor whiteColor];
        //创建确定取消按钮
        //=============  取消按钮  =============//
        UIButton * okButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2, 0, [UIScreen mainScreen].bounds.size.width / 2, 40)];
        [okButton setTitle:@"确定" forState:UIControlStateNormal];
        [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [okButton setBackgroundColor:[UIColor colorWithRed:1 green:72 / 255.0 blue:0 alpha:1]];
        okButton.layer.borderColor = [UIColor colorWithRed:199 /255.0 green:199 /255.0 blue:199 /255.0 alpha:1].CGColor;
        okButton.layer.borderWidth = 1;
        [okButton addTarget:self action:@selector(okButtonClick) forControlEvents:UIControlEventTouchUpInside];
        okButton.tag = SEEDatePickerViewPickTypeOK;
        _okButton = okButton;
        
        UIButton * cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 2, 40)];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1] forState:UIControlStateNormal];
        [cancelButton setBackgroundColor:[UIColor whiteColor]];
        cancelButton.layer.borderColor = [UIColor colorWithRed:199 /255.0 green:199 /255.0 blue:199 /255.0 alpha:1].CGColor;
        cancelButton.layer.borderWidth = 1;
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.tag = SEEDatePickerViewPickTypeCancel;
        _cancelButton = cancelButton;
        [_titleView addSubview:_cancelButton];
        [_titleView addSubview:_okButton];
    }
    return _titleView;
}

- (UIDatePicker *)datePicker {
    if (_datePicker == nil) {
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, datePickerViewControllerHeight)];
        _datePicker.datePickerMode = self.mode;
        if (!self.isSupportFailure) {
            _datePicker.maximumDate = [NSDate date];
        }
        if (!self.isSupportPass) {
            _datePicker.minimumDate = [NSDate date];
        }
        [_datePicker addTarget:self action:@selector(see_dateChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

@end

#pragma mark - SEEPickerViewTransitioning implementation

@implementation SEEDatePickerViewTransitioning

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[SEEDatePickerViewPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
}

@end

#pragma mark - SEEPickerViewPresentationController

@implementation SEEDatePickerViewPresentationController

- (CGRect)frameOfPresentedViewInContainerView {
    return CGRectMake(0, [UIScreen mainScreen].bounds.size.height - datePickerViewControllerHeight, [UIScreen mainScreen].bounds.size.width, datePickerViewControllerHeight);
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
    [[NSNotificationCenter defaultCenter]postNotificationName:SEEDatePickerViewDismissNotification object:nil];
}

@end
