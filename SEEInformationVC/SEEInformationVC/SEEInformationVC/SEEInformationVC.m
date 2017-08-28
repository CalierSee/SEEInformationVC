//
//  SEEInformationVC.m
//  SEEInformationView
//
//  Created by 景彦铭 on 2017/5/31.
//  Copyright © 2017年 景彦铭. All rights reserved.
//

#import "SEEInformationVC.h"
#import "SEETextFieldCell.h"
#import "NSObject+information.h"
#import "SEETextViewCell.h"
#import "SEEPickerViewController.h"
#import "SEESelectViewCell.h"
#import "SEEInformationHeaderView.h"
#import "SEEMutableSelectViewCell.h"
#import "SEEMutableSelectViewController.h"
#import "SEECustomViewCell.h"
#import "SEEDateViewCell.h"
#import "SEEDatePickerViewController.h"
#import "SEEAddressPickerViewController.h"
#import "SEEAddressViewCell.h"
#import "SEEImageViewCell.h"
#import "SEEInformationBaseCell.h"

static NSString * const kTextFieldId = @"kTextFieldId";
static NSString * const kTextViewId = @"kTextViewId";
static NSString * const kSelectViewId = @"kSelectViewId";
static NSString * const kMutableSelectViewId = @"kMutableSelectViewId";
static NSString * const kCustomViewId = @"kCustomViewId";
static NSString * const kDateViewId = @"kDateViewId";
static NSString * const kAddressViewId = @"kAddressViewId";
static NSString * const kImageViewId = @"kImageViewId";



#pragma mark - informationModel

@implementation SEEInformationModel

+(nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"dtlList" : @"SEEInformationDtlModel",
             };
}

@end



#pragma mark - informationDtlModel

@implementation SEEInformationDtlModel

+(nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"valueStrings" : @"NSString",
             @"values" : @"id"
             };
}

@end







#pragma mark - informationVC

@interface SEEInformationVC () 
//tableView
@property(nonatomic,strong)UITableView * tableView;
//列表项
@property(nonatomic,strong)NSArray <SEEInformationModel *> * informations;
//数据字典
@property(nonatomic,strong)NSMutableDictionary * info;

//弹出选择框的选择视图所在的indexPath
@property(nonatomic,strong)NSIndexPath * currentSelectIndexPath;

@property(nonatomic,strong)NSMutableDictionary <NSString *, UIView *> * customViewInfo;

@property(nonatomic,strong)NSMutableDictionary <NSString * ,NSNumber *> * customViewHeightInfo;

//是否允许编辑
@property (nonatomic,assign)BOOL isEdit;

@end

@implementation SEEInformationVC

- (void)configureInformations:(NSArray<SEEInformationModel *> *)informations {
    self.informations = informations;
    if (!self.isEdit) {
        
        //剔除空数据列表
        [self see_deleteEmptyItem];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)configureInfo:(NSDictionary *)info {
    self.info = [NSMutableDictionary dictionaryWithDictionary:info];
    if (!self.isEdit) {
        
        //剔除空数据列表
        [self see_deleteEmptyItem];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)configureIsEdit:(BOOL)flag {
    self.isEdit = flag;
    if (!self.isEdit) {
        
        //剔除空数据列表
        [self see_deleteEmptyItem];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)configureInformations:(nullable NSArray<SEEInformationModel *> *)informations info:(nullable NSDictionary *)info isEdit:(BOOL)flag{
    self.isEdit = flag;
    if (info) {
        self.info = [NSMutableDictionary dictionaryWithDictionary:info];
    }
    if (informations) {
        self.informations = informations;
    }
    if (!self.isEdit) {
        
        //剔除空数据列表
        [self see_deleteEmptyItem];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (instancetype)init {
    if (self = [self initWithInformations:nil info:nil isEdit:YES]) {
        self.customViewInfo = [NSMutableDictionary dictionary];
        self.customViewHeightInfo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (instancetype)initWithInformations:(NSArray<SEEInformationModel *> *)informations info:(nullable NSDictionary *)info isEdit:(BOOL)flag{
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.isEdit = flag;
        if (info) {
            self.info = [NSMutableDictionary dictionaryWithDictionary:info];
        }
        if (informations) {
            self.informations = informations;
        }
        self.customViewInfo = [NSMutableDictionary dictionary];
        self.customViewHeightInfo = [NSMutableDictionary dictionary];
        self.isEdit = flag;
        if (!self.isEdit) {
            //剔除空数据列表
            [self see_deleteEmptyItem];
        }
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithInformations:nil info:nil isEdit:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateInfo) name:SEEInformationViewControllerCollectValueNotification object:nil];
    
    [self see_loadUI];
    if (!self.isEdit) {
        
        //剔除空数据列表
        [self see_deleteEmptyItem];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - public method
- (void)updateInfo {
    [self.customViewInfo enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, UIView * _Nonnull obj, BOOL * _Nonnull stop) {
        NSArray <NSString *> * keys = [key componentsSeparatedByString:@"-"];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:keys[1].integerValue inSection:keys[0].integerValue];
        SEEInformationDtlModel * model = self.informations[indexPath.section].dtlList[indexPath.row];
        if (self.responder.valueAtIndexPath) {
            id value = [self.dataSource informationViewController:self valueAtIndexPath:indexPath];
            if (![NSObject isNull:value]) {
                [self.info setObject:value forKey:model.property];
            }
        }
    }];
    [self.tableView reloadData];
}

#pragma mark - private method
- (void)see_getImage {
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"" message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self see_camera];
    }];
    UIAlertAction * album = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self see_pickImage];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@" 取消" style:UIAlertActionStyleDestructive handler:nil];
    
    [alertC addAction:camera];
    [alertC addAction:album];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
    
}

- (void)see_camera {
    UIImagePickerController * imageC = [[UIImagePickerController alloc]init];
    imageC.navigationBar.translucent = NO;
    [imageC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    imageC.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imageC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imageC animated:YES completion:nil];
    }else {
    }
}

- (void)see_pickImage {
    UIImagePickerController * imageC = [[UIImagePickerController alloc]init];
    imageC.navigationBar.translucent = NO;
    [imageC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    imageC.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imageC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imageC animated:YES completion:nil];
    }else {
    }
}


- (void)see_loadUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

- (void)see_deleteEmptyItem {
    NSMutableArray <SEEInformationModel *> * informations = [NSMutableArray array];
    
    [self.informations enumerateObjectsUsingBlock:^(SEEInformationModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray * dtlList = [NSMutableArray array];
        [obj.dtlList enumerateObjectsUsingBlock:^(SEEInformationDtlModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![NSObject isNull:[self.info objectForKey:obj.property]] && ![[[self.info objectForKey:obj.property] convertToString] isEqualToString:@""]) {
                [dtlList addObject:obj];
            }
        }];
        if (dtlList.count) {
            SEEInformationModel * model = [[SEEInformationModel alloc]init];
            model.title = obj.title;
            model.dtlList = dtlList;
            [informations addObject:model];
        }
    }];
    
    self.informations = informations.copy;
}

- (void)see_showAlertWithTitle:(NSString *)title {
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - delegate
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.informations.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.informations[section].dtlList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SEEInformationDtlModel * model = self.informations[indexPath.section].dtlList[indexPath.row];
    SEEInformationBaseCell * cell;
    switch (model.showType) {
        case SEEInformationShowTypeTextField:{
            cell = [tableView dequeueReusableCellWithIdentifier:kTextFieldId forIndexPath:indexPath];
        }
            break;
            
        case SEEInformationShowTypeTextView:{
            cell = [tableView dequeueReusableCellWithIdentifier:kTextViewId forIndexPath:indexPath];
        }
            break;
        case SEEInformationShowTypeSelectView:{
            cell = [tableView dequeueReusableCellWithIdentifier:kSelectViewId forIndexPath:indexPath];
        }
            break;
        case SEEInformationShowTypeMutableSelectView:{
            cell = [tableView dequeueReusableCellWithIdentifier:kMutableSelectViewId forIndexPath:indexPath];
        }
            break;
        case SEEInformationShowTypeDate:
        case SEEInformationShowTypeTime:
        case SEEInformationShowTypeDateAndTime:{
            cell = [tableView dequeueReusableCellWithIdentifier:kDateViewId forIndexPath:indexPath];
        }
            break;
        case SEEInformationShowTypeAddress:{
            cell = [tableView dequeueReusableCellWithIdentifier:kAddressViewId forIndexPath:indexPath];
        }
            break;
        case SEEInformationShowTypeImage:{
            cell = [tableView dequeueReusableCellWithIdentifier:kImageViewId forIndexPath:indexPath];
        }
            break;
        case SEEInformationShowTypeCustomView:{
            cell = [tableView dequeueReusableCellWithIdentifier:kCustomViewId forIndexPath:indexPath];
            NSString * key = [NSString stringWithFormat:@"%zd-%zd",indexPath.section,indexPath.row];
            UIView * view = [self.customViewInfo objectForKey:key];
            CGFloat height = [self.customViewHeightInfo objectForKey:key].floatValue;
            if (view == nil) {
                if (self.dataSource && self.responder.cellAtIndexPath && self.responder.heightAtIndexPath) {
                    view = [self.dataSource informationViewController:self customCellAtIndexPath:indexPath];
                    [self.customViewInfo setObject:view forKey:key];
                    height = [self.dataSource informationViewController:self heightAtIndexPath:indexPath];
                    [self.customViewHeightInfo setObject:@(height) forKey:key];
                }
            }
            [((SEECustomViewCell *)cell) configureCellWithView:view height:height];
            if (self.responder.postValueAtIndexPtah) {
                [self.dataSource informationViewController:self postValue:[self.info objectForKey:model.property] indexPath:indexPath];
            }
        }
            break;
            
        default:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            break;
    }
    [cell setEdit:self.isEdit];
    [cell configureCellWithModel:model info:self.info delegate:self indexPath:indexPath];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.informations[section].title.length) {
        SEEInformationModel * model = self.informations[section];
        SEEInformationHeaderView * header = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([SEEInformationHeaderView class]) owner:nil options:nil].lastObject;
        [header configureWithTitle:model.title];
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.informations[section].title.length) {
        return 40;
    }
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.dragging) {
        [self.view endEditing:YES];
    }
}

#pragma mark SEEInformationBaseCellDelegate
- (void)cell:(SEEInformationBaseCell *)cell didChangeValue:(id)value atIndexPath:(NSIndexPath *)indexPath{
    SEEInformationDtlModel * model = self.informations[indexPath.section].dtlList[indexPath.row];
    if (![NSObject isNull:value]) {
        if (model.regularString.length) {
            NSError * error;
            NSRegularExpression * expression = [NSRegularExpression regularExpressionWithPattern:model.regularString options:NSRegularExpressionDotMatchesLineSeparators error:&error];
            if (error) {
                [self see_showAlertWithTitle:@"正则表达式有误,请联系客服后重试!"];
                [self.info removeObjectForKey:model.property];
            }
            else {
                NSArray<NSTextCheckingResult *> * result = [expression matchesInString:(NSString *)value options:NSMatchingReportCompletion range:NSMakeRange(0, ((NSString *)value).length)];
                if (result.count) {
                    [self.info setObject:[value substringWithRange:result.firstObject.range] forKey:model.property];
                }
                else {
                    [self see_showAlertWithTitle:[NSString stringWithFormat:@"%@输入有误!",model.title]];
                    [self.info removeObjectForKey:model.property];
                }
            }
        }
        else {
            [self.info setObject:value forKey:model.property];
        }
    }
    else {
        [self.info removeObjectForKey:model.property];
    }
    [self.tableView reloadData];
}

- (void)selectCell:(SEEInformationBaseCell *)cell needShowSelectViewWithType:(SEEInformationShowType)type indexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    SEEInformationDtlModel * model = self.informations[indexPath.section].dtlList[indexPath.row];
    self.currentSelectIndexPath = indexPath;
    switch (type) {
        case SEEInformationShowTypeSelectView: {
            SEEPickerViewController * pc = [[SEEPickerViewController alloc]initWithTitle:model.placeHolder delegate:self dataSource:self];
            pc.view.backgroundColor = [UIColor greenColor];
            __weak typeof(self) weakSelf = self;
            [self presentViewController:pc animated:YES completion:^{
                id value = [weakSelf.info objectForKey:model.property];
                [model.values enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([value isEqual:obj]) {
                        *stop = YES;
                        [pc selectRow:idx forComponent:0 animated:YES];
                    }
                }];
            }];
        }
            break;
        case SEEInformationShowTypeMutableSelectView: {
            SEEMutableSelectViewController * mc = [[SEEMutableSelectViewController alloc] initWithTitles:model.valueStrings values:model.values selectedItems:[self.info objectForKey:model.property] delegate:self];
            [self presentViewController:mc animated:YES completion:nil];
        }
            break;
        case SEEInformationShowTypeDate:
        case SEEInformationShowTypeTime:
        case SEEInformationShowTypeDateAndTime: {
            UIDatePickerMode mode = 0;
            switch (type) {
                case SEEInformationShowTypeDate:
                    mode = UIDatePickerModeDate;
                    break;
                case SEEInformationShowTypeTime:
                    mode = UIDatePickerModeTime;
                    break;
                case SEEInformationShowTypeDateAndTime:
                    mode = UIDatePickerModeDateAndTime;
                    break;
                default:
                    break;
            }
            SEEDatePickerViewController * mc = [[SEEDatePickerViewController alloc] initWithTimeInteval:((NSNumber *)[self.info objectForKey:model.property]).floatValue == 0 ? [[NSDate date] timeIntervalSince1970] : ((NSNumber *)[self.info objectForKey:model.property]).floatValue mode:mode isSupportFailure:model.isSupportFuture isSupportPass:model.isSupportPass delegate:self ];
            [self presentViewController:mc animated:YES completion:nil];
        }
            break;
            
        case SEEInformationShowTypeAddress: {
            SEEAddressPickerViewController * vc = [[SEEAddressPickerViewController alloc]initWithDelegate:self];
            __weak typeof(self) weakSelf = self;
            [self presentViewController:vc animated:YES completion:^{
                [vc selectWithProviceId:[weakSelf.info objectForKey:model.property][SEEAddressPickerViewControllerProviceIdKey] cityId:[weakSelf.info objectForKey:model.property][SEEAddressPickerViewControllerCityIdKey] areaId:[weakSelf.info objectForKey:model.property][SEEAddressPickerViewControllerAreaIdKey] animate:YES];
                
            }];
        }
            break;
        case SEEInformationShowTypeImage: {
            [self see_getImage];
        }
            break;

        default:
            break;
    }
}

- (void)imageCell:(SEEInformationBaseCell *)cell needDeleteImageAtIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath {
    SEEInformationDtlModel * model = self.informations[indexPath.section].dtlList[indexPath.row];
    NSMutableArray * arr = [NSMutableArray arrayWithArray:[self.info objectForKey:model.property]];
    [arr removeObjectAtIndex:index];
    [self.info setObject:arr.copy forKey:model.property];
    [self.tableView reloadData];
}

#pragma mark - SEEPickerViewControllerDataSource
- (NSInteger)pickerViewController:(SEEPickerViewController *)vc numberOfRowsInComponent:(NSInteger)component {
    SEEInformationDtlModel * model = self.informations[self.currentSelectIndexPath.section].dtlList[self.currentSelectIndexPath.row];
    
    return model.valueStrings.count;
}

- (NSString *)pickerViewController:(SEEPickerViewController *)vc titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    SEEInformationDtlModel * model = self.informations[self.currentSelectIndexPath.section].dtlList[self.currentSelectIndexPath.row];
    
    return model.valueStrings[row];
}

#pragma mark - SEEPickerViewControllerDelegate
- (void)pickerViewControllerDidCancel:(SEEPickerViewController *)vc {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pickerViewController:(SEEPickerViewController *)vc DidPickInfo:(NSArray<NSDictionary *> *)info {
    SEEInformationDtlModel * model = self.informations[self.currentSelectIndexPath.section].dtlList[self.currentSelectIndexPath.row];
    [self.info setObject:model.values[((NSNumber *)info.lastObject[SEEPickerViewControllerRowKey]).integerValue] forKey:model.property];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SEEMutableSelectViewControllerDelegate
- (void)mutableSelectViewControllerDidCancle:(SEEMutableSelectViewController *)vc {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mutableSelectViewController:(SEEMutableSelectViewController *)vc didChooseInfo:(NSDictionary<NSString *,NSArray *> *)info {
    SEEInformationDtlModel * model = self.informations[self.currentSelectIndexPath.section].dtlList[self.currentSelectIndexPath.row];
    [self.info setObject:info[SEEMutableSelectViewControllerInfoValueKey] forKey:model.property];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SEEDatePickerViewControllerDelegate
- (void)datePickerViewControllerDidCancel:(SEEDatePickerViewController *)vc {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)datePickerViewController:(SEEDatePickerViewController *)vc didPickeInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    SEEInformationDtlModel * model = self.informations[_currentSelectIndexPath.section].dtlList[_currentSelectIndexPath.row];
    [self.info setObject:info[SEEDatePickerViewControllerTimeIntervalSince1970Key] forKey:model.property];
    [self.tableView reloadData];
}

#pragma mark - SEEAddressPickerViewControllerDelegate
- (void)addressPickerViewControllerDidCancel:(SEEAddressPickerViewController *)vc {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addressPickerViewController:(SEEAddressPickerViewController *)vc DidPickInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    SEEInformationDtlModel * model = self.informations[_currentSelectIndexPath.section].dtlList[_currentSelectIndexPath.row];
    [self.info setObject:info forKey:model.property];
    [self.tableView reloadData];
}

#pragma mark - UIImagePickerViewControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage * image = info[UIImagePickerControllerOriginalImage];
    SEEInformationDtlModel * model = self.informations[_currentSelectIndexPath.section].dtlList[_currentSelectIndexPath.row];
    NSMutableArray * array;
    if ([self.info objectForKey:model.property]) {
         array = [NSMutableArray arrayWithArray:[self.info objectForKey:model.property]];
    }
    else {
        array = [NSMutableArray array];
    }
    [array addObject:image];
    [self.info setObject:array forKey:model.property];
    [self.tableView reloadData];
}

#pragma mark - getter & setter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorColor = [UIColor colorWithWhite:0.9 alpha:1];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _tableView.estimatedRowHeight = 100;
#ifdef DEBUG
        [_tableView registerClass:[SEEInformationBaseCell class] forCellReuseIdentifier:@"cell"];
#endif
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SEETextFieldCell class]) bundle:nil] forCellReuseIdentifier:kTextFieldId];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SEETextViewCell class]) bundle:nil] forCellReuseIdentifier:kTextViewId];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SEESelectViewCell class]) bundle:nil] forCellReuseIdentifier:kSelectViewId];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SEEMutableSelectViewCell class]) bundle:nil] forCellReuseIdentifier:kMutableSelectViewId];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SEEDateViewCell class]) bundle:nil] forCellReuseIdentifier:kDateViewId];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SEEAddressViewCell class]) bundle:nil] forCellReuseIdentifier:kAddressViewId];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SEEImageViewCell class]) bundle:nil] forCellReuseIdentifier:kImageViewId];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SEECustomViewCell class]) bundle:nil] forCellReuseIdentifier:kCustomViewId];
        
    }
    return _tableView;
}

- (NSMutableDictionary *)info {
    if (_info == nil) {
        _info = [NSMutableDictionary dictionary];
    }
    return _info;
}

- (void)setDataSource:(id<SEEInformationVCDataSource>)dataSource {
    _dataSource = dataSource;
    _responder.cellAtIndexPath = [_dataSource respondsToSelector:@selector(informationViewController:customCellAtIndexPath:)];
    _responder.heightAtIndexPath = [_dataSource respondsToSelector:@selector(informationViewController:heightAtIndexPath:)];
    _responder.valueAtIndexPath = [_dataSource respondsToSelector:@selector(informationViewController:valueAtIndexPath:)];
    _responder.postValueAtIndexPtah = [_dataSource respondsToSelector:@selector(informationViewController:postValue:indexPath:)];
}

@end
