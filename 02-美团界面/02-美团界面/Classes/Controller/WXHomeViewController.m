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

@interface WXHomeViewController ()

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

@end

@implementation WXHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化顶部TopView
    [self setupUIBarbuttionItems];
}

#pragma mark - setUp
- (void)setupUIBarbuttionItems
{
    // 1.创建美团logo
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStyleDone target:nil action:nil];
    // 设置让logoItem不能点击
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

#pragma mark - Event
- (void)categoryClick {
    
    // 1.指定popover弹出的位置为self.categoryItem的位置
    self.categoryVc.popoverPresentationController.barButtonItem = self.categoryItem;
    
    // 2.弹出popover
    [self presentViewController:self.categoryVc animated:YES completion:nil];
}

- (void)districtClick {
    NSLog(@"%s",__func__);
}

- (void)sortClick {
    NSLog(@"%s",__func__);
}

#pragma mark - Lazy Load
- (WXCategoryController *)categoryVc
{
    if (_categoryVc == nil) {
        // 1.创建分类内容的控制器
        _categoryVc = [[WXCategoryController alloc] init];
        
        // 2.设置Modal方式弹出分类内容控制器的样式
        _categoryVc.modalPresentationStyle = UIModalPresentationPopover;
    }
    return _categoryVc;
}


@end
