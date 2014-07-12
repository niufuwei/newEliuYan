//
//  MessageCell.m
//  ELiuYan
//
//  Created by eliuyan_mac on 14-5-3.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 75)];
        
        _contentLabel.font = [UIFont systemFontOfSize:15.0];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.backgroundColor = [UIColor clearColor];

        [self addSubview:_contentLabel];
        
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _contentLabel.frame.size.height+_contentLabel.frame.origin.y, 150, 10)];
        _timeLabel.backgroundColor = [UIColor clearColor];

        _timeLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_timeLabel];
        
        

        
              
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
