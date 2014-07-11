//
//  ContentCell.h
//  EliuYan
//
//  Created by laoniu on 14-7-4.
//  Copyright (c) 2014年 eliuyan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentCell : UITableViewCell
@property (nonatomic,strong) UIImageView * logoImage;
@property (nonatomic,strong) UILabel * title;
@property (nonatomic,strong) UILabel * money;
@property (nonatomic,strong) UIButton * selectButton;

@end
