//
//  WXTopView.h
//  02-美团界面
//
//  Created by 李伟雄 on 16/1/6.
//  Copyright © 2016年 Liwx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXTopView : UIView

/** 快速创建类方法 */
+ (instancetype)topView;
/** 设置标题 */
- (void)setTitle:(NSString *)title;
/** 设置子标题 */
- (void)setSubtitle:(NSString *)subTitle;
/** 设置普通/选中高亮状态的图标 */
- (void)setIcon:(NSString *)icon highIcon:(NSString *)highIcon;
/** 给iconButton设置监听者 */
- (void)addTarget:(id)target action:(SEL)action;

@end
