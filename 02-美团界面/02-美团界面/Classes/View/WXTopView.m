//
//  WXTopView.m
//  02-美团界面
//
//  Created by 李伟雄 on 16/1/6.
//  Copyright © 2016年 Liwx. All rights reserved.
//

#import "WXTopView.h"

@interface WXTopView ()
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 小标题 */
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
/** 显示图标 */
@property (weak, nonatomic) IBOutlet UIButton *iconButton;

@end

@implementation WXTopView

/** 快速创建类方法 */
+ (instancetype)topView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

/** 设置标题 */
- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}
/** 设置子标题 */
- (void)setSubtitle:(NSString *)subTitle
{
    self.subTitleLabel.text = subTitle;
}
/** 设置普通/选中高亮状态的图标 */
- (void)setIcon:(NSString *)icon highIcon:(NSString *)highIcon
{
    [self.iconButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [self.iconButton setImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
}

/** 给iconButton设置监听者 */
- (void)addTarget:(id)target action:(SEL)action
{
    [self.iconButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
