//
//  WXCategoryItem.h
//  02-美团界面
//
//  Created by 李伟雄 on 16/1/6.
//  Copyright © 2016年 Liwx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXCategoryItem : NSObject

@property (nonatomic ,copy)NSString *highlighted_icon;
@property (nonatomic ,copy)NSString *icon;
@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)NSString *small_highlighted_icon;
@property (nonatomic ,copy)NSString *small_icon;
@property (nonatomic ,copy)NSString *map_icon;
/** 子分类*/
@property (nonatomic ,strong)NSArray *subcategories;

@end
