//
//  WXCategoryController.m
//  02-美团界面
//
//  Created by 李伟雄 on 16/1/6.
//  Copyright © 2016年 Liwx. All rights reserved.
//

#import "WXCategoryController.h"
#import "WXLRTableView.h"

@interface WXCategoryController ()

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
}

@end
