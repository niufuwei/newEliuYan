//
//  OldAddressCell.m
//  ELiuYan
//
//  Created by laoniu on 14-5-1.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "OldAddressCell.h"

@implementation OldAddressCell
@synthesize Address;
@synthesize AddressInformation;
@synthesize choose;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        Address =[[UILabel alloc] initWithFrame:CGRectMake(15, 10, 290-50, 15)];
        Address.textColor = eliuyan_color(0xababaa);
        Address.font = [UIFont systemFontOfSize:15];
        [Address setBackgroundColor:[UIColor clearColor]];
        [self addSubview:Address];
        
        AddressInformation =[[UILabel alloc] initWithFrame:CGRectMake(15, Address.frame.size.height+Address.frame.origin.y, 290-50, 40)];
        AddressInformation.textColor = eliuyan_color(0x404040);
        AddressInformation.numberOfLines = 2;
        AddressInformation.font = [UIFont systemFontOfSize:17];
        AddressInformation.adjustsFontSizeToFitWidth = YES;
        [AddressInformation setBackgroundColor:[UIColor clearColor]];
        [self addSubview:AddressInformation];
        
        choose = [UIButton buttonWithType:UIButtonTypeCustom];
        choose.frame = CGRectMake(320- 15-28, 77/2-14, 28, 28);
        [self addSubview:choose];
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(15, 77-1, 290, 1)];
        [image setBackgroundColor:eliuyan_color(0xe2dfd7)];
        [self addSubview:image];
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
