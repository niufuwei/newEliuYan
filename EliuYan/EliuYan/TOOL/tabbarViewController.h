//
//  tabbarViewController.h
//  artists
//
//  Created by niufuwei on 13-12-15.
//  Copyright (c) 2013年 niufuwei. All rights reserved.
//
//店铺诊断页面的 tabbar 的初始化
#import <UIKit/UIKit.h>

@interface tabbarViewController : UITabBarController
{
//@private
    UIButton *homeBtn;
    UIButton *myTaobaoBtn;
    UIButton *_cartBtn;
    UIButton *weitaoBtn;
    
    UIImageView *_tabbarBG;
    UIImageView *itemBG;
    UILabel * _countLabel;
    int currentPage;
    int _count;
}
@property (nonatomic,strong) UIImageView *tabbarBG;
@property (nonatomic,strong) UIButton *cartBtn;
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,assign) int count;
- (void)createCustomTabBar;
- (void)showTabBar;
- (void)hideTabBar;
@end
