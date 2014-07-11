//
//  GoodsTableViewCell.h
//  ELiuYan
//
//  Created by shanchen on 14-4-25.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsTableViewCell : UITableViewCell


@property (retain, nonatomic) IBOutlet UIImageView *logoImage;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UILabel *countLabel;
@property (retain, nonatomic) IBOutlet UIButton *minusBtn;
@property (retain, nonatomic) IBOutlet UIButton *plaseBtn;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;




@property (retain, nonatomic) IBOutlet UIButton *jinButton;
@property (retain, nonatomic) IBOutlet UIButton *geButton;


@property (retain, nonatomic) IBOutlet UIImageView *detailImage;

@property (retain, nonatomic) IBOutlet UILabel *detailCount;



@end
