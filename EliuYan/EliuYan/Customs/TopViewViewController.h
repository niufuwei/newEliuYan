//
//  TopViewViewController.h
//  ELiuYan
//
//  Created by shanchen on 14-4-23.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopViewViewController : UIViewController


{
    UIView *_navView;
    UILabel *_nameLabel;
    UIButton *_returnBtn;
    
    UIView *_orderView;
    UILabel *_priceLabel;
    UIButton *_accountBtn;
    
}

@property(nonatomic,retain)UIView *navView;
@property(nonatomic,retain)UILabel *nameLabel;
@property(nonatomic,retain)UIButton *returnBtn;
@property(nonatomic,retain)UIView *orderView;
@property(nonatomic,retain)UIButton *accountBtn;
@property (nonatomic,retain)UILabel *priceLabel;
@property(nonatomic,retain)UILabel *countLab;


@end
