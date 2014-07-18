//
//  tabbarViewController.m
//  artists
//
//  Created by niufuwei on 13-12-15.
//  Copyright (c) 2013年 niufuwei. All rights reserved.
//

#import "tabbarViewController.h"
#import "AppDelegate.h"

@interface tabbarViewController ()

@end

@implementation tabbarViewController
{
    AppDelegate *app;
  
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)createCustomTabBar
{
    _tabbarBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-49, 320, 49)];
   
//    tabbarBG.image = [UIImage imageNamed:@"ground_bar.png"];
  
    
    _tabbarBG.userInteractionEnabled = YES;
    [self.view addSubview:_tabbarBG];
    
    
    
    UIView * lineImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    lineImage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"线5.png"]];
    [_tabbarBG addSubview:lineImage];
    
    
//    itemBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabbar_item_selected.png"]];
    [_tabbarBG addSubview:itemBG];
    
    homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    homeBtn.tag = 0;
    homeBtn.frame = CGRectMake(0.0, 0.0, 106.5, 49.0);
    [homeBtn setImage:[UIImage imageNamed:@"首页菜单栏-选中 (1).png"] forState:UIControlStateNormal];
//    [homeBtn setBackgroundImage:[UIImage imageNamed:@"首页菜单栏-选中 (1).png"] forState:UIControlStateNormal];
//    [homeBtn setTitle:@"社区购物" forState:UIControlStateNormal];
//    [homeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[homeBtn setTitleColor:[UIColor colorWithRed:235.0/255.0 green:81.0/255.0 blue:17.0/255.0 alpha:1] forState:UIControlStateSelected];
//    homeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    //[homeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -29, -30, 0)];
    //[homeBtn setImageEdgeInsets:UIEdgeInsetsMake(-11, 25, 0, 18)];
    [homeBtn addTarget:self action:@selector(homeBtn_Click:) forControlEvents:UIControlEventTouchUpInside];
    homeBtn.selected = YES;
    currentPage =0;
    homeBtn.adjustsImageWhenHighlighted = FALSE;
    
    itemBG.frame = CGRectMake(0, 0, 80, 49);
    [_tabbarBG addSubview:homeBtn];
//    [homeBtn setBackgroundColor:[UIColor colorWithRed:37.0/255 green:73.0/255 blue:157.0/255 alpha:1.0]];
    
    
    
    myTaobaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myTaobaoBtn.tag = 1;
    myTaobaoBtn.frame = CGRectMake(106.5, 0.0, 106.5, 49.0);
    [myTaobaoBtn setImage:[UIImage imageNamed:@"首页菜单栏-未选 (2).png"] forState:UIControlStateNormal];
//    [myTaobaoBtn setTitle:@"社区服务" forState:UIControlStateNormal];
//    [myTaobaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[myTaobaoBtn setTitleColor:[UIColor colorWithRed:235.0/255.0 green:81.0/255.0 blue:17.0/255.0 alpha:1] forState:UIControlStateSelected];
//    myTaobaoBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    //[myTaobaoBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -29, -30, 0)];
    //[myTaobaoBtn setImageEdgeInsets:UIEdgeInsetsMake(-11, 25, 0, 18)];
    
    myTaobaoBtn.adjustsImageWhenHighlighted = FALSE;
    [myTaobaoBtn addTarget:self action:@selector(myTaobaoBtn_Click:) forControlEvents:UIControlEventTouchUpInside];
    [_tabbarBG addSubview:myTaobaoBtn];
//    [myTaobaoBtn setBackgroundColor:[UIColor colorWithRed:52.0/255 green:169.0/255 blue:220.0/255 alpha:1.0]];
    
    
    _cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cartBtn.tag = 2;
    _cartBtn.frame = CGRectMake(106.5*2, 0.0, 107, 49.0);
    [_cartBtn setImage:[UIImage imageNamed:@"首页菜单栏-未选 (3).png"] forState:UIControlStateNormal];
    //[_cartBtn set Title:@"我的" forState:UIControlStateNormal];
    //[_cartBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    //[cartBtn setTitleColor:[UIColor colorWithRed:235.0/255.0 green:81.0/255.0 blue:17.0/255.0 alpha:1] forState:UIControlStateSelected];
    //_cartBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    //[cartBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -27, -30, 0)];
    //[cartBtn setImageEdgeInsets:UIEdgeInsetsMake(-11, 25, 0, 18)];
    [_cartBtn addTarget: self action:@selector(cartBtn_Click:) forControlEvents:UIControlEventTouchUpInside];
    _cartBtn.adjustsImageWhenHighlighted = FALSE;

    [_tabbarBG addSubview:_cartBtn];
//    [_cartBtn setBackgroundColor:[UIColor colorWithRed:52.0/255 green:169.0/255 blue:220.0/255 alpha:1.0]];

    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 8, 15, 15)];
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.layer.cornerRadius = 7.5;
    _countLabel.layer.masksToBounds = YES;
    _countLabel.tag = 3;
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.font=[UIFont systemFontOfSize:12];
    _countLabel.backgroundColor = [UIColor redColor];
    _countLabel.hidden = YES;
    [_cartBtn addSubview:_countLabel];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"allCount"] intValue] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogIn"] isEqualToString:@"1"])
    {
        self.countLabel.hidden = NO;
        self.countLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"allCount"];
    }
    else
    {
    
        self.countLabel.hidden = YES;
        
    
    }
    
    
    
   
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tabBar.hidden = YES;
    //[self.tabBar removeFromSuperview];
    app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAllCount:) name:@"changeAllCount" object:nil];
    
    [self createCustomTabBar];
}
-(void)changeAllCount:(NSNotification*)sender
{


    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"allCount"] intValue] > 0)
    {
        self.countLabel.hidden = NO;
        self.countLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"allCount"];
    }
    else
    {
    
    
        self.countLabel.hidden = YES;
    
    }
    


}

- (void)homeBtn_Click:(UIButton *)button
{
    if(currentPage ==0)
    {
        
    }
    else
    {
        currentPage =0;
        homeBtn.selected = YES;
        myTaobaoBtn.selected = NO;
        _cartBtn.selected = NO;
        
        itemBG.frame = CGRectMake(0, 0, 80, 49);
        self.selectedIndex = button.tag;
        
        [homeBtn setImage:[UIImage imageNamed:@"首页菜单栏-选中 (1).png"] forState:UIControlStateNormal];
        [myTaobaoBtn setImage:[UIImage imageNamed:@"首页菜单栏-未选 (2).png"] forState:UIControlStateNormal];
        [_cartBtn setImage:[UIImage imageNamed:@"首页菜单栏-未选 (3).png"] forState:UIControlStateNormal];
    }
    
//    [homeBtn setBackgroundColor:[UIColor colorWithRed:37.0/255 green:73.0/255 blue:157.0/255 alpha:1.0]];
//    
//    [myTaobaoBtn setBackgroundColor:[UIColor colorWithRed:52.0/255 green:169.0/255 blue:220.0/255 alpha:1.0]];
//    [_cartBtn setBackgroundColor:[UIColor colorWithRed:52.0/255 green:169.0/255 blue:220.0/255 alpha:1.0]];
    
}

- (void)myTaobaoBtn_Click:(UIButton *)button
{
    if(currentPage ==1)
    {
        
    }
    else
    {
        currentPage =1;
        homeBtn.selected = NO;
        myTaobaoBtn.selected = YES;
        _cartBtn.selected = NO;
        itemBG.frame = CGRectMake(80, 0, 80, 49);
        self.selectedIndex = button.tag;
        
        [homeBtn setImage:[UIImage imageNamed:@"首页菜单栏-未选 (1).png"] forState:UIControlStateNormal];
        [myTaobaoBtn setImage:[UIImage imageNamed:@"首页菜单栏-选中 (2).png"] forState:UIControlStateNormal];
        [_cartBtn setImage:[UIImage imageNamed:@"首页菜单栏-未选 (3).png"] forState:UIControlStateNormal];
    }
    //[myTaobaoBtn setBackgroundColor:[UIColor colorWithRed:37.0/255 green:73.0/255 blue:157.0/255 alpha:1.0]];
    
//    [homeBtn setBackgroundColor:[UIColor colorWithRed:52.0/255 green:169.0/255 blue:220.0/255 alpha:1.0]];
//    [_cartBtn setBackgroundColor:[UIColor colorWithRed:52.0/255 green:169.0/255 blue:220.0/255 alpha:1.0]];

}

- (void)cartBtn_Click:(UIButton *)button
{
    if(currentPage ==2)
    {
        
    }
    else
    {
        currentPage = 2;
        homeBtn.selected = NO;
        myTaobaoBtn.selected = NO;
        _cartBtn.selected = YES;
        itemBG.frame = CGRectMake(80*2, 0, 80, 49);
        self.selectedIndex = button.tag;
        
        [homeBtn setImage:[UIImage imageNamed:@"首页菜单栏-未选 (1).png"] forState:UIControlStateNormal];
        [myTaobaoBtn setImage:[UIImage imageNamed:@"首页菜单栏-未选 (2).png"] forState:UIControlStateNormal];
        [_cartBtn setImage:[UIImage imageNamed:@"首页菜单栏-选中 (3).png"] forState:UIControlStateNormal];
    }
//    [_cartBtn setBackgroundColor:[UIColor colorWithRed:37.0/255 green:73.0/255 blue:157.0/255 alpha:1.0]];
    
//    [itemBG setImage:[UIImage imageNamed:@"ground_bar.png"]];
//    
//    [myTaobaoBtn setBackgroundColor:[UIColor colorWithRed:52.0/255 green:169.0/255 blue:220.0/255 alpha:1.0]];
//    [homeBtn setBackgroundColor:[UIColor colorWithRed:52.0/255 green:169.0/255 blue:220.0/255 alpha:1.0]];
}

- (void)showTabBar
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35];
    _tabbarBG.frame = CGRectMake(0, self.view.frame.size.height-49, 320, 49);
    [UIView commitAnimations];
}
- (void)hideTabBar
{
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35];
    _tabbarBG.frame = CGRectMake(0, self.view.frame.size.height, 320, 49);
    [UIView commitAnimations];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
