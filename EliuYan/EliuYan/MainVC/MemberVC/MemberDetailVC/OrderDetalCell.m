//
//  OrderDetalCell.m
//  ELiuYan
//
//  Created by eliuyan_mac on 14-5-2.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "OrderDetalCell.h"

@implementation OrderDetalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _goodsImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 55, 55)];
        [self addSubview:_goodsImage];
        
        _description = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 230, 40)];
        _description.font = [UIFont systemFontOfSize:16.0];
        [_description setNumberOfLines:2];
        _description.backgroundColor = [UIColor clearColor];

        _description.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_description];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, 80, 12)];
        _moneyLabel.textColor = [UIColor redColor];
        _moneyLabel.font = [UIFont systemFontOfSize:14.0];
        _moneyLabel.backgroundColor = [UIColor clearColor];

        [self addSubview:_moneyLabel];
        
        
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(270, 50, 50, 12)];
        _countLabel.textColor = [UIColor grayColor];
        _countLabel.backgroundColor = [UIColor clearColor];

        _countLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_countLabel];

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
