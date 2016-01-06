//
//  WXSortController.m
//  02-美团界面
//
//  Created by 李伟雄 on 16/1/6.
//  Copyright © 2016年 Liwx. All rights reserved.
//

#import "WXSortController.h"
#import "WXSortItem.h"
#import "WXConst.h"
#import <MJExtension.h>

@interface WXSortController ()

/** 排序数据源数组 */
@property (nonatomic, strong) NSArray *sortArray;

/** 当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;

@end

@implementation WXSortController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 2.初始化Button
    [self setupSortButton];
}

#pragma mark - setup
/** 初始化Button */
- (void)setupSortButton
{
    // 获取数据总数
    NSInteger count = self.sortArray.count;
    
    // Button的尺寸,间距
    CGFloat leftMargin = 20;
    CGFloat topMargin = 10;
    CGFloat width = 140;
    CGFloat height = 40;
    CGFloat x = leftMargin;
    CGFloat y = 0;
    
    // 1.计算Button的位置,并设置Button的frame
    for (NSInteger i = 0; i < count; i++) {
        // 1.1 取出数据
        WXSortItem *item = self.sortArray[i];
        // 1.2 设置button的tag和title,titleColor,设置按钮背景
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setTitle:item.label forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateSelected];
        
        // 监听按钮按下事件
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        
        // 1.3 计算y值
        y = topMargin + (i * (topMargin + height));
        // 1.4 设置button的frame
        button.frame = CGRectMake(x, y, width, height);
        
        // 1.5 将按钮添加到控制器的view
        [self.view addSubview:button];
    }
    
    // SINGLE: 2.设置内容控制器的frame
    self.preferredContentSize = CGSizeMake((width + 2 * leftMargin), (topMargin + (height + topMargin) * count));
}

#pragma mark - Event
- (void)buttonClick:(UIButton *)button
{
    // 1.切换按钮选中状态
    self.selectedButton.selected = NO;
    self.selectedButton = button;
    self.selectedButton.selected = YES;
    
    // 2.取出选中按钮的数据
    WXSortItem *item = self.sortArray[self.selectedButton.tag];
    
    // 3.发送通知,传递数据给外部控制器,用于刷新排序Item的文字信息
    NSDictionary *dict = @{WXSortNotificationKey : item};
    [[NSNotificationCenter defaultCenter] postNotificationName:WXSortNotification object:nil userInfo:dict];
}

#pragma mark - Lazy Load
- (NSArray *)sortArray
{
    if (_sortArray == nil) {
        _sortArray = [WXSortItem mj_objectArrayWithFilename:@"sorts.plist"];
    }
    return _sortArray;
}


@end
