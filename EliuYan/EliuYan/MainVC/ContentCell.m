//
//  ContentCell.m
//  EliuYan
//
//  Created by laoniu on 14-7-4.
//  Copyright (c) 2014年 eliuyan.com. All rights reserved.
//

#import "ContentCell.h"

@implementation ContentCell
@synthesize title;
@synthesize logoImage;
@synthesize selectButton;
@synthesize money;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 60, 60)];
        [self addSubview:logoImage];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(logoImage.frame.size.width+logoImage.frame.origin.x+5, 15, 100, 40)];
        title.backgroundColor = [UIColor clearColor];
        title.textAlignment = NSTextAlignmentLeft;
        title.font= [UIFont systemFontOfSize:14];
        title.numberOfLines = 0;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:title];
        
        money = [[UILabel alloc] initWithFrame:CGRectMake(logoImage.frame.size.width+logoImage.frame.origin.x+5, title.frame.origin.y+title.frame.size.height, 100, 20)];
        money.backgroundColor = [UIColor clearColor];
        money.textAlignment = NSTextAlignmentLeft;
        money.font= [UIFont systemFontOfSize:14];
        money.numberOfLines = 0;
        money.lineBreakMode = NSLineBreakByWordWrapping;
        money.textColor = [UIColor colorWithRed:233.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1];
        [self addSubview:money];
        
        selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectButton.frame = CGRectMake(180, 30, 30, 30);
        [self addSubview:selectButton];
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
