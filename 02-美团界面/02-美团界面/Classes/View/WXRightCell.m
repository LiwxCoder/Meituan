//
//  WXRightCell.m
//  02-美团界面
//
//  Created by 李伟雄 on 16/1/6.
//  Copyright © 2016年 Liwx. All rights reserved.
//

#import "WXRightCell.h"

@implementation WXRightCell

/** 通过tableView快速创建cell */
+ (instancetype)rightCellWithTableView:(UITableView *)tableView
{
    static NSString *rightCellID = @"rightCell";
    // 从缓冲池取出cell
    WXRightCell *cell = [tableView dequeueReusableCellWithIdentifier:rightCellID];
    
    // 判断缓冲池是否有cell
    if (cell == nil) {
        cell = [[WXRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightCellID];
    }
    return cell;
}

/** 初始化cell设置 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置cell 普通/选中状态的背景图片
        UIImage *norImage = [UIImage imageNamed:@"bg_dropdown_rightpart"];
        self.backgroundView = [[UIImageView alloc] initWithImage:norImage];
        UIImage *highImage = [UIImage imageNamed:@"bg_dropdown_right_selected"];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:highImage];
    }
    return self;
}

@end
