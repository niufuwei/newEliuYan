//
//  TopViewViewController.m
//  ELiuYan
//
//  Created by shanchen on 14-4-23.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "TopViewViewController.h"

@interface TopViewViewController ()

@end

@implementation TopViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=eliuyan_color(0xf5f5f5);

    //添加下面的结账View
    if (IOS_VERSION>=7.0) {
        _orderView=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40-44-20, 320, 40)];
    }
    else
    {
        _orderView=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40-44, 320, 40)];
    }
    
    //分割线
    UIImageView *lineImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"线4.png"]];
    lineImageView.frame=CGRectMake(0, 0, 320, 1);
    [_orderView addSubview:lineImageView];
    //添加总价格的label
    _priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(140, 5, 100, 30)];
    _priceLabel.backgroundColor=[UIColor clearColor];
    _priceLabel.textColor=[UIColor redColor];
    [_orderView addSubview:_priceLabel];
    //添加右边的结账按钮
    _accountBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _accountBtn.frame=CGRectMake(250, 5.5, 60, 30);
    [_orderView addSubview:_accountBtn];
    
    [self.view addSubview:_orderView];
    
    
    //添加左边个数
    _countLab=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 30)];
//    _countLab.text=@"件数";
    _countLab.textColor=[UIColor redColor];
    _countLab.backgroundColor=[UIColor clearColor];
    [_orderView addSubview:_countLab];


}

//#pragma mark_
//#pragma mark - BtnClick
////返回按钮
//-(void)returnBtnClick:(id)sender
//{
//    NSLog(@"返回按钮被点击了");
//    //pop出去
//    [self.navigationController popViewControllerAnimated:YES];
//}
////确认收货按钮
//-(void)sureBtnClick:(id)sender
//{
//    NSLog(@"确认收货按钮被点击了");
//}










- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
