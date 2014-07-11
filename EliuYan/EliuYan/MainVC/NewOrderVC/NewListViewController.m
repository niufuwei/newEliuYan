//
//  NewListViewController.m
//  ELiuYan
//
//  Created by shanchen on 14-4-21.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "NewListViewController.h"
#import "NewListCell.h"
#import "httpRequest.h"
#import "Activity.h"
#import "RootView.h"
#import "LoadingView.h"
#import "MemberCenterViewController.h"
#import "AppDelegate.h"
#import "DefineModel.h"
#import "NavViewController.h"
#define SYSTEM_VERSION [[UIDevice currentDevice].systemVersion doubleValue]
static NSString *no_select_backImageName = @"back_no_select.png";
static NSString *selected_backImageName = @"back_selected.png";
@interface NewListViewController ()
{
    NSMutableArray * buffer;
    UILabel * pageCount;
    Activity * myActivily;
    NSInteger pageIndex;
    RootView *root;
    LoadingView *_loadView;
    
    BOOL isFirst;
    UIView * noLogin;
     
}

@end

@implementation NewListViewController


@synthesize backScrollview;
@synthesize activity;
@synthesize myNavCustom;
@synthesize rootDelegate;
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
    [super viewWillAppear:YES];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogIn"] isEqualToString:@""])
    {
        [Confirm removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
       [self loadViewView];
    }
    
    
    
}



-(void)onLogin{

    MemberCenterViewController * center = [[MemberCenterViewController alloc] init];
    UINavigationController *nav = [[NavViewController alloc] initWithRootViewController:center];
    [self presentViewController:nav animated:YES completion:^{
        
        
    }];
}
-(void) setLeftItem{
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"返回.png"];
    
    backButton.backgroundColor=[UIColor clearColor];
    backButton.frame = CGRectMake(-20, 0, 12, 20);
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    if([UIDevice currentDevice].systemVersion.floatValue >= 7.0f){
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -7.5;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftButtonItem];
    }
    else{
        self.navigationItem.leftBarButtonItem = leftButtonItem;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化数组
    _orderIdArray = [[NSArray alloc] init];
    
    
    _currentPageDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    //初始化导航条
    myNavCustom = [[NavCustom alloc] init];
    [myNavCustom setNav:@"最新订单" mySelf:self];
    myNavCustom.NavDelegate = self;
    
     [appDelegate hidenTabbar];
    [self setLeftItem];
    
    
    newOrderRecord = [[NSMutableArray alloc] initWithCapacity:1];
    
    
    //店铺详情
    Confirm=[UIButton buttonWithType:UIButtonTypeCustom];
    Confirm.frame=CGRectMake(320-80, 7, 80, 30);
//    [Confirm setBackgroundImage:[UIImage imageNamed:@"确认收货.png"] forState:UIControlStateNormal];
    [Confirm setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [Confirm setTitle:@"确认收货" forState:UIControlStateNormal];
    Confirm.titleLabel.font=[UIFont systemFontOfSize:16.0];
//    [Confirm setBackgroundColor:[UIColor blackColor]];
    [Confirm addTarget:self action:@selector(sureCount:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:Confirm];
    Confirm.hidden = YES;
    
}

-(void)getBackOrder:(void (^)(NSString *))backOrder1{
    if(self)
    {
        _backOrder1 = backOrder1;
    }
}
-(void)loadViewView
{
    isFirst = TRUE;
    isAccount=TRUE;
    
    [self.orderView removeFromSuperview];
    
    deleteDic = [[NSMutableDictionary alloc] init];
    mutableDic = [[NSMutableDictionary alloc] init];

    
    //默认第一页
    pageIndex = 0;
    currentIndexPage = -1;
    backScrollview =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, 320, self.view.frame.size.height+10)];
    backScrollview.tag=100;
    backScrollview.pagingEnabled=YES;//立刻翻页到下一页 没中间的拖动过程
    backScrollview.bounces=NO;//去掉翻页中的白屏
    [backScrollview setDelegate:self];
    backScrollview.userInteractionEnabled = YES;
    backScrollview.showsHorizontalScrollIndicator=NO;//不现实水平滚动条
    
    
    pageCount = [[UILabel alloc] initWithFrame:CGRectMake(270, 100, 50, 40)];
    pageCount.backgroundColor = [UIColor redColor];
    pageCount.textColor = [UIColor whiteColor];
    pageCount.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:pageCount];
    
    [self startRequest:OrderID];
    
    
    

    
    [mutableDic setObject:@"ok" forKey:[NSString stringWithFormat:@"%d",0]];
    
    
    [self.view addSubview:backScrollview];
    
    
    root=[[RootView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
//    [root call_Back:(^(NSString *str) {
//        NSLog(@"确认收货了");
//        [deleteDic setObject:@"delete" forKey:[NSString stringWithFormat:@"%d",0]];
//    })];
    
    self.rootDelegate=root;
    NSLog(@"backscrollview enable is %hhd",backScrollview.userInteractionEnabled);
    [backScrollview addSubview:root];
    NSLog(@"root enable is %hhd",root.userInteractionEnabled);
    //初始化菊花
    myActivily = [[Activity alloc] initWithActivity:self.view];
   
    
}
-(void)startRequest:(NSString *)OrderId
{
    httpRequest * http = [[httpRequest alloc] init];
    http.httpDelegate = self;
    
    NSLog(@"...%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"]);
    
     [myActivily start];
    [http httpRequestSend:[NSString stringWithFormat:@"%@order/MyNewsOdersDetails",SERVICE_ADD] parameter:[NSString stringWithFormat:@"UserId=%@&OrderId=%@&Token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"],OrderId,[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"]] backBlock:(^(NSDictionary * dic){
        NSLog(@"得到的数据===>%@",dic);
        
        //解析数据
        
        if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"88"])
        {
             [myActivily stop];
            
            backScrollview.userInteractionEnabled = YES;
            
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"警告" message:@"您的账号在别处登录,请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alertView.delegate=self;
            alertView.tag=222;
            //登录状态 token 值
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LoginName"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ReallyName"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hasLogIn"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Token"];
            [alertView show];
            
            [root removeFromSuperview];
            [pageCount removeFromSuperview];
        }
        
        else
        {
            
            //取出数组
             NSString *orderIds = [dic objectForKey:@"OrderIds"];
            if (!isFirstRequest) {
                 _orderIdArray = [orderIds componentsSeparatedByString:@","];
                pageCount.text=[NSString stringWithFormat:@"%d/%d",1,_orderIdArray.count];
                isFirstRequest = TRUE;
            }
           
           
//            NSLog(@"......%@",_orderIdArray);
//            NSLog(@"....%d",_orderIdArray.count);
            //总页数
            //如果是第一次进入并请求数据，那么获得总页数
            [myActivily stop];
            
            backScrollview.userInteractionEnabled = YES;
            [newOrderRecord addObject:dic];
//            totalPage=[dic objectForKey:@"TotalPage"];
            _backOrder1(totalPage);
            if (isAccount==TRUE) {
                isTotalPage = [NSString stringWithFormat:@"%d",_orderIdArray.count];
            }
            isAccount=FALSE;
            
            [backScrollview setContentSize:CGSizeMake(320*[isTotalPage intValue], self.view.frame.size.height-44)];
            
            
                       
            if ([isTotalPage isEqualToString:@"0"])
            {
                //提示没有最新订单
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"您还没有最新订单哦，快去购物吧" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alert.delegate=self;
                alert.tag=1111;
                [alert show];
                [root removeFromSuperview];
                [pageCount removeFromSuperview];
                
            }
            
            [self.rootDelegate sendRequest:dic orderIdArray:_orderIdArray];
            
            
//            NSLog(@"....%@",[dic objectForKey:@"List"]);
            int status=[[[dic objectForKey:@"List"] objectForKey:@"Status" ] intValue];
            orderId = [[dic objectForKey:@"List"] objectForKey:@"Id"];
            
            NSLog(@"status is %d,order id is %@ ",status,orderId);
            
            if (status == 2 || status == 3)
            {
                
                Confirm.hidden = NO;
               
            }
            else
            {
                Confirm.hidden = YES;
            }
            
        }
        
})];
[myActivily stop];
}
//确认收货
-(void)sureCount:(id)sender
{
    //判断是否有订单
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"亲，是否确认收货" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.delegate=self;
    alert.tag=10086;
    [alert show];
}

#pragma mark --
#pragma mark 请求服务器的出错代理方法

-(void)httpRequestError:(NSString *)str
{
    NSLog(@"我的出错信息:%@",str);
    [myActivily stop];
    //加载出错界面
    LoadingView *loadView=[[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [loadView changeLabel:@"我尽力了，还是看不到"];
    [self.view addSubview:loadView];
    
    [self.view bringSubviewToFront:loadView];
    [root removeFromSuperview];
    [pageCount removeFromSuperview];

}

#pragma mark -
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1111)
    {
        if (buttonIndex==0)
        {
            //返回主页
            [Confirm removeFromSuperview];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            NSLog(@"取消");
        }

    }
    if (alertView.tag==222)
    {
        if (buttonIndex==0)
        {
            //跳转到登录界面
            MemberCenterViewController *memberVC=[[MemberCenterViewController alloc] init];
            UINavigationController * nav = [[NavViewController alloc] initWithRootViewController:memberVC];

            [self presentViewController:nav animated:YES completion:^{
                [newOrderRecord removeAllObjects];
                tempIndex = 0;
            }];
            //[self removeFromParentViewController];
        }
        
        else
            
        {
            [Confirm removeFromSuperview];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
    if(alertView.tag==10086)
    {
        
        if (buttonIndex==0) {
            
            NSInteger currentPage = backScrollview.contentOffset.x/320;
            
            
            httpRequest * http = [[httpRequest alloc] init];
            [http httpRequestSend:[NSString stringWithFormat:@"%@order/GainGoods",SERVICE_ADD] parameter:[NSString stringWithFormat:@"Id=%@&Token=%@",[_orderIdArray objectAtIndex:currentPage],[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"]] backBlock:(^(NSDictionary * dic){
                NSLog(@"===>%@",dic);
//                [_currentPageDic setObject:[NSString stringWithFormat:@"%d",currentPage] forKey:@"isCurrentPage"];
                if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
                {
//                    if ([[_currentPageDic objectForKey:@"isCurrentPage"] isEqualToString:[NSString stringWithFormat:@"%d",currentPage]]) {
//                        Confirm.hidden = YES;
//                        [_currentPageDic setObject:@"no" forKey:@"isCurrentPage"];
                    
                 NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary: [[newOrderRecord objectAtIndex:currentPage] objectForKey:@"List"]];
                    [dic setObject:@"5" forKey:@"Status"];
                    [newOrderRecord replaceObjectAtIndex:currentPage withObject:dic];
                    
                    Confirm.hidden=YES;
                    
                    
                    
                    
                    //标题改变
                    root.statusLabel.textColor =[UIColor grayColor];
                    root.statusLabel.text = @"订单已完成                                               订单完成";

                    //用来标记确认收货
//                    [];
                    
//                    int count = [[[NSUserDefaults standardUserDefaults] objectForKey:@"newOrders"] intValue];
//                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",count -1] forKey:@"newOrders"];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"newOrderChangeCount" object:nil];
                    
                    
                    
//                    int count1 = [[[NSUserDefaults standardUserDefaults] objectForKey:@"allCount"] intValue];
//                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",count1 -1] forKey:@"allCount"];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAllCount" object:nil];
                    
                }
                else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"88"])
                {
                
                
                    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"警告" message:@"您的账号在别处登录,请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                    alertView.delegate=self;
                    alertView.tag=10010;
                    //登录状态 token 值
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LoginName"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ReallyName"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hasLogIn"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Token"];
                    [alertView show];
                    
                    [root removeFromSuperview];
                
                }
                
                
            })];
        }
        
    }
    else if (alertView.tag == 10010)
    {
    
        if (buttonIndex==0)
        {
            //跳转到登录界面
            MemberCenterViewController *memberVC=[[MemberCenterViewController alloc] init];
            UINavigationController * nav = [[NavViewController alloc] initWithRootViewController:memberVC];
            
            [self presentViewController:nav animated:YES completion:^{
                [newOrderRecord removeAllObjects];
                tempIndex = 0;
            }];
            //[self removeFromParentViewController];
        }
        
        else
            
        {
        
            [Confirm removeFromSuperview];
            [self.navigationController popViewControllerAnimated:YES];
        
        }
        
    }
    
}

#pragma mark --
#pragma tabledelegate

-(void)NavRightButtononClick
{
    NSLog(@"sdsdsdsd");
}


#pragma mark --
#pragma scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   
    NSLog(@"结束dragging.......................................");
    contentOfSet1 = scrollView.contentOffset.x;
    
    NSInteger currentPage1 = scrollView.contentOffset.x/320;
    if (currentPage1 <= [newOrderRecord count] - 1)
    {
        backScrollview.userInteractionEnabled = YES;
    }
    
    
    NSLog(@"开始和结束的时候 %f.......%f",(contentOfSet1/320),(contentOfSet/320));
    if (contentOfSet1/320 == contentOfSet/320)
    {

    }
    
    //往回滑动
    if (contentOfSet1/320 < contentOfSet/320)
    {
        NSInteger currentPage = scrollView.contentOffset.x/320;
        int status = [[[[newOrderRecord objectAtIndex:currentPage] objectForKey:@"List"] objectForKey:@"Status" ] intValue];
        if (status != 2 && status != 3)
        {
            Confirm.hidden = YES;
        }
        else
        {
            
            Confirm.hidden = NO;
            
            
        }
        
    }
    else if (contentOfSet1/320 > contentOfSet/320) //往前滑动
    {
        

        NSInteger currentPage = scrollView.contentOffset.x/320;
        
        
        if ([newOrderRecord count] > currentPage)
        {
            int status = [[[[newOrderRecord objectAtIndex:currentPage] objectForKey:@"List"] objectForKey:@"Status" ] intValue];
            if (status != 2 && status != 3)
            {
                Confirm.hidden = YES;
            }
            else
            {
                
                Confirm.hidden = NO;
                
                
            }
        }
        
        
        
        
    }


}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView

{

    backScrollview.userInteractionEnabled = NO;
    
    contentOfSet = scrollView.contentOffset.x;



}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    //判断确认收货按钮是否存在
//    if ([nss]) {
//        <#statements#>
//    }
    
    backScrollview.userInteractionEnabled = NO;

   
    NSLog(@"contentfoset is %f",scrollView.contentOffset.x);
    if (!contentHasSaved)
    {
        contentOfSet = scrollView.contentOffset.x;
    }
    contentHasSaved = YES;
    
    
    if (scrollView.tag==100)
    {
        NSInteger xx = scrollView.contentOffset.x;
        if(xx % 320 ==0)
        {
//            NSLog(@">>>>%f",scrollView.contentOffset.x);
            NSInteger currentPage = scrollView.contentOffset.x/320;
            tempIndex = currentPage;
            NSLog(@"///////%d",currentPage);
            
            
            if(![[mutableDic objectForKey:[NSString stringWithFormat:@"%d",currentPage]] isEqualToString:@"ok"])
            {
                NSLog(@"....%@",_orderIdArray);
            [self startRequest:[_orderIdArray objectAtIndex:currentPage]];
                            if (IOS_VERSION>=7.0)
                            {
                                root=[[RootView alloc] initWithFrame:CGRectMake(currentPage*320, 0, 320, self.view.frame.size.height+64.2)];
                            }
                            else
                            {
            
                                root=[[RootView alloc] initWithFrame:CGRectMake(currentPage*320, 0, 320, self.view.frame.size.height+64.2)];
                            }
                            self.rootDelegate=root;
            
                [backScrollview addSubview:root];
                [mutableDic setObject:@"ok" forKey:[NSString stringWithFormat:@"%d",currentPage]];
                pageCount.text = [NSString stringWithFormat:@"%d/%@",tempIndex+1,isTotalPage];
            }
            else
            {
                pageCount.text = [NSString stringWithFormat:@"%d/%@",currentPage+1,isTotalPage];
            }
            
            
//            //判断是否有收获
//            if(![[mutableDic objectForKey:[NSString stringWithFormat:@"%d",currentPage]] isEqualToString:@"ok"])
//            {
//                //判断是否有收获
//                
//                if([[deleteDic objectForKey:[NSString stringWithFormat:@"%d",currentPage-1]] isEqualToString:@"delete"])
//                {
//                    for (int i=1;1;i++)
//                    {
//                        if([[deleteDic objectForKey:[NSString stringWithFormat:@"%d",currentPage-i]] isEqualToString:@"delete"])
//                        {
//                            
//                        }
//                        else
//                        {
//                            if(currentIndexPage==-1)
//                            {
//                                [self startRequest:[NSString stringWithFormat:@"%d",currentPage-i+1]];
//                                currentIndexPage =currentPage-i+1;
//
//                            }
//                            else
//                            {
//                                [self startRequest:[NSString stringWithFormat:@"%d",currentIndexPage]];
//                            }
//                            
//                            break;
//                        }
//                    }
//                    
//                }
//                else
//                {
//                    if(currentIndexPage!=-1)
//                    {
//                        [self startRequest:[NSString stringWithFormat:@"%d",++currentIndexPage]];
//                    }
//                    else
//                    {
//                        [self startRequest:[NSString stringWithFormat:@"%d",currentPage]];
//
//                    }
//                }
//
//                
//                if (IOS_VERSION>=7.0)
//                {
//                    root=[[RootView alloc] initWithFrame:CGRectMake(currentPage*320, 0, 320, self.view.frame.size.height+64.2)];
//                }
//                else
//                {
//                    
//                    root=[[RootView alloc] initWithFrame:CGRectMake(currentPage*320, 0, 320, self.view.frame.size.height+64.2)];
//                }
//                [root call_Back:(^(NSString *str)
//                                 
//                {
//                    [deleteDic setObject:@"delete" forKey:[NSString stringWithFormat:@"%d",currentPage]];
//                    
//                })];
//                
//                self.rootDelegate=root;
//                
//                [backScrollview addSubview:root];
//                [mutableDic setObject:@"ok" forKey:[NSString stringWithFormat:@"%d",currentPage]];
//            }
//            else
//                pageCount.text = [NSString stringWithFormat:@"%d/%@",currentPage+1,isTotalPage];
            
        }

    }
    
}
-(void)popself
{

    [Confirm removeFromSuperview];
    _backOrder1([NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"newOrders"]]);
    [self.navigationController popViewControllerAnimated:YES];



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
