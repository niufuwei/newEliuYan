//
//  StoreCell.h
//  ELiuYan
//
//  Created by shanchen on 14-4-24.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreCell : UITableViewCell




@property (strong, nonatomic) IBOutlet UIImageView *logoImage;//店铺LoGo,
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;//店铺名称
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;//店铺类型
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;//当前位置与店铺的距离
@property (strong, nonatomic) IBOutlet UILabel *minBuy;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;


@end
