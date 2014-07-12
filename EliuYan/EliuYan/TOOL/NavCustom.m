//
//  NavCustom.m
//  ELiuYan
//
//  Created by laoniu on 14-4-29.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "NavCustom.h"

@implementation NavCustom
@synthesize NavDelegate;

-(void)setNav:(NSString *)NavTitile mySelf:(UIViewController *)mySelf
{
    UILabel * lab;
    if(IOS_VERSION <7)
    {
        lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 21)];
    }
    else
    {
        lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
    }
    
    [lab setFont:[UIFont systemFontOfSize:20]];
    lab.textColor = [UIColor blackColor];
    lab.text = NavTitile;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    mySelf.navigationItem.titleView = lab;
    
}

-(void)setNavRightBtnTitle:(NSString *)RightBtnTitle mySelf:(UIViewController *)mySelf width:(int)width height:(int)height
{
    //创建右边按钮
    UIButton *rightBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    [rightBackBtn setTitle:RightBtnTitle forState:UIControlStateNormal];
    [rightBackBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBackBtn addTarget:self action:@selector(NavRightButtononClick) forControlEvents:UIControlEventTouchUpInside];
    
    //添加进BARBUTTONITEM
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBackBtn];
    
    //右按钮
    mySelf.navigationItem.rightBarButtonItem = rightBtn;
}

-(void)setNavRightBtnImage:(NSString *)RightBtnImage RightBtnSelectedImage:(NSString *)RightBtnSelectedImage mySelf:(UIViewController *)mySelf width:(int)width height:(int)height
{
    //创建右边按钮
    UIButton *rightBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    [rightBackBtn setBackgroundImage:[UIImage imageNamed:RightBtnImage] forState:UIControlStateNormal];
    [rightBackBtn setBackgroundImage:[UIImage imageNamed:RightBtnSelectedImage] forState:UIControlStateHighlighted];
    [rightBackBtn addTarget:self action:@selector(NavRightButtononClick) forControlEvents:UIControlEventTouchUpInside];
    
    //添加进BARBUTTONITEM
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBackBtn];
    
    //右按钮
    mySelf.navigationItem.rightBarButtonItem = rightBtn;
    
}

- (void) NavRightButtononClick{
    
    if ([NavDelegate respondsToSelector:@selector(NavRightButtononClick)])
    {//判断方法是否实现
        [NavDelegate NavRightButtononClick];
    }
}



@end
