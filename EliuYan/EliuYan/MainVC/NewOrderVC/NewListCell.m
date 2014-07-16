//
//  NewListCell.m
//  ELiuYan
//
//  Created by apple on 14-4-27.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "NewListCell.h"

@implementation NewListCell
@synthesize title;
@synthesize ICON;
@synthesize money;
@synthesize num;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //初始化图片
        ICON =[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 55, 55)] ;
        [self addSubview:ICON];
        
        //初始化标题
        title = [[UILabel alloc ] initWithFrame:CGRectMake(ICON.frame.size.width+ICON.frame.origin.x+18, 5, 200,40)] ;
        title.font = [UIFont systemFontOfSize:16];
        title.lineBreakMode = NSLineBreakByWordWrapping;
        title.numberOfLines = 0;
        title.backgroundColor = [UIColor clearColor];
        title.textColor = eliuyan_color(0x404040);
        [self addSubview:title];
        
        money = [[UILabel alloc] initWithFrame:CGRectMake(ICON.frame.size.width+ICON.frame.origin.x+18, title.frame.size.height+title.frame.origin.y+3, 100, 17)] ;
        money.backgroundColor = [UIColor clearColor];
        money.font = [UIFont systemFontOfSize:14];
        money.textColor=[UIColor redColor];
        [self addSubview:money];
        
        num = [[UILabel alloc] initWithFrame:CGRectMake(money.frame.size.width+money.frame.origin.x+100, title.frame.size.height+title.frame.origin.y+3, 50, 17)] ;
        num.backgroundColor = [UIColor clearColor];
        num.font = [UIFont systemFontOfSize:14];
        num.textColor=eliuyan_color(0xababaa);
        [self addSubview:num];
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
