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

@property(nonatomic,strong)UIView *navView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIButton *returnBtn;
@property(nonatomic,strong)UIView *orderView;
@property(nonatomic,strong)UIButton *accountBtn;
@property (nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UILabel *countLab;


@end
