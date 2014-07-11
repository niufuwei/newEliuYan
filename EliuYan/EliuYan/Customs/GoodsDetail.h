//
//  GoodsDetail.h
//  ELiuYan
//
//  Created by shanchen on 14-4-29.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsDetail : NSObject


@property(nonatomic,strong)NSString *totalCount;//总记录数
@property(nonatomic,strong)NSString *totalPage;//总页数
@property(nonatomic,strong)NSString *goodsId;//商品编号
@property(nonatomic,strong)NSString *goodsName;//商品名称
@property(nonatomic,strong)NSString *logoImage;//商品图片
@property(nonatomic,strong)NSString *price;//商品价格
@property (nonatomic,strong)NSString * storeID;




@end
