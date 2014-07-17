//
//  MainViewController.m
//  ELiuYan
//
//  Created by shanchen on 14-4-21.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//http://218.244.145.132:8081/eliuyanservice/ely/
#import "MainViewController.h"
#import "NewListViewController.h"
#import "MemberCenterViewController.h"
#import "ShoppingViewController.h"
#import "AboutUsViewController.h"
#import "CheckStandViewController.h"
#import "DeliveryInformationViewController.h"
#import "MemberDetailViewController.h"
#import "AppDelegate.h"
#import "httpRequest.h"
#import "WebViewController.h"
#import "newVersion.h"

@interface MainViewController ()
{
    UIPageControl * pageControl;
    UIImageView *image;
    newVersion * NVersion;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;

}
-(void)currentPage:(int)page total:(NSUInteger)total{
//    NSLog(@"当前页：%@",[NSString stringWithFormat:@"Current Page %d",page+1]);
    
    [pageControl setCurrentPage:page];
}
-(void)didClick:(id)data
{
    NSLog(@"data=%@",(NSDictionary *)data);
    //请求webView
    //加载菊花
    
    _titleName=[(NSDictionary *)data objectForKey:@"title"];
    
    //加载webView
    WebViewController *webView=[[WebViewController alloc] init];
    webView.url=[(NSDictionary *)data objectForKey:@"html"];
    webView.name=_titleName;
    [self.navigationController pushViewController:webView animated:YES];
    [myActivity stop];

}

- (IBAction)pageTurn:(UIPageControl *)sender
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor=eliuyan_color(0xf5f5f5);

    //创建UI
    
    [self creatUI];
    
    
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
//    
//        NVersion = [[newVersion alloc] init];
//        [NVersion begin:@"http://itunes.apple.com/lookup?id=768005105" boolBegin:NO];
//    }
    
    
        
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buttonHidden:) name:@"buttonHidden" object:nil];

}

//-(void)buttonHidden:(NSNotification *)notification
//{
//
//    ((UILabel *)[self.view viewWithTag:333]).hidden = YES;
//    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"newMessageCount"];
//    
// }




//创建UI的方法
-(void)creatUI
{

    //添加最新订单和个人中心的按钮
    
    UIButton *newOrderBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    newOrderBtn.frame=CGRectMake(20, 34, 50, 40);
    [newOrderBtn setBackgroundImage:[UIImage imageNamed:@"首页_最新订单-未按.png"] forState:(UIControlStateNormal)];
    //[leftBtn setBackgroundColor:[UIColor yellowColor]];
    [newOrderBtn addTarget:self action:@selector(newOrderClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newOrderBtn];
    
    UIButton *ownBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    ownBtn.frame=CGRectMake(80, 34, 50, 40);
     [ownBtn setBackgroundImage:[UIImage imageNamed:@"首页_个人中心-未按.png"] forState:(UIControlStateNormal)];
    //[rightBtn setBackgroundColor:[UIColor yellowColor]];
    [ownBtn addTarget:self action:@selector(ownBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ownBtn];
    
    
    UILabel *messageCount = [[UILabel alloc] initWithFrame:CGRectMake(30,-5, 15, 15)];
    messageCount.textAlignment = NSTextAlignmentCenter;
    messageCount.textColor=[UIColor whiteColor];
    messageCount.font=[UIFont systemFontOfSize:12];
    messageCount.tag = 333;
    messageCount.layer.cornerRadius = 7.5;
    messageCount.layer.masksToBounds = YES;
    messageCount.backgroundColor = [UIColor redColor];
    messageCount.hidden = YES;
    [ownBtn addSubview:messageCount];
    
    
    
    
    
    //中间主要内容 便捷购物
    UIButton *centerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    centerBtn.frame=CGRectMake(90, 130, 140, 120);
    [centerBtn setBackgroundImage:[UIImage imageNamed:@"首页_便捷购物-未按.png"] forState:(UIControlStateNormal)];
    [centerBtn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:centerBtn];
    
    
    //添加公告 底部
    
    [self createScrollerView];
    
    

    //添加最下面的View
    UIView *bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-60, 320, 60)];
    //在view上添加底部图片
    UIImageView *bottomImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"首页底部.png"]];
    bottomImageView.frame=CGRectMake(0, 0, 320, 60);
    [bottomView addSubview:bottomImageView];
    [self.view addSubview:bottomView];
    
    
}

//添加_scrollView
-(void)createScrollerView
{
//    //发送请求

    NSString *strUrl=[NSString stringWithFormat:@"%@user/ActivityList",SERVICE_ADD];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    request.delegate=self;
    request.tag=10010;
    request.timeOutSeconds=60;
    [request startAsynchronous];

    
    if (!iPhone5) {
        _Topic = [[JCTopic alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height-80-44-50 , 300, 80)];
    }
    else
    {
        _Topic = [[JCTopic alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height-80-44-20-30-50, 300, 80)];
    }

    [_Topic setBackgroundColor:eliuyan_color(0xf5f5f5)];
    _Topic.JCdelegate = self;

    [self.view addSubview:_Topic];
   

    //pagecontrol 的初始化
    if(!iPhone5)
    {
         pageControl= [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-80-44-30+60-20, 320, 20)];
    }
    else
    {
         pageControl= [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-80-44-30-70+60, 320, 20)];
    }
   
    pageControl.currentPage=0;
    
    [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    
    
}
#pragma mark_
#pragma mark - ASIHttpDelegate
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"请求失败。。。。。。%@",request.error);
    
    
    
    
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag==10010)
    {
    //解析数据
        SBJSON *json=[[SBJSON alloc] init];
        NSDictionary *allDict=[json objectWithString:request.responseString error:nil];
        NSLog(@"%@",allDict);
            //判断数组是否为空
        if(allDict!=nil)
        {
            NSArray *array=[allDict objectForKey:@"List"];
            NSLog(@"lll=%@",array);
            if([array count]!=0)
            {
                _urlArray = [[NSMutableArray alloc] init];
                _activityIdArray = [[NSMutableArray alloc] init];
                _titleArray = [[NSMutableArray alloc] init];
                for (int i= 0 ; i<array.count; i++) {
                    NSMutableDictionary *detailDict=[array objectAtIndex:i];
                    //公告网址
                    NSString *htmlPath=[detailDict objectForKey:@"HtmlPath"];
                    
                    //图片地址
                    NSString *activityUrl=[detailDict objectForKey:@"ActivityUrl"];
                    //图片名称
                    NSString *title=[detailDict objectForKey:@"Title"];
                    [_titleArray addObject:title];
                    
                    [_activityIdArray addObject:htmlPath];
                    [_urlArray addObject:activityUrl];
                    
                }
                
                NSMutableArray * tempArray = [[NSMutableArray alloc] init];
                for(int i =0;i<_urlArray.count;i++)
                {
                    [tempArray addObject:[NSDictionary dictionaryWithObjects:@[[_urlArray objectAtIndex:i],[_activityIdArray objectAtIndex:i],[_titleArray objectAtIndex:i],@NO,[UIImage imageNamed:@"底色.png"]] forKeys:@[@"pic",@"html",@"title",@"isLoc",@"placeholderImage"]]];
                }
                
                _Topic.pics = tempArray;
                [_Topic upDate];
                pageControl.numberOfPages = [_urlArray count];
                if(pageControl.numberOfPages == 1)
                {
                    [pageControl setHidden:YES];
                }
                else
                {
                    [pageControl setHidden:NO];
                }

            }
        }
    }
}



#pragma mark_
#pragma mark - BtnClick
-(void)newOrderClick:(id)sender
{
    NSLog(@"最新订单按钮被点击了");
    
    NSLog(@"llllllllllll%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"]);
    //判断用户是否登录

    if (![[appDelegate.appDefault objectForKey:@"hasLogIn"] isEqualToString:@"1"]) {
        //提示没有最新订单
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您还没有登录，赶快去登录吧" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag=10000;
        alert.delegate=self;
        [alert show];
    }
    else
    {
        //push进去最新订单的界面
        NewListViewController *newListVC = [[NewListViewController alloc] init];
        [self.navigationController pushViewController:newListVC animated:YES];

    }
}
-(void)ownBtnClick:(id)sender
{
    
    NSLog(@"个人中心按钮被点击了");
    if ([[appDelegate.appDefault objectForKey:@"hasLogIn"] isEqualToString:@"1"])
    {
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"buttonHidden" object:nil];

        MemberDetailViewController *memberDetalVC = [[MemberDetailViewController alloc] init];
        [self.navigationController pushViewController:memberDetalVC animated:YES];
        
    }
    else
    {
     
        MemberCenterViewController *memberVC=[[MemberCenterViewController alloc] init];
        [self presentViewController:memberVC animated:YES completion:^{
            
        }];
    }
}
-(void)centerBtnClick:(id)sender
{
    
    NSLog(@"便捷购物按钮被点击了");
    ShoppingViewController *shoppingVC=[[ShoppingViewController alloc] init];
    [self.navigationController pushViewController:shoppingVC animated:YES];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000)
    {
        
        if (buttonIndex == 0)
        {
            MemberCenterViewController *memberVC=[[MemberCenterViewController alloc] init];
            [self presentViewController:memberVC animated:YES completion:^{
                
            }];            
           
        }
    }
    if (alertView.tag==10001) {
        if (buttonIndex==0) {
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:[NSURL URLWithString:_trackURL]];

        }
    }
    

}


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
