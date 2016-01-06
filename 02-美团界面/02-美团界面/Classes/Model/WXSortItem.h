//
//  WXSortItem.h
//  02-美团界面
//
//  Created by 李伟雄 on 16/1/6.
//  Copyright © 2016年 Liwx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXSortItem : NSObject

/** 显示的文字 */
@property (nonatomic ,copy)NSString *label;
/** 上传服务器的值 */
@property (nonatomic ,strong)NSNumber *value;

@end
