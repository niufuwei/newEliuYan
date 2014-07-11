//
//  BuyShopping.h
//  ELiuYan
//
//  Created by shanchen on 14-4-25.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyShopping : NSObject


@property(nonatomic,strong)NSString *delivery;//当前位置与店铺的距离
@property(nonatomic,strong)NSString *storeId;//店铺编号
@property(nonatomic,strong)NSString *logUrl;//店铺LoGo
@property(nonatomic,strong)NSString *storeTypeName;//店铺类型
@property(nonatomic,strong)NSString *storeName;//店铺名称
@property(nonatomic,strong)NSString *minBuy;//起送价格
@property (nonatomic,strong)NSString * address;
@property (nonatomic,strong) NSString * phone;
@property (nonatomic,strong) NSString * strattime;
@property (nonatomic,strong) NSString * stopTime;
@property (nonatomic,strong) NSString *storeType;
@property (nonatomic,strong) NSString *description;


@end
