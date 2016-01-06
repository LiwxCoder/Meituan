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
#import "WXConst.h"
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

/** 返回左边某行显示的普通图标 */
- (NSString *)lrTableView:(WXLRTableView *)lrTableView iconInLeftRow:(NSInteger)leftRow
{
    WXCategoryItem *item = self.categoryDatas[leftRow];
    return item.small_icon;
}
/** 返回左边某行显示的高亮图标 */
- (NSString *)lrTableView:(WXLRTableView *)lrTableView highIconInLeftRow:(NSInteger)leftRow
{
    WXCategoryItem *item = self.categoryDatas[leftRow];
    return item.small_highlighted_icon;
}

/** 点击左边告诉代理左边点击了第几行 */
- (void)lrTableView:(WXLRTableView *)lrTableView selectedLeftRow:(NSInteger)leftRow;
{
    // 判断左边当前选中行是否有子标题,若无子标题,发送通知,让通知监听者退出popover
    WXCategoryItem *categoryItem = self.categoryDatas[leftRow];
    if (categoryItem.subcategories.count == 0) {
        // 发送通知,传递数据用于刷新顶部CategoryItem的图标和文字
        NSDictionary *dict = @{WXCategoryNotificationKey : categoryItem};
        [[NSNotificationCenter defaultCenter] postNotificationName:WXCategoryNotification object:nil userInfo:dict];
    }
}

/** 点击右边告诉代理左边点击了第几行,右边点击了第几行 */
- (void)lrTableView:(WXLRTableView *)lrTableView selectedLeftRow:(NSInteger)leftRow selectedRightRow:(NSInteger)rightRow
{
    // 取出数据
    WXCategoryItem *categoryItem = self.categoryDatas[leftRow];
    NSString *categorySubTitle = categoryItem.subcategories[rightRow];
    // 发送通知,传递数据用于刷新顶部CategoryItem的图标和文字
    NSDictionary *dict = @{
                           WXCategoryNotificationKey : categoryItem,
                           WXSubCategoryNotificationKey : categorySubTitle
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:WXCategoryNotification object:nil userInfo:dict];
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
