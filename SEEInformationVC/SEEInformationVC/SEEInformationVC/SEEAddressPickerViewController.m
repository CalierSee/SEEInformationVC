//
//  SEEAddressPickerViewController.m
//  SEEInformationView
//
//  Created by 景彦铭 on 2017/6/6.
//  Copyright © 2017年 景彦铭. All rights reserved.
//


#import "SEEAddressPickerViewController.h"


@interface SEEAddressModel : NSObject
//id
@property(nonatomic,strong)NSNumber * Id;
//子地区
@property(nonatomic,strong)NSArray <SEEAddressModel *> * subAreas;
//名称
@property (nonatomic,copy) NSString *title;
//电话区号
@property (nonatomic,copy) NSString *telCode;

@end

@implementation SEEAddressModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end



static NSString * SEEAddressPickerViewDismissNotification = @"SEEAddressPickerViewDismissNotification";

@interface SEEAddressPickerViewPresentationController : UIPresentationController

@end

@interface SEEAddressPickerViewTransitioning: NSObject <UIViewControllerTransitioningDelegate>

@end

@interface SEEAddressPickerViewController () <UIPickerViewDelegate,UIPickerViewDataSource>

/**
 选择视图
 */
@property(nonatomic,strong)UIPickerView * addressPickerView;

/**
 取消按钮
 */
@property(nonatomic,strong)UIButton * cancelButton;

/**
 确定按钮
 */
@property(nonatomic,strong)UIButton * okButton;

/**
 顶部视图
 */
@property(nonatomic,strong)UIView * titleView;

/**
 代理
 */
@property(nonatomic,weak)id <SEEAddressPickerViewControllerDelegate>delegate;


/**
 转场代理
 */
@property(nonatomic,strong)SEEAddressPickerViewTransitioning * transition;

@property(nonatomic,strong)NSMutableArray <NSNumber *> * info ;

@property(nonatomic,strong)NSArray <SEEAddressModel *> * addressList;

@end

@implementation SEEAddressPickerViewController

- (instancetype)initWithDelegate:(id<SEEAddressPickerViewControllerDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)initWithDelegate:(id<SEEAddressPickerViewControllerDelegate>)delegate proviceId:(NSNumber *)provice cityId:(NSNumber *)city areaId:(NSNumber *)area {
    if (self = [super init]) {
        self.delegate = delegate;
        [self see_queryWithProviceId:provice cityId:city areaId:area];
    }
    return self;
}

- (instancetype)initWithDelegate:(id<SEEAddressPickerViewControllerDelegate>)delegate proviceName:(NSString *)provice cityName:(NSString *)city areaName:(NSString *)area {
    if (self = [super init]) {
        self.delegate = delegate;
        [self see_queryWithProviceName:provice cityName:city areaName:area];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        _transition = [[SEEAddressPickerViewTransitioning alloc]init];
        self.transitioningDelegate = _transition;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelButtonClick) name:SEEAddressPickerViewDismissNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.addressPickerView];
    [self.view addSubview:self.titleView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self see_selectWithAnimate:NO];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SEEAddressPickerViewDismissNotification object:nil];
}

#pragma mark - public method 
- (void)selectWithProviceId:(NSNumber *)provice cityId:(NSNumber *)city areaId:(NSNumber *)area animate:(BOOL)animate {
    [self see_queryWithProviceId:provice cityId:city areaId:area];
    [self see_selectWithAnimate:animate];
}

- (void)selectWithProviceName:(NSString *)provice cityName:(NSString *)city areaName:(NSString *)area animate:(BOOL)animate {
    [self see_queryWithProviceName:provice cityName:city areaName:area];
    [self see_selectWithAnimate:animate];
}

+ (void)convertProviceId:(NSNumber *)provice cityId:(NSNumber *)city areaId:(NSNumber *)area complete:(void (^)(NSString * _Nonnull, NSString * _Nonnull, NSString * _Nonnull))complete {
    __block NSString * pName = @"";
    __block NSString * cName = @"";
    __block NSString * aName = @"";
    NSArray * array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"]];
    NSArray <SEEAddressModel *> * addressList = [SEEAddressPickerViewController see_convertAreaWithjson:array];
    [addressList enumerateObjectsUsingBlock:^(SEEAddressModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.Id.integerValue == provice.integerValue) {
            *stop = YES;
            pName = obj.title;
            [obj.subAreas enumerateObjectsUsingBlock:^(SEEAddressModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.Id.integerValue == city.integerValue) {
                    *stop = YES;
                    cName = obj.title;
                    [obj.subAreas enumerateObjectsUsingBlock:^(SEEAddressModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj.Id.integerValue == area.integerValue) {
                            *stop = YES;
                            aName = obj.title;
                        }
                    }];
                }
            }];
        }
    }];
    complete(pName,cName,aName);
}

+ (void)convertProviceName:(NSString *)provice cityName:(NSString *)city areaName:(NSString *)area complete:(void (^)(NSNumber * _Nonnull, NSNumber * _Nonnull, NSNumber * _Nonnull))complete {
    NSArray * array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"]];
    NSArray <SEEAddressModel *> * addressList = [SEEAddressPickerViewController see_convertAreaWithjson:array];
    __block NSNumber * pId = @(0);
    __block NSNumber * cId = @(0);
    __block NSNumber * aId = @(0);
    [addressList enumerateObjectsUsingBlock:^(SEEAddressModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.title isEqualToString:provice]) {
            *stop = YES;
            pId = obj.Id;
            [obj.subAreas enumerateObjectsUsingBlock:^(SEEAddressModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.title isEqualToString:city]) {
                    *stop = YES;
                    cId = obj.Id;
                    [obj.subAreas enumerateObjectsUsingBlock:^(SEEAddressModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.title isEqualToString:area]) {
                            *stop = YES;
                            aId = obj.Id;
                        }
                    }];
                }
            }];
        }
    }];
    complete(pId,cId,aId);
}

#pragma mark - private method
- (void)see_queryWithProviceName:(NSString *)provice cityName:(NSString *)city areaName:(NSString *)area {
    [self.addressList enumerateObjectsUsingBlock:^(SEEAddressModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.title isEqualToString:provice]) {
            *stop = YES;
            self.info[0] = @(idx);
            [obj.subAreas enumerateObjectsUsingBlock:^(SEEAddressModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.title isEqualToString:city]) {
                    *stop = YES;
                    self.info[1] = @(idx);
                    [obj.subAreas enumerateObjectsUsingBlock:^(SEEAddressModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.title isEqualToString:area]) {
                            *stop = YES;
                            self.info[2] = @(idx);
                        }
                    }];
                }
            }];
        }
    }];
}

- (void)see_queryWithProviceId:(NSNumber *)provice cityId:(NSNumber *)city areaId:(NSNumber *)area {
    [self.addressList enumerateObjectsUsingBlock:^(SEEAddressModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.Id.integerValue == provice.integerValue) {
            *stop = YES;
            self.info[0] = @(idx);
            [obj.subAreas enumerateObjectsUsingBlock:^(SEEAddressModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.Id.integerValue == city.integerValue) {
                    *stop = YES;
                    self.info[1] = @(idx);
                    [obj.subAreas enumerateObjectsUsingBlock:^(SEEAddressModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj.Id.integerValue == area.integerValue) {
                            *stop = YES;
                            self.info[2] = @(idx);
                        }
                    }];
                }
            }];
        }
    }];
}

-(void)see_selectWithAnimate:(BOOL)animate {
    [self.addressPickerView selectRow:self.info[0].integerValue inComponent:0 animated:animate];
    [self.addressPickerView reloadComponent:1];
    [self.addressPickerView selectRow:self.info[1].integerValue inComponent:1 animated:animate];
    [self.addressPickerView reloadComponent:2];
    [self.addressPickerView selectRow:self.info[2].integerValue inComponent:2 animated:animate];
}

+ (NSArray <SEEAddressModel *> *)see_convertAreaWithjson:(NSArray *)json {
    NSMutableArray <SEEAddressModel *> * arr = [NSMutableArray array];
    [json enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SEEAddressModel * model = [[SEEAddressModel alloc]init];
        [model setValuesForKeysWithDictionary:obj];
        if (model.subAreas) {
           model.subAreas = [self see_convertAreaWithjson:model.subAreas];
        }
        [arr addObject:model];
    }];
    return arr.copy;
}


#pragma mark - Action
- (void)cancelButtonClick {
    if ([_delegate respondsToSelector:@selector(addressPickerViewControllerDidCancel:)]) {
        [_delegate addressPickerViewControllerDidCancel:self];
    }
}

- (void)okButtonClick {
    __block NSString * pName = @"";
    __block NSString * cName = @"";
    __block NSString * aName = @"";
    
    __block NSNumber * pId = @(0);
    __block NSNumber * cId = @(0);
    __block NSNumber * aId = @(0);
    
    [self.addressList enumerateObjectsUsingBlock:^(SEEAddressModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == self.info[0].integerValue) {
            pId = obj.Id;
            pName = obj.title;
            [obj.subAreas enumerateObjectsUsingBlock:^(SEEAddressModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == self.info[1].integerValue) {
                    cName = obj.title;
                    cId = obj.Id;
                    [obj.subAreas enumerateObjectsUsingBlock:^(SEEAddressModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (idx == self.info[2].integerValue) {
                            aName = obj.title;
                            aId = obj.Id;
                        }
                    }];
                }
            }];
        }
    }];
    
    NSString * name = [NSString stringWithFormat:@"%@ %@ %@",pName,cName,aName];
    if ([_delegate respondsToSelector:@selector(addressPickerViewController:DidPickInfo:)]) {
        [_delegate addressPickerViewController:self DidPickInfo:@{
    SEEAddressPickerViewControllerProviceNameKey: pName,
    SEEAddressPickerViewControllerProviceIdKey: pId,
    SEEAddressPickerViewControllerCityNameKey: cName,
    SEEAddressPickerViewControllerCityIdKey: cId,
    SEEAddressPickerViewControllerAreaNameKey: aName,
    SEEAddressPickerViewControllerAreaIdKey: aId,
    SEEAddressPickerViewControllerNameKey: name
    }];
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.addressList.count;
    }
    else if (component == 1) {
        if (self.addressList[self.info[0].integerValue].subAreas.count == 0) {
            return 0;
        }
        return self.addressList[self.info[0].integerValue].subAreas.count;
    }
    else {
        if (self.addressList[self.info[0].integerValue].subAreas.count == 0 || self.addressList[self.info[0].integerValue].subAreas[self.info[1].integerValue].subAreas.count == 0) {
            return 0;
        }
        return self.addressList[self.info[0].integerValue].subAreas[self.info[1].integerValue].subAreas.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.addressList[row].title;
    }
    else if (component == 1){
        return self.addressList[self.info[0].integerValue].subAreas[row].title;
    }
    else {
        return self.addressList[self.info[0].integerValue].subAreas[self.info[1].integerValue].subAreas[row].title;
    }
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.info[component] = @(row);
    for (NSInteger i  = component + 1; i < 3; i++) {
        self.info[i] = @(0);
        [pickerView reloadComponent:i];
        [pickerView selectRow:0 inComponent:i animated:YES];
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
        okButton.tag = SEEAddressPickerViewPickTypeOK;
        _okButton = okButton;
        
        UIButton * cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 2, 40)];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1] forState:UIControlStateNormal];
        [cancelButton setBackgroundColor:[UIColor whiteColor]];
        cancelButton.layer.borderColor = [UIColor colorWithRed:199 /255.0 green:199 /255.0 blue:199 /255.0 alpha:1].CGColor;
        cancelButton.layer.borderWidth = 1;
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.tag = SEEAddressPickerViewPickTypeCancel;
        _cancelButton = cancelButton;
        [_titleView addSubview:_cancelButton];
        [_titleView addSubview:_okButton];
    }
    return _titleView;
}

- (UIPickerView *)addressPickerView {
    if (_addressPickerView == nil) {
        _addressPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, pickerViewControllerHeight)];
        _addressPickerView.delegate = self;
        _addressPickerView.dataSource = self;
        _addressPickerView.backgroundColor = [UIColor whiteColor];
    }
    return _addressPickerView;
}

- (NSMutableArray<NSNumber *> *)info {
    if (_info == nil) {
        _info = [NSMutableArray arrayWithObjects:@(0),@(0),@(0), nil];
    }
    return _info;
}

- (NSArray<SEEAddressModel *> *)addressList {
    if (_addressList == nil) {
        NSArray * array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"]];
        _addressList = [SEEAddressPickerViewController see_convertAreaWithjson:array];
    }
    return _addressList;
}

@end

#pragma mark - SEEAddressPickerViewTransitioning implementation

@implementation SEEAddressPickerViewTransitioning

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[SEEAddressPickerViewPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
}

@end

#pragma mark -

@implementation SEEAddressPickerViewPresentationController

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
    [[NSNotificationCenter defaultCenter]postNotificationName:SEEAddressPickerViewDismissNotification object:nil];
}

@end
