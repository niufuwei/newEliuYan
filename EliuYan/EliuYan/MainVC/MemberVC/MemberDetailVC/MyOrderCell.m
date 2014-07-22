//
//  MyOrderCell.m
//  ELiuYan
//
//  Created by eliuyan_mac on 14-4-28.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "MyOrderCell.h"

@implementation MyOrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 80, 20)];
        _label1.text = @"订单编号:";
        _label1.backgroundColor = [UIColor clearColor];
        _label1.font = [UIFont systemFontOfSize:15.0];
        _label1.textColor = [UIColor grayColor];
        [self addSubview:_label1];
        
        
        _orderNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 200, 20)];
        _orderNumberLabel.font = [UIFont systemFontOfSize:15.0];
        _orderNumberLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_orderNumberLabel];
        
        
        _label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, 80, 20)];
        _label2.text = @"订单金额:";
        _label2.backgroundColor = [UIColor clearColor];
        _label2.font = [UIFont systemFontOfSize:15.0];
        _label2.textColor = [UIColor grayColor];

        [self addSubview:_label2];
        
        _orderMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 25, 120, 20)];
//        _orderMoneyLabel.textColor=[UIColor grayColor];
//        _orderMoneyLabel.textAlignment=YES;
        _orderMoneyLabel.font = [UIFont systemFontOfSize:15.0];
        _orderMoneyLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_orderMoneyLabel];
        
        
        
        _label3 = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 80, 20)];
        _label3.text = @"订单状态:";
        _label3.backgroundColor = [UIColor clearColor];
        _label3.font = [UIFont systemFontOfSize:15.0];
        _label3.textColor = [UIColor grayColor];

        [self addSubview:_label3];
        
        _orderStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, 120, 20)];
        _orderStateLabel.font = [UIFont systemFontOfSize:15.0];
        _orderStateLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_orderStateLabel];
        
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
