//
//  OldAddressViewController.m
//  ELiuYan
//
//  Created by laoniu on 14-5-1.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "OldAddressViewController.h"
#import "OldAddressCell.h"
#import "AppDelegate.h"
#import "MemberCenterViewController.h"
#import "NavViewController.h"
static NSString *no_select_backImageName = @"返回.png";
static NSString *selected_backImageName = @"返回.png";
@interface OldAddressViewController ()
{
    NSMutableDictionary * MutableDictionary;
    NSString *returnValues;
    BOOL isDelete;
}

@end

@implementation OldAddressViewController
@synthesize table;

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
    
    //判断之前选择的地址是点击的状态
    
    

    self.view.backgroundColor=eliuyan_color(0xf5f5f5);

    MutableDictionary = [[NSMutableDictionary alloc] init];
    _dataArray = [[NSMutableArray alloc] init];

    isDelete  = TRUE;
    
    NavCustom * nav = [[NavCustom alloc] init];
    [nav setNav:@"曾用地址" mySelf:self];
    
    if (IOS_VERSION >=7.0) {
            table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-64)];

    }
    else
    {
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44+20)];

    }

    table.delegate =self;
    table.dataSource =self;
    table.backgroundColor = eliuyan_color(0xf5f5f5);
    table.separatorColor = UITableViewCellSeparatorStyleNone;
    table.showsVerticalScrollIndicator=NO;
    table.hidden=YES;
    [self.view addSubview:table];
    [self setExtraCellLineHidden:table];
    
    //加载左边按钮
    
    [self setLeftItem:self];
    
    // Do any additional setup after loading the view.
}
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
-(void) setLeftItem: (UIViewController *)VC{
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:no_select_backImageName];
    
    backButton.backgroundColor=[UIColor clearColor];
    backButton.frame = CGRectMake(-20, 0, 12, 20);
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton setBackgroundImage: [UIImage imageNamed:selected_backImageName] forState:UIControlStateHighlighted];
    
    [backButton addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    if([UIDevice currentDevice].systemVersion.floatValue >= 7.0f){
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -7.5;
        VC.navigationItem.leftBarButtonItems = @[negativeSpacer, leftButtonItem];
    }
    else{
        VC.navigationItem.leftBarButtonItem = leftButtonItem;
    }
}

-(void)popself
{
    if(!isDelete)
    {
        [table reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)httpRequestError:(NSString *)str
{
    [ac stop];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strID = @"cellid";
    OldAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
    
    if(cell == nil)
    {
        cell = [[OldAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
        
    }
    cell.backgroundColor=eliuyan_color(0xf5f5f5);
    NSString * address =  [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Address"];
    
    NSRange range;
    range = [address rangeOfString:@"区"];
    if (range.location != NSNotFound) {
        NSString * str = [address substringFromIndex:range.location+1];
        cell.AddressInformation.text = str;
        cell.Address.text = [address substringToIndex:range.location+1];
    

    }else{
//        NSLog(@"Not Found");
        NSString * Address = [address substringToIndex:address.length/2];
        NSString * AddressInformation = [address substringFromIndex:address.length/2];

        cell.AddressInformation.text =AddressInformation;
        cell.Address.text= Address;
    }

    cell.choose.tag = indexPath.row+1;
    [cell.choose addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
       //判断如果是第一次进入的话默认第一个地址是选中的状态，否则 根据用户点击的地址 为选中的状态

        if(indexPath.row==[[[NSUserDefaults standardUserDefaults] objectForKey:@"witchCell"] intValue])
        {
            [MutableDictionary setObject:@"isChoose" forKey:[NSString stringWithFormat:@"%d",indexPath.row+1]];
        }
        
        if([[MutableDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.row+1]] isEqualToString:@"isChoose"])
        {
            [cell.choose setBackgroundImage:[UIImage imageNamed:@"单选-选中 .png"] forState:UIControlStateNormal];
            
        }
        else
        {
            [cell.choose setBackgroundImage:[UIImage imageNamed:@"单选-未选中 .png"] forState:UIControlStateNormal];
            
        }

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isDelete)
    {
        OldAddressCell * aCell = (OldAddressCell*)[table cellForRowAtIndexPath:indexPath];
        
        UIButton * btn = (UIButton *)[aCell viewWithTag:indexPath.row+1];
        
        OldAddressCell * AddressCell = (OldAddressCell*)[[btn superview] superview];
        
        //记录下来你当前点击的是哪个cell
        
        _str=[NSString stringWithFormat:@"%d",indexPath.row];
        //保存到本地
        [[NSUserDefaults standardUserDefaults ] setObject:_str forKey:@"witchCell"];
        
        if(![[MutableDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.row+1]] isEqualToString:@"isChoose"])
        {
            
            OldAddressCell * cell = (OldAddressCell*)[table cellForRowAtIndexPath:indexPath];
            [cell.choose setBackgroundImage:[UIImage imageNamed:@"单选-未选中 .png"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"单选-选中 .png"] forState:UIControlStateNormal];
            [MutableDictionary setObject:@"isChoose" forKey:[NSString stringWithFormat:@"%d",btn.tag]];
            
        }
        else
        {
            NSLog(@"你已经选中");
        }
        NSLog(@">>>%@>>>%@",AddressCell.Address.text,AddressCell.AddressInformation.text);
        _myBlock([NSString stringWithFormat:@"%@%@",AddressCell.Address.text,AddressCell.AddressInformation.text]);
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }

}






//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    isDelete = FALSE;
    CurrentPath = indexPath;
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    isDelete = TRUE;
}

//进入编辑模式
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //code
     if (editingStyle == UITableViewCellEditingStyleDelete)
     {
         isDelete = TRUE;
         NSLog(@"%@",_dataArray);
         
        
         NSLog(@"token is %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"]);
         [ac start];
         httpRequest *http = [[httpRequest alloc] init];
         http.httpDelegate = self;
         [http httpRequestSend:[NSString stringWithFormat:@"%@user/DeleteAddress",SERVICE_ADD] parameter:[NSString stringWithFormat:@"Id=%@&Token=%@",[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Id"],[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"]] backBlock:^(NSDictionary * dic) {
             
//             NSLog(@">>>>%@",dic);
             
             if([[dic allKeys] count]==0)
             {
                 NSLog(@"我是空的");
                 
             }
             else
             {
                 //判断是否账号已被登录
                 if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"88"])
                 {
                     UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"警告" message:@"您的账号在别处登录,请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                     alertView.delegate=self;
                     alertView.tag=333;
                     [alertView show];
                     [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hasLogIn"];
                     [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Token"];
                 }
                 else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
                 {

                     NSLog(@"删除地址成功");
                     //如果选中的地址被删除让他默认选中第一个地址
                     if (indexPath.row==[[[NSUserDefaults standardUserDefaults] objectForKey:@"witchCell"] intValue]) {
                         [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"witchCell"];
                         [table reloadData];
                         [MutableDictionary removeAllObjects];
                         
                     }
                        [_dataArray removeObjectAtIndex:indexPath.row];//移除数据源的数据
                         [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
                       [table reloadData];
                     if (_dataArray.count==0) {
                         [self.navigationController popViewControllerAnimated:YES];
                     }
                     
      
                 }
                 else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"99"])
                 {
                     
                     
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"系统异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                     [alert show];
                     self.view.userInteractionEnabled = YES;
                     
                     
                 }

             }
             
             [ac stop];

         }];
         
     }
    
    if([_dataArray count]==0)
    {
        table.hidden=YES;
    }

}

-(void)getAddress:(void (^)(NSString *))addres
{
    _myBlock = addres;
}

-(IBAction)onClick:(id)sender
{
    if(isDelete)
    {
        UIButton * btn = (UIButton *)sender;
        
        OldAddressCell * AddressCell = (OldAddressCell*)[[btn superview] superview];
        
        NSIndexPath *indexPath=[table indexPathForCell:AddressCell];
        //记录下来你当前点击的是哪个cell
        
        _str=[NSString stringWithFormat:@"%d",indexPath.row];
        //保存到本地
        [[NSUserDefaults standardUserDefaults ] setObject:_str forKey:@"witchCell"];
        
        if(![[MutableDictionary objectForKey:[NSString stringWithFormat:@"%d",btn.tag]] isEqualToString:@"isChoose"])
        {
            
            NSIndexPath * index = [NSIndexPath indexPathForRow:btn.tag-1 inSection:0];
            OldAddressCell * cell = (OldAddressCell*)[table cellForRowAtIndexPath:index];
            
            [cell.choose setBackgroundImage:[UIImage imageNamed:@"单选-未选中 .png"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"单选-选中 .png"] forState:UIControlStateNormal];
            [MutableDictionary setObject:@"isChoose" forKey:[NSString stringWithFormat:@"%d",btn.tag]];
            
        }
        else
        {
            NSLog(@"你已经选中");
        }
        
        _myBlock([NSString stringWithFormat:@"%@%@",AddressCell.Address.text,AddressCell.AddressInformation.text]);
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

#pragma mark -
#pragma mark -UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isBack"];
        //跳转到登录界面
        MemberCenterViewController *memberVC=[[MemberCenterViewController alloc] init];
        UINavigationController *nav = [[NavViewController alloc] initWithRootViewController:memberVC];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
       // [self removeFromParentViewController];
    }
    
    else
    {
    
        [self.navigationController popViewControllerAnimated:YES];
    
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [appDelegate hidenTabbar];
    httpRequest * addRequest = [[httpRequest alloc] init];
    
    ac = [[Activity alloc] initWithActivity:self.view];
    [ac start];
    
    [addRequest httpRequestSend:[NSString stringWithFormat:@"%@user/GetMyAddress",SERVICE_ADD] parameter:[NSString stringWithFormat:@"UserId=%@&Lng=%@&Lat=%@&Token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"],[[NSUserDefaults standardUserDefaults] objectForKey:@"lng"],[[NSUserDefaults standardUserDefaults] objectForKey:@"lat"],[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"]] backBlock:(^(NSDictionary * dic){
        
        //判断是否账号已被登录
        if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"88"])
        {
            [ac stop];
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"警告" message:@"您的账号在别处登录,请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            
            
            
            alertView.delegate=self;
            alertView.tag=222;
            [alertView show];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hasLogIn"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Token"];
        }
        
        else
        {
            NSLog(@"%@",dic);
            table.hidden=NO;
            
            if ([[dic objectForKey:@"List"] count]==0) {
                //给个提示
                _loadView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
                [_loadView changeLabel:@"您还没有曾用地址哦"];
                [self.view addSubview:_loadView];
            }
            else
            {
                //                NSLog(@">>>>>>>%@",[dic objectForKey:@"List"]);
                for(int i=0;i<[[dic objectForKey:@"List"] count];i++)
                {
                    [_dataArray addObject:[[dic objectForKey:@"List"] objectAtIndex:i]];
                }
                [table reloadData];
            }
            
        }
        [ac stop];
    })];
    


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
