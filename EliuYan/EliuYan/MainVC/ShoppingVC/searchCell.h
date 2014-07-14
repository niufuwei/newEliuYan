//
//  searchCell.h
//  EliuYan
//
//  Created by laoniu on 14-7-1.
//  Copyright (c) 2014年 eliuyan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchCell : UITableViewCell
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
