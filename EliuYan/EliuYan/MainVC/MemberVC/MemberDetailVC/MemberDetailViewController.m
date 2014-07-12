//
//  MemberDetailViewController.m
//  ELiuYan
//
//  Created by shanchen on 14-4-24.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "MemberDetailViewController.h"
#import "ChangePswViewController.h"
#import "MyOrderViewController.h"
#import "AboutUsViewController.h"
#import "httpRequest.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "ChangeAppelViewController.h"
#import "MyMessageViewController.h"
#import "MyOrderDetailViewController.h"
#import "NewListViewController.h"
#import "MyAcountViewController.h"
#import "NavViewController.h"
#import "tabbarViewController.h"
#import "LoadingView.h"
#define SYSTEM_VERSION [[UIDevice currentDevice].systemVersion doubleValue]

@interface MemberDetailViewController ()
{
    UIView * noLogin;
    tabbarViewController *tabbar;
    LoadingView *_loadingView;
}


@end

@implementation MemberDetailViewController

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
    isRepeat = FALSE;

    NavCustom *nav=[[NavCustom alloc] init];
    [nav setNav:@"我的" mySelf:self];
    
    tabbar = [[tabbarViewController alloc] init];
    
    
    [self.orderView removeFromSuperview];
    
    //初始化数组
    _array=[[NSArray alloc] initWithObjects:@"我的账号",@"我的称呼",@"修改密码", nil];
    _array1 = [[NSArray alloc] initWithObjects:@"最新订单",@"我的消息",@"我的订单", nil];
    _array2 = [[NSArray alloc] initWithObjects:@"关于我们",nil];
    
    //会员列表
    
    if (IOS_VERSION >= 7)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 49-64) style:UITableViewStyleGrouped];

    }
    else
    {
    
         _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 49-44) style:UITableViewStyleGrouped];
    
    }
    
    
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=eliuyan_color(0xf5f5f5);
    [self.view addSubview:_tableView];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    
    cativity = [[Activity alloc] initWithActivity:self.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCount:) name:@"changeCount" object:nil];
    
    
    
    
    

}


-(void)changeCount:(NSNotification *)notitication
{
    
    
    
    NSString *count = [[[notitication userInfo] objectForKey:@"aps"] objectForKey:@"badge"];
    
    int i = [count intValue];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",i] forKey:@"unMsgCount"];
   
    [_tableView reloadData];
    
    

    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAllCount" object:nil];

    
    
    
    
    
    
}
-(void)onLogin
{
    MemberCenterViewController * center = [[MemberCenterViewController alloc] init];
    UINavigationController *nav = [[NavViewController alloc] initWithRootViewController:center];
    
    [self presentViewController:nav animated:YES completion:^{
        
        
    }];
}


-(void)doLogOut:(UIButton *)btn
{

    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退出登陆吗?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = 11;
    [alert show];
 
}

-(void)loadUI
{
   
    
    [cativity start];
    
    self.view.userInteractionEnabled = NO;
    
    
    httpRequest *http = [[httpRequest alloc] init];
    http.httpDelegate = self;
    [http httpRequestSend:[NSString stringWithFormat:@"%@user/GetMemberInfo",SERVICE_ADD] parameter:[NSString stringWithFormat:@"Id=%@&Token=%@",[appDelegate.appDefault objectForKey:@"UserId"],[appDelegate.appDefault objectForKey:@"Token"]] backBlock:^(NSDictionary *dic) {
        
        
        if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
        {
            
            [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"ReallyName"] forKey:@"ReallyName"];
            
            
            
            int count = [[dic objectForKey:@"unMsgCount"] intValue];
            NSLog(@"消息的数量是%@",[NSString stringWithFormat:@"%d",count]);
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",count] forKey:@"unMsgCount"];
            [_tableView reloadData];
            
            
            _memberInfo = [NSMutableDictionary dictionaryWithDictionary:dic];
            NSLog(@"memberinfo is %@",_memberInfo);
            //[[NSUserDefaults standardUserDefaults] setObject:[_memberInfo objectForKey:@"newOrders"] forKey:@"newOrders"];
            [[NSUserDefaults standardUserDefaults] setObject:[_memberInfo objectForKey:@"unMsgCount"] forKey:@"unMsgCount"];
            [_tableView reloadData];
            [cativity stop];
            self.view.userInteractionEnabled = YES;
            isRepeat = TRUE;
            
           

        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"99"])
        {
            [cativity stop];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"系统异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            self.view.userInteractionEnabled = YES;

            
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"88"])
        {
            [cativity stop];
            
            
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您的账号在别处登录,请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.tag = 22;
            [alert show];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hasLogIn"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Token"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LoginName"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ReallyName"];
            self.view.userInteractionEnabled = YES;

            
        }
        
    }];
    


}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    [appDelegate showTabbar];
    
    [_tableView reloadData];
    
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"hasLogIn"] isEqualToString:@"1"])
    {
         if(!isRepeat)
         {
             [noLogin removeFromSuperview];
             [self loadUI];
             
         }
        else
        {
        
            NSLog(@"abcdefghijklmnopqrstuvwxyz");
        
        }
       

    }
    else
    {
        isRepeat = FALSE;
        
        
        
        
        
//        for(UIView * v in self.view.subviews)
//        {
//            [v removeFromSuperview];
//        }
        
//        noLogin = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//        [self.view addSubview:noLogin];
//        
//        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setTitle:@"点此登录" forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [button setBackgroundColor:[UIColor redColor]];
//        [button.layer setCornerRadius:5];
//        button.frame = CGRectMake(30, self.view.frame.size.height/2, self.view.frame.size.width-60, 35);
//        [button addTarget:self action:@selector(onLogin) forControlEvents:UIControlEventTouchUpInside];
//        [noLogin addSubview:button];
//        _loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
//        [_loadingView changeLabel:@"我尽力了，还是看不到"];
//        [self.view addSubview:_loadingView];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LoginName"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ReallyName"];
        [_tableView reloadData];
        
        [self onLogin];
    }
}

-(void)httpRequestError:(NSString *)str
{
    self.view.userInteractionEnabled = YES;
    [self.view viewWithTag:60].userInteractionEnabled = YES;
    [cativity stop];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 11)
    {
        if (buttonIndex == 0)
        {
            [cativity start];
            
            
            
            [self.view viewWithTag:60].userInteractionEnabled = NO;
            
            NSLog(@"canshu is %@",[NSString stringWithFormat:@"LoginName=%@&SystemType=%@",[appDelegate.appDefault objectForKey:@"LoginName"],@"ios"]);
            NSLog(@"jiekou is %@",[NSString stringWithFormat:@"%@user/UserLogout",SERVICE_ADD ]);
            
            httpRequest *http = [[httpRequest alloc] init];
            http.httpDelegate = self;
            [http httpRequestSend:[NSString stringWithFormat:@"%@user/UserLogout",SERVICE_ADD ] parameter:[NSString stringWithFormat:@"LoginName=%@&SystemType=%@",[appDelegate.appDefault objectForKey:@"LoginName"],@"ios"] backBlock:^(NSDictionary * dic) {
                
                
                NSLog(@"tuichudeshihou  %@",dic);
                
                
                if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
                {
                    
                    NSLog(@"退出成功");
                    
                    [appDelegate.appDefault setObject:@"" forKey:@"Token"];
                    [appDelegate.appDefault setObject:@"" forKey:@"LoginName"];
                    [appDelegate.appDefault setObject:@"" forKey:@"hasLogIn"];
                    [appDelegate.appDefault setObject:@"" forKey:@"UserId"];
                    [appDelegate.appDefault setObject:@"" forKey:@"ReallyName"];
                    
                    
                    NSLog(@"haslogin is %@",[appDelegate.appDefault objectForKey:@"hasLogIn"]);
                    
                    
                    [cativity stop];
                    [self.view viewWithTag:60].userInteractionEnabled = YES;
                    
                    for(UIView * v in self.view.subviews)
                    {
                        [v removeFromSuperview];
                    }
                    
                    noLogin = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                    [self.view addSubview:noLogin];
                    isRepeat = FALSE;
                    
                    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                    [button setTitle:@"点此登录" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [button setBackgroundColor:[UIColor redColor]];
                    [button.layer setCornerRadius:5];
                    button.frame = CGRectMake(30, self.view.frame.size.height/2, self.view.frame.size.width-60, 35);
                    [button addTarget:self action:@selector(onLogin) forControlEvents:UIControlEventTouchUpInside];
                    [noLogin addSubview:button];

                    
                    
                }
                else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"99"])
                {
                    
                    [cativity stop];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"系统异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                    [self.view viewWithTag:60].userInteractionEnabled = YES;

                }
                
            }];
            
        
        }
        
        
    }
    else if(alertView.tag == 22)
    {
        if (buttonIndex == 0)
        {
            MemberCenterViewController *memCenter = [[MemberCenterViewController alloc] init];
            UINavigationController *nav = [[NavViewController alloc] initWithRootViewController:memCenter];
            
            [self presentViewController:nav animated:YES completion:^{
                
            }];
        }
    }
    
    
    
}

#pragma mark -
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{


    return 44;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 3;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 3;
    }
    else if(section == 1)
    {
    
        return 3;
    
    
    }
    else
    {
    
        return 1;
    
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifer=@"Cell";
   UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifer];
        
    }
    else
    {
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    
    }
    
    if (indexPath.section == 0)
    {
        cell.accessoryView = (UIView *)[[UIImageView alloc ] initWithImage:[UIImage imageNamed:@"未标题-3_12.png"]];
        [cell.accessoryView setFrame:CGRectMake(290, 12, 10, 10)];
        
        cell.backgroundColor=eliuyan_color(0xf5f5f5);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // cell.textLabel.font = [UIFont systemFontOfSize:13];
        if (indexPath.row == 0)
        {
            UILabel *loginNameLabel;
            if (IOS_VERSION < 7) {
               loginNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 6, 120, 28)];
            }
            else
            {
            
               loginNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 6, 120, 28)];
            
            }
            
            loginNameLabel.tag = 111 + indexPath.row;
            //loginNameLabel.font = [UIFont systemFontOfSize:13.0];
            loginNameLabel.textAlignment = NSTextAlignmentRight;
            loginNameLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:loginNameLabel];
            
        }
        else if(indexPath.row == 1)
        {
            UILabel *appelName;
            if (IOS_VERSION < 7) {
                appelName = [[UILabel alloc] initWithFrame:CGRectMake(155, 6, 120, 28)];
            }
            else
            {
                
                appelName = [[UILabel alloc] initWithFrame:CGRectMake(170, 6, 120, 28)];
                
            }
            
            appelName.textAlignment = NSTextAlignmentRight;
            appelName.tag = 222 + indexPath.row;
            //appelName.font = [UIFont systemFontOfSize:13.0];
            appelName.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:appelName];
            
        }
    }
    
    
    static NSString *cellIndentifer1=@"Cell1";
    UITableViewCell * cell1=[tableView dequeueReusableCellWithIdentifier:cellIndentifer1];
    if (cell1==nil)
    {
        cell1=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifer1] ;
    }
    
    
    static NSString *cellIndentifer2=@"Cell2";
    UITableViewCell * cell2=[tableView dequeueReusableCellWithIdentifier:cellIndentifer2];
    if (cell2==nil)
    {
        cell2=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifer2] ;
    }
    
    
    
  
    if (indexPath.section == 0)
    {
        cell.textLabel.text=[_array objectAtIndex:indexPath.row];
        NSLog(@">>>>%d",indexPath.row);
        if (indexPath.row == 0)
        {
            ((UILabel *)[cell viewWithTag:111  + indexPath.row]).text = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginName"];
        }
        else if(indexPath.row == 1)
        {
        ((UILabel *)[cell viewWithTag:222  + indexPath.row]).text = [[NSUserDefaults standardUserDefaults] objectForKey:@"ReallyName"];
        }
        else
        {
        
        }
//        UILabel *label1=(UILabel *)[cell viewWithTag:111 + indexPath.row];
//        label1.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginName"];
//        UILabel *label2=(UILabel *)[cell viewWithTag:222 + indexPath.row];
//        label2.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"ReallyName"];
        
        return cell;
    }
    
    
    if (indexPath.section == 1)
    {
        
        cell1.accessoryView = (UIView *)[[UIImageView alloc ] initWithImage:[UIImage imageNamed:@"未标题-3_12.png"]];
        [cell1.accessoryView setFrame:CGRectMake(290, 12, 10, 10)];
        
        cell1.backgroundColor=eliuyan_color(0xf5f5f5);
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.textLabel.text=[_array1 objectAtIndex:indexPath.row];
        //cell1.textLabel.font = [UIFont systemFontOfSize:13];

        
        

        if(indexPath.row == 1)
        {
            
            __block UILabel *loginNameLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(260, 6, 28, 28)];
            
            
            loginNameLabel2.textAlignment = NSTextAlignmentCenter;
            loginNameLabel2.tag = 100 + indexPath.row;
            loginNameLabel2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"会员中心_消息.png"]];
            loginNameLabel2.hidden = YES;
            [cell1 addSubview:loginNameLabel2];
            
        }
        
//        if (indexPath.row == 0) {
//            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"newOrders"] isEqualToString:@"0"])
//            {
//                [((UILabel *)[cell1 viewWithTag: 100 +indexPath.row]) setHidden:YES];
//            }
//            else
//            {
//                ((UILabel *)[cell1 viewWithTag:100 +indexPath.row]).text = [[NSUserDefaults standardUserDefaults] objectForKey:@"newOrders"] ;
//                [((UILabel *)[cell1 viewWithTag:100 +indexPath.row]) setHidden:NO];
//                
//            }
//        }
//        
        if(indexPath.row == 1)
        {
            
            if(![[NSUserDefaults standardUserDefaults] objectForKey:@"unMsgCount"] ||[[[NSUserDefaults standardUserDefaults] objectForKey:@"unMsgCount"] isEqualToString:@"0"])
            {
                [((UILabel *)[cell1 viewWithTag:100 +indexPath.row]) setHidden:YES];
            }
            else
            {
                ((UILabel *)[cell1 viewWithTag:100 +indexPath.row]).text = [[NSUserDefaults standardUserDefaults] objectForKey:@"unMsgCount"];
                [((UILabel *)[cell1 viewWithTag:100 +indexPath.row]) setHidden:NO];
                
            }
            
        }
        return cell1;
        
    }
    else if (indexPath.section == 2)
    {
    
        cell2.textLabel.text=[_array2 objectAtIndex:indexPath.row];
       // cell2.textLabel.font = [UIFont systemFontOfSize:13];

        cell2.accessoryView = (UIView *)[[UIImageView alloc ] initWithImage:[UIImage imageNamed:@"未标题-3_12.png"]];
        [cell2.accessoryView setFrame:CGRectMake(290, 12, 10, 10)];
        
        cell2.backgroundColor=eliuyan_color(0xf5f5f5);
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
 
        return cell2;
    
    }
   
    
    
  
    return nil;
    
    
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogIn"] isEqualToString:@"1"])
    {
        
        MemberCenterViewController *memCenter = [[MemberCenterViewController alloc] init];
        UINavigationController * nav = [[NavViewController alloc] initWithRootViewController:memCenter];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
        
    }
    else
    {
    
//        if (IOS_VERSION < 7)
//        {
//            [self setHidesBottomBarWhenPushed:YES];
//        }
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            MyAcountViewController *myAcount = [[MyAcountViewController alloc] init];
            [self.navigationController pushViewController:myAcount animated:YES];
        }
        else if(indexPath.row == 1)
        {
            NSLog(@"修改昵称");
            ChangeAppelViewController *changeAppel = [[ChangeAppelViewController alloc] init];
            [changeAppel getBackName:(^(NSString *str)
                                      {
                                          NSLog(@"=====>%@",str);
                                          ((UILabel *)[tableView viewWithTag:222]).text = str;
                                          
                                      })];
            
            [self.navigationController pushViewController:changeAppel animated:YES];
        }
        else if (indexPath.row == 2)
        {
        
            NSLog(@"修改密码");
            ChangePswViewController *changeVC=[[ChangePswViewController alloc] init];
            [self.navigationController pushViewController:changeVC animated:YES];

            
        
        }
    }
    else if(indexPath.section == 1)
    {
    
        if (indexPath.row == 0)
        {
            NewListViewController *newList = [[NewListViewController alloc] init];
            [newList getBackOrder:^(NSString * str) {
                
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"newOrders"];
            ((UILabel *)[tableView viewWithTag:100 +indexPath.row]).text = [[NSUserDefaults standardUserDefaults] objectForKey:@"newOrders"];

                
            }];
            [self.navigationController pushViewController:newList animated:YES];
        }
        else if(indexPath.row == 1)
        {
        
            NSLog(@"我的消息");
            MyMessageViewController *myMessage = [[MyMessageViewController alloc] init];
            [myMessage getBackName:(^(NSString *str)
                                    {
                                        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"unMsgCount"];
                                        [((UILabel *)[tableView viewWithTag: 100 +indexPath.row]) setHidden:YES];
                                    })];
            [self.navigationController pushViewController:myMessage animated:YES];

            
            
        
        }
        else if(indexPath.row == 2)
        {
        
            
            NSLog(@"我的订单");
            MyOrderViewController *myOrderVC=[[MyOrderViewController alloc] init];
            
            [self.navigationController pushViewController:myOrderVC animated:YES];
        
        }
    
    
    
    
    }
    else if(indexPath.section == 2)
    {
    
        if (indexPath.row == 0)
        {
            NSLog(@"关于我们");
            AboutUsViewController *aboutUsVC=[[AboutUsViewController alloc] init];
            [self.navigationController pushViewController:aboutUsVC animated:YES];

        }
    
    
    
    }
    
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section==0) {
//        return 1;
//    }
//    return 0;
    if (IOS_VERSION < 7) {
        return 0;
    }
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *aView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    if (IOS_VERSION < 7) {
        aView.backgroundColor = [UIColor clearColor];
        return aView;
    }
    aView.backgroundColor = eliuyan_color(0xf2f2f2);
    
    return aView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *aView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    if (IOS_VERSION < 7) {
        aView.backgroundColor = [UIColor clearColor];
        return aView;
    }
    aView.backgroundColor = eliuyan_color(0xf2f2f2);
    
    return aView;
}


//- (void)viewWillDisappear:(BOOL)animated {
//    [self setHidesBottomBarWhenPushed:NO];
//    [super viewDidDisappear:animated];
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
