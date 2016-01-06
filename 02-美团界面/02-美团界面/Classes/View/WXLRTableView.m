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
}

// TODO: 写到这里

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTableView) {
        return 10;
    }else {
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (tableView == self.leftTableView) {
        cell = [WXLeftCell leftCellWithTableView:tableView];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld. 左边cell", indexPath.row];
    }else {
        cell = [WXRightCell rightCellWithTableView:tableView];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld. 右边cell", indexPath.row];
    }
    return cell;
}

@end
