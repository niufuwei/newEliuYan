//
//  OrderDetalCell.h
//  ELiuYan
//
//  Created by eliuyan_mac on 14-5-2.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetalCell : UITableViewCell
{

    UIImageView *_goodsImage;
    UILabel *_description ;
    UILabel *_moneyLabel;
    UILabel *_countLabel;

}
@property (nonatomic,strong)UIImageView *goodsImage;
@property (nonatomic,strong)UILabel *description ;
@property (nonatomic,strong)UILabel *moneyLabel;
@property (nonatomic,strong)UILabel *countLabel;
@end
