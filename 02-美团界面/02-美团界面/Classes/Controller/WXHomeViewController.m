//
//  WXHomeViewController.m
//  02-美团界面
//
//  Created by 李伟雄 on 16/1/6.
//  Copyright © 2016年 Liwx. All rights reserved.
//

#import "WXHomeViewController.h"
#import "WXTopView.h"
#import "WXCategoryController.h"
#import "WXConst.h"
#import "WXCategoryItem.h"
#import "WXDistrictController.h"
#import "WXDistrictItem.h"
#import "WXSortController.h"
#import "WXSortItem.h"

@interface WXHomeViewController () <UIPopoverPresentationControllerDelegate>

#pragma mark - subViews
/** 分类的Item*/
@property (nonatomic ,weak) UIBarButtonItem *categoryItem;
/** 区域的Item*/
@property (nonatomic ,weak) UIBarButtonItem *districtItem;
/** 排序的Item*/
@property (nonatomic ,weak) UIBarButtonItem *sortItem;

#pragma mark - popover
/** 分类内容的控制器 */
@property (nonatomic, strong) WXCategoryController *categoryVc;
/** 区域内容的控制器 */
@property (nonatomic, strong) WXDistrictController *districtVc;
/** 排序内容的控制器 */
@property (nonatomic, strong) WXSortController *sortVc;

@end

@implementation WXHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.初始化顶部TopView
    [self setupUIBarbuttionItems];
    
    // 2.添加通知监听接受者
    [self setupNotifications];
}

#pragma mark - setUp
- (void)setupUIBarbuttionItems
{
    // 1.创建美团logo
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStyleDone target:nil action:nil];
    // SINGLE: 设置让logoItem不能点击,需在Assets将图片设置为不渲染,Render设置为Original Image
    logoItem.enabled = NO;
    
    // 2.创建分类的item
    WXTopView *categoryView = [WXTopView topView];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryView];
    self.categoryItem = categoryItem;
    [categoryView setTitle:@"美团"];
    [categoryView setSubtitle:@"全部分类"];
    [categoryView setIcon:@"icon_category_-1" highIcon:@"icon_category_highlighted_-1"];
    [categoryView addTarget:self action:@selector(categoryClick)];
    
    // 3.创建区域的item
    WXTopView *districtView = [WXTopView topView];
    UIBarButtonItem *districtItem = [[UIBarButtonItem alloc] initWithCustomView:districtView];
    self.districtItem = districtItem;
    [districtView setTitle:@"广州"];
    [districtView setSubtitle:@"全部区域"];
    [districtView setIcon:@"icon_district" highIcon:@"icon_district_highlighted"];
    [districtView addTarget:self action:@selector(districtClick)];
    
    // 4.创建排序的item
    WXTopView *sortView = [WXTopView topView];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:sortView];
    self.sortItem = sortItem;
    [sortView setTitle:@"排序"];
    [sortView setSubtitle:@"默认排序"];
    [sortView setIcon:@"icon_sort" highIcon:@"icon_sort_highlighted"];
    [sortView addTarget:self action:@selector(sortClick)];

    
    // 5.添加到leftBarButtonItems
    self.navigationItem.leftBarButtonItems = @[logoItem, categoryItem, districtItem, sortItem];
}

- (void)setupNotifications
{
    // 设置监听category的退出popover的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryNoti:) name:WXCategoryNotification object:nil];
    
    // 设置监听district的退出popover的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(districtNoti:) name:WXDistrictNotification object:nil];
    
    // 设置监听sort的退出popover的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortNoti:) name:WXSortNotification object:nil];
}

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 退出popover的通知
/** 分类通知 */
- (void)categoryNoti:(NSNotification *)noti {
    
    // 1.更新categoryItem的图标和标题
    // 1.1 取出数据, 取出标题子标题和图标数据
    WXCategoryItem *item = noti.userInfo[WXCategoryNotificationKey];
    NSString *categorySubTitle = noti.userInfo[WXSubCategoryNotificationKey];
    
    // 1.2 获取通知发送者传递过来的数据
    WXTopView *categoryTopView = self.categoryItem.customView;
    // 1.3 判断是否有子标题
    if (item.subcategories.count == 0) {
        [categoryTopView setTitle:@"美团"];
        [categoryTopView setSubtitle:item.name];
    }else {
        [categoryTopView setTitle:item.name];
        [categoryTopView setSubtitle:categorySubTitle];
    }
    // 1.4 更新普通/高亮状态的图标
    [categoryTopView setIcon:item.small_icon highIcon:item.small_highlighted_icon];
    
    // 2.退出popover
    [self.categoryVc dismissViewControllerAnimated:YES completion:nil];
    
    // 3.退出popover后让顶部按钮可点击
    [self enabled];
}

/** 区域通知 */
- (void)districtNoti:(NSNotification *)noti {
    
    // 1.更新districtItem的图标和标题
    // 1.1 取出数据, 取出标题子标题和图标数据
    WXDistrictItem *item = noti.userInfo[WXDistrictNotificationKey];
    NSString *districtSubTitle = noti.userInfo[WXSubDistrictNotificationKey];
    
    // 1.2 获取通知发送者传递过来的数据
    WXTopView *districtTopView = self.districtItem.customView;
    // 1.3 判断是否有子标题
    if (item.subregions.count == 0) {
        [districtTopView setTitle:@"广州"];
        [districtTopView setSubtitle:item.name];
    }else {
        [districtTopView setTitle:item.name];
        [districtTopView setSubtitle:districtSubTitle];
    }
    
    // 2.退出popover
    [self.districtVc dismissViewControllerAnimated:YES completion:nil];
    
    // 3.退出popover后让顶部按钮可点击
    [self enabled];
}

/** 排序通知 */
- (void)sortNoti:(NSNotification *)noti {
    
    // 1.更新districtItem的文字
    // 1.1 取出传递过来的数据
    WXSortItem *item = noti.userInfo[WXSortNotificationKey];
    
    // 1.2 更新显示的文字
    WXTopView *sortTopView = self.sortItem.customView;
    [sortTopView setSubtitle:item.label];
    
    // 2. 退出popover
    [self.sortVc dismissViewControllerAnimated:YES completion:nil];
    
    // 3.退出popover后让顶部按钮可点击
    [self enabled];
}

#pragma mark - Event
- (void)categoryClick {
    
    // SINGLE: 1.指定popover弹出的位置为self.categoryItem的位置
    self.categoryVc.popoverPresentationController.barButtonItem = self.categoryItem;
    
    // 2.弹出popover
    [self presentViewController:self.categoryVc animated:YES completion:nil];
    
    // CARE: popover消失后,会自动清空代理属性,所以不能再懒加载中设置代理
    // 3.设置代理,用于监听popover退出时,让顶部的按钮可点击
    self.categoryVc.popoverPresentationController.delegate = self;
    
    // 4.让顶部按钮不可点击
    [self disabled];
}

- (void)districtClick {
    // 1.指定popover弹出的位置为self.districtItem的位置
    self.districtVc.popoverPresentationController.barButtonItem = self.districtItem;
    
    // 2.弹出popover
    [self presentViewController:self.districtVc animated:YES completion:nil];
    
    // 3.设置代理,用于监听popover退出时,让顶部的按钮可点击,需遵守UIPopoverPresentationControllerDelegate协议
    self.districtVc.popoverPresentationController.delegate = self;
    
    // 4.让顶部按钮不可点击
    [self disabled];
}

- (void)sortClick {
    // 1.指定popover弹出的位置为self.sortItem的位置
    self.sortVc.popoverPresentationController.barButtonItem = self.sortItem;
    
    // 2.弹出popover
    [self presentViewController:self.sortVc animated:YES completion:nil];
    
    // 3.设置代理,用于监听popover退出时,让顶部的按钮可点击,需遵守UIPopoverPresentationControllerDelegate协议
    self.sortVc.popoverPresentationController.delegate = self;
    
    // 4.让顶部按钮不可点击
    [self disabled];
}

#pragma mark - 设置enabled 属性
- (void)enabled {
    self.categoryItem.enabled = YES;
    self.districtItem.enabled = YES;
    self.sortItem.enabled = YES;
}

- (void)disabled {
    self.categoryItem.enabled = NO;
    self.districtItem.enabled = NO;
    self.sortItem.enabled = NO;
}

#pragma mark - UIPopoverPresentationControllerDelegate
// SINGLE: popover消失时会调用popoverPresentationControllerDidDismissPopover方法,需遵守UIPopoverPresentationControllerDelegate协议,
// CARE: 仅在点击空白处,popov消失的时候才会调用,调用dismissViewControllerAnimated让popover消失不会调用该方法
/** popover消失时会调用, 注意:仅在点击空白处,popov消失的时候才会调用*/
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    // 让顶部按钮可点击
    [self enabled];
}

#pragma mark - Lazy Load
- (WXCategoryController *)categoryVc
{
    if (_categoryVc == nil) {
        // SINGLE: 1.创建分类内容的控制器
        _categoryVc = [[WXCategoryController alloc] init];
        
        // 2.设置Modal方式弹出分类内容控制器的样式
        _categoryVc.modalPresentationStyle = UIModalPresentationPopover;
    }
    return _categoryVc;
}

- (WXDistrictController *)districtVc
{
    if (_districtVc == nil) {
        // 1.创建区域内容的控制器
        _districtVc = [[WXDistrictController alloc] init];
        
        // 2.设置Modal方式弹出分类内容控制器的样式
        _districtVc.modalPresentationStyle = UIModalPresentationPopover;
    }
    return _districtVc;
}

- (WXSortController *)sortVc
{
    if (_sortVc == nil) {
        // 1.创建区域内容的控制器
        _sortVc = [[WXSortController alloc] init];
        
        // 2.设置Modal方式弹出分类内容控制器的样式
        _sortVc.modalPresentationStyle = UIModalPresentationPopover;
    }
    return _sortVc;
}


@end
