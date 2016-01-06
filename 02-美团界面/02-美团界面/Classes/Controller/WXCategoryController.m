//
//  WXCategoryController.m
//  02-美团界面
//
//  Created by 李伟雄 on 16/1/6.
//  Copyright © 2016年 Liwx. All rights reserved.
//

#import "WXCategoryController.h"
#import "WXLRTableView.h"
#import "WXCategoryItem.h"
#import <MJExtension.h>

@interface WXCategoryController () <WXLRTableViewDataSource, WXLRTableViewDataDelegate>

/** 分类数据源数组 */
@property (nonatomic, strong) NSArray *categoryDatas;

@end

@implementation WXCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    [self setupLRTableView];
}

#pragma mark - setUp
/** 初始化LRTableView */
- (void)setupLRTableView
{
    // 创建lrTableView,设置跟随父控件的拉伸而拉伸,并添加到控制器的view
    WXLRTableView *lrTableView = [WXLRTableView lrTableView];
    lrTableView.frame = self.view.bounds;
    lrTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:lrTableView];
    
    // 设置数据源,代理
    lrTableView.dataSource = self;
    lrTableView.delegate = self;
}

#pragma mark - <WXLRTableViewDataSource, WXLRTableViewDataDelegate>

/** 返回左边leftTableView共多少行*/
- (NSInteger)numOfRowsInLeftTableView:(WXLRTableView *)lrTableView
{
    return self.categoryDatas.count;
}

/** 返回左边第leftRow行的标题 */
- (NSString *)lrTableView:(WXLRTableView *)lrTableView titleInLeftRow:(NSInteger)leftRow
{
    WXCategoryItem *item = self.categoryDatas[leftRow];
    return item.name;
}

/** 返回左边第leftRow行的子标题 */
- (NSArray *)lrTableView:(WXLRTableView *)lrTableView subTitleInLeftRow:(NSInteger)leftRow
{
    WXCategoryItem *item = self.categoryDatas[leftRow];
    return item.subcategories;
}


#pragma mark Lazy Load
- (NSArray *)categoryDatas
{
    if (_categoryDatas == nil) {
        _categoryDatas = [WXCategoryItem mj_objectArrayWithFilename:@"categories.plist"];
    }
    return _categoryDatas;
}

@end
