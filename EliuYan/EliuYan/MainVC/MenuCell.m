//
//  MenuCell.m
//  EliuYan
//
//  Created by laoniu on 14-7-4.
//  Copyright (c) 2014年 eliuyan.com. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell
@synthesize MenuName;
@synthesize number;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        MenuName = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 90,40)];
        MenuName.font = [UIFont systemFontOfSize:13];
        MenuName.textAlignment = NSTextAlignmentCenter;
        MenuName.textColor = [UIColor blackColor];
        MenuName.numberOfLines = 0;
        MenuName.lineBreakMode = NSLineBreakByWordWrapping;
        MenuName.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:MenuName];
        
        number = [[UIButton alloc] initWithFrame:CGRectMake(90-15, 3, 15, 15)];
        number.titleLabel.font = [UIFont systemFontOfSize:10];
        number.backgroundColor = [UIColor redColor];
        [number setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [number.layer setCornerRadius:8];
        
        [self.contentView addSubview:number];
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
