//
//  MyMessageViewController.m
//  ELiuYan
//
//  Created by eliuyan_mac on 14-4-28.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "MyMessageViewController.h"
#import "httpRequest.h"
#import "AppDelegate.h"
#import "DefineModel.h"
#import "MessageCell.h"
#import "MemberCenterViewController.h"
#import "NavViewController.h"
#import "LoadingView.h"


@interface MyMessageViewController ()

@end

@implementation MyMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)getBackName:(void (^)(NSString *))backName
{
    if(self)
    {
        _backName = backName;
    }
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
    
        [self loadUI];
    
    }


}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.nameLabel.text = @"消息中心";
//    self.navigationItem.title = @"消息中心";
    NavCustom *nav=[[NavCustom alloc] init];
    [nav setNav:@"消息中心" mySelf:self];
    
    [appDelegate hidenTabbar];

    [self.orderView removeFromSuperview];
    _pageIndex = 0;
    _messageArray = [[NSMutableArray alloc] init];
    
    if (IOS_VERSION < 7.0)
    {
        _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 45)];

    }
    else
    {
        _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height -20)];

    }
    _messageTableView.delegate = self;
    _messageTableView.dataSource = self;
    _messageTableView.backgroundColor=eliuyan_color(0xf5f5f5);
    _messageTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_messageTableView];
   activity = [[Activity alloc] initWithActivity:self.view];

    [self setLeftItem];
    
    

    
}


-(void)loadMore{
    // Load some data here, it may take some time
    [self performSelector:@selector(loadFinish) withObject:nil afterDelay:0.0];
    
    //    [self performSelectorOnMainThread:@selector(loadFinish) withObject:nil waitUntilDone:YES];
}

-(void)loadFinish{
    
    if (_pageIndex >= _totalMessagePage - 1)
    {
        if (!_isRemove) {
            _isRemove=TRUE;
            _aView=[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height-65, 100, 25)];
            _aView.backgroundColor=[UIColor blackColor];
            UILabel *aLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, _aView.frame.size.width, _aView.frame.size.height)];
            aLabel.font=[UIFont systemFontOfSize:13];
            aLabel.textAlignment=YES;
            aLabel.textColor=[UIColor whiteColor];
            aLabel.backgroundColor = [UIColor clearColor];
            aLabel.text=@"没有更多消息";
            [_aView addSubview:aLabel];
            [self.view addSubview:_aView];
            //1秒后消失
            [self performSelector:@selector(removeView) withObject:self afterDelay:1];
            
        }
        
        
        
        return;
    }
    
    _pageIndex++;
    
    [activity start];
    
    httpRequest *http = [[httpRequest alloc] init];
    http.httpDelegate = self;
    
    [http httpRequestSend:[NSString stringWithFormat:@"%@user/GetMyMessageList",SERVICE_ADD] parameter:[NSString stringWithFormat:@"UserId=%@&PageIndex=%d&Token=%@",[appDelegate.appDefault objectForKey:@"UserId"],_pageIndex,[appDelegate.appDefault objectForKey:@"Token"]] backBlock:^(NSDictionary * dic) {
        
        if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
        {
            
            [_messageArray addObjectsFromArray:[dic objectForKey:@"List"]];
            [self.messageTableView reloadData];
            
            [activity stop];
            
            
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"99"])
        {
            [activity stop];
            _pageIndex--;
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
            _pageIndex = 0;
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LoginName"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ReallyName"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hasLogIn"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Token"];
            
        }
    }];

}

-(void)removeView
{
    [_aView removeFromSuperview];
    _isRemove=FALSE;
}

-(void)loadUI
{
    
    [activity start];
    
    httpRequest *http = [[httpRequest alloc] init];
    http.httpDelegate = self;
    
    [http httpRequestSend:[NSString stringWithFormat:@"%@user/GetMyMessageList",SERVICE_ADD] parameter:[NSString stringWithFormat:@"UserId=%@&PageIndex=%d&Token=%@",[appDelegate.appDefault objectForKey:@"UserId"],_pageIndex,[appDelegate.appDefault objectForKey:@"Token"]] backBlock:^(NSDictionary *dic) {
        
        
        
        
        if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
        {
            if ([[dic objectForKey:@"TotalCount"] intValue] == 0)
            {
                [activity stop];
                
                [self.messageTableView removeFromSuperview];
                
//                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 50, 100, 100)];
//                imageView.image = [UIImage imageNamed:@"无信息页面.png"];
//                [self.view addSubview:imageView];
//                
//                UILabel *noMessage = [[UILabel alloc] initWithFrame:CGRectMake(60,170, 200, 30)];
//                noMessage.text = @"您最近没有新消息哦";
////                noMessage.textColor = [UIColor grayColor];
//                noMessage.textAlignment = NSTextAlignmentCenter;
//                noMessage.backgroundColor = [UIColor clearColor];
//                [self.view addSubview:noMessage];
                //提示没有最新消息
                LoadingView *loadView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) image:@"无信息页面.png"];
                [loadView changeLabel:@"您最近没有新消息哦"];
                [self.view addSubview:loadView];
                return ;
            }

            self.totalMessageCount = [[dic objectForKey:@"TotalCount"] intValue];
            self.totalMessagePage = [[dic objectForKey:@"TotalPage"] intValue];
            NSLog(@"%d",_totalMessagePage);
            self.messageArray =[NSMutableArray arrayWithArray:[dic objectForKey:@"List"]];
            [self.messageTableView reloadData];
            [activity stop];
            
            
            
            
            
            
            
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"99"])
        {
            [self.messageTableView removeFromSuperview];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(108.25, 50, 103.5, 87.5)];
            imageView.image = [UIImage imageNamed:@"错误页面.png"];
            [self.view addSubview:imageView];
            
            
            UILabel *noMessage = [[UILabel alloc] initWithFrame:CGRectMake(60,150, 200, 30)];
            noMessage.text = @"喔哦，你走错了，请返回再试";
            noMessage.textColor = [UIColor grayColor];
            noMessage.textAlignment = NSTextAlignmentCenter;
            noMessage.backgroundColor = [UIColor clearColor];
            [self.view addSubview:noMessage];
            
            
            
            
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"88"])
        {
            [activity stop];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您的账号在别处登录,请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.tag = 2;
            alert.delegate = self;
            [alert show];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LoginName"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ReallyName"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hasLogIn"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Token"];
        }
    }];

    
    

}



-(void)httpRequestError:(NSString *)str;
{
    LoadingView *loadView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) image:@"无服务.png"];
    [loadView changeLabel:@"您的网络出小差了哦"];
    [self.view addSubview:loadView];
    [self.view bringSubviewToFront:loadView];
    
    [activity stop];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1 || alertView.tag ==2 || alertView.tag == 3 || alertView.tag == 4 || alertView.tag == 5)
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
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (_pageIndex+1 >= _totalMessagePage)
    {
        return [self.messageArray count];
        
    }
    else
    {
        if(_totalMessagePage >1)
        {
            return [self.messageArray count]+1;
            
        }
        else
        {
            return [self.messageArray count];
            
        }
    }


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 90.0;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *identifier = @"identifier";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

        cell.backgroundColor = eliuyan_color(0xf5f5f5);
       
//        cell.backgroundColor = eliuyan_color(0xf5f5f5);


    }
    else
    {
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
        
    }
    
    if(indexPath.row < _messageArray.count)
    {
    
        cell.timeLabel.hidden = NO;

        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        
        
        cell.contentLabel.text = [[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Content"];
        cell.contentLabel.tag = 1000 + indexPath.row;
        cell.contentLabel.textAlignment = NSTextAlignmentLeft;
        
        
        
        cell.timeLabel.text = [[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"CreateTime"];
        cell.timeLabel.tag = 10000 + indexPath.row;
        
        
        
        
        
        if ([[[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"IsRead"] isEqualToString:@"1"]) {
            ((UILabel *)[cell viewWithTag:1000 + indexPath.row ]).textColor = [UIColor grayColor];
            ((UILabel *)[cell viewWithTag:10000 + indexPath.row ]).textColor = [UIColor grayColor];
            
            //        cell.contentLabel.textColor = [UIColor grayColor];
            //        cell.timeLabel.textColor = [UIColor grayColor];
        }
        else
        {
            
            ((UILabel *)[cell viewWithTag:1000 + indexPath.row ]).textColor = [UIColor blackColor];
            ((UILabel *)[cell viewWithTag:10000 + indexPath.row ]).textColor = [UIColor blackColor];
            
            
        }

    }
    else
    {
        cell.timeLabel.hidden = YES;
        cell.contentLabel.text = @"正在加载...";
        cell.contentLabel.textAlignment = NSTextAlignmentCenter;
        [self loadMore];
    }
    
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{

    [((MessageCell*)[tableView cellForRowAtIndexPath:indexPath]) viewWithTag:100 + indexPath.row].hidden = YES;
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        
        [((MessageCell*)[tableView cellForRowAtIndexPath:indexPath]) viewWithTag:100 + indexPath.row].hidden = NO;



}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        httpRequest *http = [[httpRequest alloc] init];
        [http httpRequestSend:[NSString stringWithFormat:@"%@user/DeleteMsg",SERVICE_ADD] parameter:[NSString stringWithFormat:@"MsgId=%@&Token=%@",[[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Id"],[appDelegate.appDefault objectForKey:@"Token"]]  backBlock:^(NSDictionary * dic) {
            
            if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
            {
                NSLog(@"删除成功");
                _pageIndex = 0;
                [self loadUI];
                int row = indexPath.row;
                [_messageArray removeObjectAtIndex:row];
//                _deleteCount++;
//                if (_deleteCount== 8)
//                {
//                    _pageIndex--;
//                    
//                    _deleteCount = 0;
//                    _totalMessageCount--;
//                }
                // Delete the row from the data source.
                [_messageTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            }
            else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"88"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您的账号在别处登录,请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                alert.tag = 5;
                alert.delegate = self;
                [alert show];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LoginName"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ReallyName"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hasLogIn"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Token"];
            
            }
            
        }];
        
        
        
    
        
        
        
    }
    
    
   
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    httpRequest *http = [[httpRequest alloc] init];
    [http httpRequestSend:[NSString stringWithFormat:@"%@user/SetRead",SERVICE_ADD] parameter:[NSString stringWithFormat:@"Id=%@&Token=%@",[[_messageArray objectAtIndex:indexPath.row] objectForKey:@"Id"],[appDelegate.appDefault objectForKey:@"Token"]] backBlock:^(NSDictionary * dic) {
        
        if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
        {
            ((MessageCell *)[_messageTableView cellForRowAtIndexPath:indexPath]).timeLabel.textColor = [UIColor grayColor];
            ((MessageCell *)[_messageTableView cellForRowAtIndexPath:indexPath]).contentLabel.textColor = [UIColor grayColor];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self.messageArray objectAtIndex:indexPath.row]];
            [dic setObject:@"1" forKey:@"IsRead"];
            [self.messageArray replaceObjectAtIndex:indexPath.row withObject:dic];
            
            
        }
        
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"88"])
            
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您的账号在别处登录,请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.tag = 4;
            alert.delegate = self;
            [alert show];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LoginName"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ReallyName"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hasLogIn"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Token"];
        }
        
        
    }];
    
    

}
-(void ) setLeftItem{
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"返回.png"];
    
    backButton.backgroundColor=[UIColor clearColor];
    backButton.frame = CGRectMake(-20, 0, 12, 20);
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton setBackgroundImage: [UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    
    
    UIBarButtonItem* leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    if([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
    {
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
-(void)backToMain
{
    [self setRead];
    
}
-(void)setRead
{

    
    
    //取得所有未读的消息
    NSMutableArray * noReadArr = [[NSMutableArray alloc] initWithCapacity:1];
    for (id obj in self.messageArray)
    {
        if ([[((NSDictionary*)obj) objectForKey:@"IsRead"] isEqualToString:@"0"])
        {
            [noReadArr addObject:obj];
        }
    }

    if ([noReadArr count] > 0)
    {
        
    [activity start];
        httpRequest *http1 = [[httpRequest alloc] init];
        [http1 httpRequestSend:[NSString stringWithFormat:@"%@user/SetAllRead",SERVICE_ADD]  parameter:[NSString stringWithFormat:@"UserId=%@&Token=%@",[appDelegate.appDefault objectForKey:@"UserId"],[appDelegate.appDefault objectForKey:@"Token"]] backBlock:^(NSDictionary * dic) {
            
            if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
            {
                [activity stop];

                _backName(@"0");
                
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"allCount"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAllCount" object:nil];
                
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"99"])
            {
                [activity stop];
                
            }
            else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"88"])
            {
                [activity stop];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您的账号在别处登录,请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                alert.tag = 3;
                alert.delegate = self;
                [alert show];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LoginName"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ReallyName"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hasLogIn"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Token"];
            }
            
            
            
        }];
        
    }
    else
    {
        _backName(@"0");
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"allCount"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAllCount" object:nil];
    
        [self.navigationController popViewControllerAnimated:YES];

    
    
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
