//
//  WXNavViewController.m
//  02-美团界面
//
//  Created by 李伟雄 on 16/1/6.
//  Copyright © 2016年 Liwx. All rights reserved.
//

#import "WXNavViewController.h"

@interface WXNavViewController ()

@end

@implementation WXNavViewController

// SINGLE: 统一设置导航条背景
+ (void)initialize
{
    // 设置导航条背景,统一设置所有的WXNavViewController的背景(不包含其子类)
    if (self == [WXNavViewController class]) {
        UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[WXNavViewController class]]];
        
        [navBar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];
    }
}

@end
