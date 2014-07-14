//
//  GoodsTableViewCell.h
//  ELiuYan
//
//  Created by shanchen on 14-4-25.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *logoImage;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIButton *minusBtn;
@property (strong, nonatomic) IBOutlet UIButton *plaseBtn;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;




@property (strong, nonatomic) IBOutlet UIButton *jinButton;
@property (strong, nonatomic) IBOutlet UIButton *geButton;


@property (strong, nonatomic) IBOutlet UIImageView *detailImage;

@property (strong, nonatomic) IBOutlet UILabel *detailCount;



@end
