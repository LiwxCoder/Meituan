//
//  WXDistrictController.m
//  02-美团界面
//
//  Created by 李伟雄 on 16/1/6.
//  Copyright © 2016年 Liwx. All rights reserved.
//

#import "WXDistrictController.h"
#import "WXDistrictItem.h"
#import "WXLRTableView.h"
#import "WXConst.h"
#import <MJExtension.h>

@interface WXDistrictController () <WXLRTableViewDataSource, WXLRTableViewDataDelegate>

/** 区域的数据源 */
@property (nonatomic, strong) NSArray *districtArray;

@end

@implementation WXDistrictController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化lrTableView
    [self setupLRTableView];
}

#pragma mark - setUp
/** 初始化lrTableView */
- (void)setupLRTableView
{
    // 1.创建lrTableView,设置lrTableView属性
    WXLRTableView *lrTableView = [WXLRTableView lrTableView];
    // 1.1 设置lrTableView的frame
    lrTableView.frame = self.view.bounds;
    // 1.2 设置lrTableView跟随父控件的拉伸而拉伸
    lrTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // 1.3 设置lrTableView的代理和数据源
    lrTableView.dataSource = self;
    lrTableView.delegate = self;
    
    // 添加到当前控制器的view
    [self.view addSubview:lrTableView];
}

#pragma mark - <WXLRTableViewDataSource, WXLRTableViewDataDelegate>
/** 返回左边tableView总共展示多少行 */
- (NSInteger)numOfRowsInLeftTableView:(WXLRTableView *)lrTableView
{
    return self.districtArray.count;
}

/** 返回左边tableView某行显示的标题 */
- (NSString *)lrTableView:(WXLRTableView *)lrTableView titleInLeftRow:(NSInteger)leftRow
{
    WXDistrictItem *item = self.districtArray[leftRow];
    return item.name;
}

/** 返回左边tableView某行的子标题 */
- (NSArray *)lrTableView:(WXLRTableView *)lrTableView subTitleInLeftRow:(NSInteger)leftRow
{
    WXDistrictItem *item = self.districtArray[leftRow];
    return item.subregions;
}

/** 点击右边告诉代理左边点击了第几行,右边点击了第几行 */
- (void)lrTableView:(WXLRTableView *)lrTableView selectedLeftRow:(NSInteger)leftRow
{
    // 1.取出数据,传递给外部控制器,用来设置导航条区域Item的图标,标题,子标题
    WXDistrictItem *item = self.districtArray[leftRow];
    if (item.subregions.count == 0) {
        // 2.发送通知
        NSDictionary *dict = @{WXDistrictNotificationKey : item};
        [[NSNotificationCenter defaultCenter] postNotificationName:WXDistrictNotification object:nil userInfo:dict];
    }
}

/** 点击左边告诉代理左边点击了第几行 */
- (void)lrTableView:(WXLRTableView *)lrTableView selectedLeftRow:(NSInteger)leftRow selectedRightRow:(NSInteger)rightRow
{
    // 1.取出数据,传递给外部控制器,用来设置导航条区域Item的图标,标题,子标题
    WXDistrictItem *item = self.districtArray[leftRow];
    NSString *subTitle = item.subregions[rightRow];
    // 2.发送通知
    NSDictionary *dict = @{
                           WXDistrictNotificationKey : item,
                           WXSubDistrictNotificationKey : subTitle
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:WXDistrictNotification object:nil userInfo:dict];
    
}

#pragma mark - Lazy Load
- (NSArray *)districtArray
{
    if (_districtArray == nil) {
        _districtArray = [WXDistrictItem mj_objectArrayWithFilename:@"gz.plist"];
    }
    return _districtArray;
}


@end
