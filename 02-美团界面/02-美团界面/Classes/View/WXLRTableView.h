//
//  WXLRTableView.h
//  02-美团界面
//
//  Created by 李伟雄 on 16/1/6.
//  Copyright © 2016年 Liwx. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - WXLRTableViewDataSource 数据源协议

@class WXLRTableView;
@protocol WXLRTableViewDataSource <NSObject>

#pragma mark - required 必须实现的数据源
@required
/** 返回左边tableView总共展示多少行 */
- (NSInteger)numOfRowsInLeftTableView:(WXLRTableView *)lrTableView;
/** 返回左边tableView某行显示的标题 */
- (NSString *)lrTableView:(WXLRTableView *)lrTableView titleInLeftRow:(NSInteger)leftRow;
/** 返回左边tableView某行的子标题 */
- (NSArray *)lrTableView:(WXLRTableView *)lrTableView subTitleInLeftRow:(NSInteger)leftRow;

#pragma mark - optional 可选实现的数据源
@optional
/** 返回左边某行显示的普通图标 */
- (NSString *)lrTableView:(WXLRTableView *)lrTableView iconInLeftRow:(NSInteger)leftRow;
/** 返回左边某行显示的高亮图标 */
- (NSString *)lrTableView:(WXLRTableView *)lrTableView highIconInLeftRow:(NSInteger)leftRow;

@end

#pragma mark - WXLRTableViewDataDelegate
@protocol WXLRTableViewDataDelegate <NSObject>

@optional
/** 点击左边告诉代理左边点击了第几行 */
- (void)lrTableView:(WXLRTableView *)lrTableView selectedLeftRow:(NSInteger)leftRow;

/** 点击右边告诉代理左边点击了第几行,右边点击了第几行 */
- (void)lrTableView:(WXLRTableView *)lrTableView selectedLeftRow:(NSInteger)leftRow selectedRightRow:(NSInteger)rightRow;

@end

@interface WXLRTableView : UIView

/** 快速创建WXLRTableView类方法 */
+ (instancetype)lrTableView;

/** 数据源属性 */
@property (nonatomic, weak) id<WXLRTableViewDataSource> dataSource;

/** 代理属性 */
@property (weak, nonatomic) id<WXLRTableViewDataDelegate> delegate;

@end
