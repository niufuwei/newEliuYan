//
//  MessageCell.h
//  ELiuYan
//
//  Created by eliuyan_mac on 14-5-3.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell
{

    UILabel *_contentLabel;
    UILabel *_timeLabel;
    //UIImageView *_lineImageView;

}
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@end
