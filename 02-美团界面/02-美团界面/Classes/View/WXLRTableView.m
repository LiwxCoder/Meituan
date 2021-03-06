//
//  WXLRTableView.m
//  02-美团界面
//
//  Created by 李伟雄 on 16/1/6.
//  Copyright © 2016年 Liwx. All rights reserved.
//

#import "WXLRTableView.h"
#import "WXLeftCell.h"
#import "WXRightCell.h"

@interface WXLRTableView () <UITableViewDataSource, UITableViewDelegate>

#pragma mark - subViews
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

#pragma mark - 属性
/** 左边leftTableView当前选中行 */
@property (nonatomic, assign) NSInteger selectedLeftRow;
/** 子标题数组 */
@property (nonatomic, strong) NSArray *subTitles;

@end

@implementation WXLRTableView

#pragma mark - setUp

+ (instancetype)lrTableView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpLRTableView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setUpLRTableView];
}

/** 初始化leftTableView和rightTableView设置数据源和代理 */
- (void)setUpLRTableView
{
    // 设置数据源和代理
    self.leftTableView.dataSource = self;
    self.rightTableView.dataSource = self;
    self.leftTableView.delegate = self;
    self.rightTableView.delegate = self;
    
    // SINGLE: 取消分割线
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
// REMARKS: 双TableView的仿系统TableView实现(由外部提供数据源,并通过代理实现外部监听TableView的操作)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTableView) {
        // 返回左边leftTableView的总行数
        return [self.dataSource numOfRowsInLeftTableView:self];
    }else {
        // 返回右边rightTableView的总行数
        return self.subTitles.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (tableView == self.leftTableView) {
        // 设置左边cell的数据
        cell = [WXLeftCell leftCellWithTableView:tableView];
        NSString *title = [self.dataSource lrTableView:self titleInLeftRow:indexPath.row];
        
        // 设置cell的文字
        cell.textLabel.text = title;
        // 设置cell的图标
        if ([self.dataSource respondsToSelector:@selector(lrTableView:iconInLeftRow:)]) {
            NSString *iconName = [self.dataSource lrTableView:self iconInLeftRow:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:iconName];
        }
        // 设置cell选中时显示的图标
        if ([self.dataSource respondsToSelector:@selector(lrTableView:highIconInLeftRow:)]) {
            NSString *highIconName = [self.dataSource lrTableView:self highIconInLeftRow:indexPath.row];
            // SINGLE: 设置cell选中时的图标
            cell.imageView.highlightedImage = [UIImage imageNamed:highIconName];
        }
        
    }else {
        // 设置右边cell的数据
        cell = [WXRightCell rightCellWithTableView:tableView];
        cell.textLabel.text = self.subTitles[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        // 1.记录左边leftTableView选中行
        self.selectedLeftRow = indexPath.row;
        // 2.获取当前选中行的子标题数据
        self.subTitles = [self.dataSource lrTableView:self subTitleInLeftRow:indexPath.row];
        // 3.刷新右边rightTableView的数据
        [self.rightTableView reloadData];
        // 4.调用左边leftTableView选中时调用的代理方法
        if ([self.delegate respondsToSelector:@selector(lrTableView:selectedLeftRow:)]) {
            [self.delegate lrTableView:self selectedLeftRow:indexPath.row];
        }
        
    }else {
        // 1.调用右边rightTableView选中时调用的代理方法
        if ([self.delegate respondsToSelector:@selector(lrTableView:selectedLeftRow:selectedRightRow:)]) {
            [self.delegate lrTableView:self selectedLeftRow:self.selectedLeftRow selectedRightRow:indexPath.row];
        }
    }
}

@end
