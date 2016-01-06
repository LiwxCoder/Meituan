//
//  WXDistrict.h
//  02-美团界面
//
//  Created by 李伟雄 on 16/1/6.
//  Copyright © 2016年 Liwx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXDistrictItem : NSObject
/** 区域名称 */
@property (nonatomic ,copy)NSString *name;
/** 子区域名称 */
@property (nonatomic ,strong)NSArray *subregions;

@end
