//
//  MyOrderCell.h
//  ELiuYan
//
//  Created by eliuyan_mac on 14-4-28.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderCell : UITableViewCell
{

    UILabel *_orderNumberLabel;
    UILabel *_orderMoneyLabel;
    UILabel *_orderStateLabel;

}
@property (nonatomic,strong)UILabel *orderNumberLabel;
@property (nonatomic,strong)UILabel *orderMoneyLabel;
@property (nonatomic,strong)UILabel *orderStateLabel;
@property (nonatomic,strong) UILabel *label3;
@property (nonatomic,strong) UILabel *label2;
@property (nonatomic,strong) UILabel *label1;

@end
