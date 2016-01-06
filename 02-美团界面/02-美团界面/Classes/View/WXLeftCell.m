//
//  WXLeftCell.m
//  02-美团界面
//
//  Created by 李伟雄 on 16/1/6.
//  Copyright © 2016年 Liwx. All rights reserved.
//

#import "WXLeftCell.h"

@implementation WXLeftCell


/** 通过tableView快速创建cell */
+ (instancetype)leftCellWithTableView:(UITableView *)tableView
{
    static NSString *leftCellID = @"leftCell";
    // 从缓冲池取出cell
    WXLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:leftCellID];
    
    // 判断缓冲池是否有cell
    if (cell == nil) {
        cell = [[WXLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftCellID];
    }
    return cell;
}

/** 初始化cell设置 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // SINGLE: 设置cell 普通/选中状态的背景图片
        UIImage *norImage = [UIImage imageNamed:@"bg_dropdown_leftpart"];
        self.backgroundView = [[UIImageView alloc] initWithImage:norImage];
        UIImage *highImage = [UIImage imageNamed:@"bg_dropdown_left_selected"];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:highImage];
    }
    return self;
}

@end
