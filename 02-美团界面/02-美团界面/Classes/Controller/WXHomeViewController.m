//
//  WXHomeViewController.m
//  02-美团界面
//
//  Created by 李伟雄 on 16/1/6.
//  Copyright © 2016年 Liwx. All rights reserved.
//

#import "WXHomeViewController.h"
#import "WXTopView.h"

@interface WXHomeViewController ()

/** 分类的Item*/
@property (nonatomic ,weak)UIBarButtonItem *categoryItem;
/** 区域的Item*/
@property (nonatomic ,weak)UIBarButtonItem *districtItem;
/** 排序的Item*/
@property (nonatomic ,weak)UIBarButtonItem *sortItem;

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
    NSLog(@"%s",__func__);
}

- (void)districtClick {
    NSLog(@"%s",__func__);
}

- (void)sortClick {
    NSLog(@"%s",__func__);
}



@end
