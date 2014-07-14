//
//  MyOrderViewController.m
//  ELiuYan
//
//  Created by shanchen on 14-4-24.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderCell.h"
#import "httpRequest.h"
#import "AppDelegate.h"
#import "DefineModel.h"
#import "MyOrderDetailViewController.h"
#import "MemberCenterViewController.h"
#import "NavViewController.h"
#import "LoadingView.h"


@interface MyOrderViewController ()

@end

@implementation MyOrderViewController

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
    
    
    
    [self.orderView removeFromSuperview];
    NavCustom *nav=[[NavCustom alloc] init];
    [nav setNav:@"我的订单" mySelf:self];
    
    isRepeat = FALSE;
    [appDelegate hidenTabbar];


    _list = [[NSMutableArray alloc] initWithCapacity:1];
    _pageIndex = 0;
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:YES];
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogIn"] isEqualToString:@""])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
    
    
    if (!isRepeat)
    {
        if (IOS_VERSION < 7.0)
        {
            _myOrderTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, 300, self.view.frame.size.height)];
            
        } else {
            _myOrderTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, 300, self.view.frame.size.height +44)];
            _myOrderTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        
        _myOrderTableView.showsVerticalScrollIndicator = NO;
        _myOrderTableView.dataSource = self;
        _myOrderTableView.delegate = self;
        _myOrderTableView.backgroundColor=eliuyan_color(0xf5f5f5);
        
        [self.view addSubview:_myOrderTableView];
        
        [self loadUI];
        [self addFooter];
    }
    }


}

-(void)loadUI
{
    
    
    
    
    
    activity = [[Activity alloc] initWithActivity:self.view];
    [activity start];
    
    self.view.userInteractionEnabled = NO;
    
    httpRequest *http = [[httpRequest alloc] init];
    http.httpDelegate = self;
    [http httpRequestSend:[NSString stringWithFormat:@"%@order/GetMyOrderList",SERVICE_ADD] parameter:[NSString stringWithFormat:@"Id=%@&PageIndex=%d&Token=%@",[appDelegate.appDefault objectForKey:@"UserId"],_pageIndex,[appDelegate.appDefault objectForKey:@"Token"]] backBlock:^(NSDictionary * dic) {
        
        
        
   
        if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
        {
            
            
            
            NSLog(@"我的订单数据是%@",dic);
            _totalCount = [[dic objectForKey:@"TotalCount"] intValue];
            isRepeat = TRUE;
            if ([[dic objectForKey:@"TotalCount"] intValue] == 0)
            {
                [activity stop];
                
                
                [self.myOrderTableView removeFromSuperview];
                
//                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 50, 100, 100)];
//                imageView.image = [UIImage imageNamed:@"无信息页面.png"];
//                [self.view addSubview:imageView];
//                
//                UILabel *noMessage = [[UILabel alloc] initWithFrame:CGRectMake(60,170, 200, 30)];
//                noMessage.text = @"您最近没有订单哦";
////                noMessage.textColor = [UIColor grayColor];
//                noMessage.textAlignment = NSTextAlignmentCenter;
//                noMessage.backgroundColor = [UIColor clearColor];
//                [self.view addSubview:noMessage];
                //提示没有订单
                LoadingView *loadView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) image:@"无信息页面.png"];
                [loadView changeLabel:@"您最近没有订单哦"];
                [self.view addSubview:loadView];
                self.view.userInteractionEnabled = YES;
                
                return ;
            }
            _totalPage = [[dic objectForKey:@"TotalPage"] intValue];
            _list = [NSMutableArray arrayWithArray:[dic objectForKey:@"List"]];
            [self.myOrderTableView reloadData];
            [activity stop];
            self.view.userInteractionEnabled = YES;

            
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"99"])
        {
            [activity stop];
            [self.myOrderTableView removeFromSuperview];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 50, 100, 100)];
            imageView.image = [UIImage imageNamed:@"错误页面.png"];
            [self.view addSubview:imageView];
            
            UILabel *noMessage = [[UILabel alloc] initWithFrame:CGRectMake(60,170, 200, 30)];
            noMessage.text = @"我尽力了,还是看不到";
            noMessage.textColor = [UIColor grayColor];
            noMessage.textAlignment = NSTextAlignmentCenter;
            noMessage.backgroundColor = [UIColor clearColor];
            [self.view addSubview:noMessage];
            self.view.userInteractionEnabled = YES;

        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"88"])
        {
            [activity stop];
            isRepeat = FALSE;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您的账号在别处登录,请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.tag = 2;
            alert.delegate = self;
            [alert show];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hasLogIn"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Token"];
            self.view.userInteractionEnabled = YES;

            
        }
    }];


}
-(void)addFooter
{

    __unsafe_unretained MyOrderViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.myOrderTableView;
    NSLog(@"footer x is %f,y is %f",_footer.frame.origin.x,_footer.frame.origin.y);
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
    
  
        _pageIndex++;
        NSLog(@"回调方法");
        if (_pageIndex >= _totalPage)
        {
            [refreshView endRefreshing];
            
            if (!_isRemove) {
                _isRemove=TRUE;
                _aView=[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height-65, 100, 25)];
                _aView.backgroundColor=[UIColor blackColor];
                UILabel *aLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, _aView.frame.size.width, _aView.frame.size.height)];
                aLabel.font=[UIFont systemFontOfSize:13];
                aLabel.textAlignment=YES;
                aLabel.textColor=[UIColor whiteColor];
                aLabel.backgroundColor = [UIColor clearColor];
                aLabel.text=@"没有更多订单";
                [_aView addSubview:aLabel];
                [self.view addSubview:_aView];
                //1秒后消失
                [self performSelector:@selector(removeView) withObject:self afterDelay:1];
                
            }
 
            return;
        
        }
        
        [activity start];
        
        
        NSLog(@"pagecount is %d",_pageIndex);
        
        httpRequest *http = [[httpRequest alloc] init];
        [http httpRequestSend:[NSString stringWithFormat:@"%@order/GetMyOrderList",SERVICE_ADD] parameter:[NSString stringWithFormat:@"Id=%@&PageIndex=%d&Token=%@",[appDelegate.appDefault objectForKey:@"UserId"],_pageIndex,[appDelegate.appDefault objectForKey:@"Token"]] backBlock:^(NSDictionary * dic) {
            
            if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
            {
                NSLog(@"我的订单数据是%@",dic);
                
                [_list addObjectsFromArray:[dic objectForKey:@"List"]];
                [self.myOrderTableView reloadData];
                [activity stop];
                
            }
            else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"99"])
            {
                 [activity stop];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"系统异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
            else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"88"])
            {
                [activity stop];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您的账号在别处登录,请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                alert.tag = 1;
                alert.delegate = self;
                [alert show];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hasLogIn"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Token"];
                
            }
        }];
        
        [vc performSelector:@selector(doneWithView:) withObject:refreshView];
        
      };

    _footer = footer;
    



}

-(void)removeView
{
    [_aView removeFromSuperview];
    _isRemove=FALSE;
}



-(void)doneWithView:(MJRefreshBaseView *)refreshView
{

    [refreshView endRefreshing];


}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1 || alertView.tag ==2)
    {
        if (buttonIndex == 0)
        {
            MemberCenterViewController *memCenter = [[MemberCenterViewController alloc] init];
            UINavigationController *nav = [[NavViewController alloc] initWithRootViewController:memCenter];
            [self presentViewController:nav animated:YES completion:^{
                
            }];
        }
        else
        {
        
        
            [self.navigationController popViewControllerAnimated:YES];
        
        }
    }
    
    
    
}


-(void)httpRequestError:(NSString *)str;
{
    LoadingView *loadView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) image:@"无服务.png"];
    [loadView changeLabel:@"您的网络出小差了哦"];
    [self.view addSubview:loadView];
    [self.view bringSubviewToFront:loadView];
    
    [activity stop];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.list count];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 80.0;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    MyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        
        cell = [[MyOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = eliuyan_color(0xf5f5f5);
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.orderNumberLabel.text = [[self.list objectAtIndex:indexPath.row] objectForKey:@"OrderNumber"];
    if ([[[self.list objectAtIndex:indexPath.row] objectForKey:@"StoreType"] intValue]==1  || [[[self.list objectAtIndex:indexPath.row] objectForKey:@"StoreType"] intValue]==3)
    {
        //超市
        cell.orderMoneyLabel.text =[NSString stringWithFormat:@"%@元",[[self.list objectAtIndex:indexPath.row] objectForKey:@"OrderPrice"]];
        cell.orderMoneyLabel.textColor=[UIColor blackColor];
    }
    else
    {
        cell.orderMoneyLabel.text =@"——";
        cell.orderMoneyLabel.textColor=[UIColor grayColor];
    }
    
   
 
    if ([[NSString stringWithFormat:@"%@",[[self.list objectAtIndex:indexPath.row] objectForKey:@"Status"]] isEqualToString:@"1"])
    {
        cell.orderStateLabel.text = @"等待送货";
        cell.orderStateLabel.textColor = [UIColor redColor];
    }
    else if([[NSString stringWithFormat:@"%@",[[self.list objectAtIndex:indexPath.row] objectForKey:@"Status"]] isEqualToString:@"2"])
    {
    
        cell.orderStateLabel.text = @"送货中";
        cell.orderStateLabel.textColor = [UIColor redColor];
    
    }
    else if([[NSString stringWithFormat:@"%@",[[self.list objectAtIndex:indexPath.row] objectForKey:@"Status"]] isEqualToString:@"3"])
    {
    
        cell.orderStateLabel.text = @"送货中";
        cell.orderStateLabel.textColor = [UIColor redColor];
    }
    else if ([[NSString stringWithFormat:@"%@",[[self.list objectAtIndex:indexPath.row] objectForKey:@"Status"]] isEqualToString:@"4"])
    {
        cell.orderStateLabel.text = @"订单完成";
        cell.orderStateLabel.textColor = [UIColor blackColor];
    
    
    }
    else if ([[NSString stringWithFormat:@"%@",[[self.list objectAtIndex:indexPath.row] objectForKey:@"Status"]] isEqualToString:@"5"])
    {
        cell.orderStateLabel.text = @"订单取消";
        cell.orderStateLabel.textColor = [UIColor blackColor];

    }
      
    //cell.accessoryType = UITableViewCellStyleValue1;
    cell.accessoryView = (UIView *)[[UIImageView alloc ] initWithImage:[UIImage imageNamed:@"未标题-3_12.png"]];
    [cell.accessoryView setFrame:CGRectMake(290, 12, 10, 10)];
    return cell;


}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    _pageIndex = 0;
    MyOrderDetailViewController *myOrderDetail = [[MyOrderDetailViewController alloc] initWithOrderId:[[self.list objectAtIndex:indexPath.row] objectForKey:@"Id"]];
    
    [myOrderDetail getBackOrder:(^(NSString * str){
        if([str isEqualToString:@"1"])
        {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[self.list objectAtIndex:indexPath.row]];
            [dictionary setObject:@"4" forKey:@"Status"];
            [self.list replaceObjectAtIndex:indexPath.row withObject:dictionary];
            
            
            ((MyOrderCell*)[_myOrderTableView cellForRowAtIndexPath:indexPath]).orderStateLabel.text = @"订单完成";
            ((MyOrderCell*)[_myOrderTableView cellForRowAtIndexPath:indexPath]).orderStateLabel.textColor = [UIColor blackColor];
            
        }
    })];
    [self.navigationController pushViewController:myOrderDetail animated:YES];


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
