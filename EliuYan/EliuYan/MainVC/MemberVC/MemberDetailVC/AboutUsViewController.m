//
//  AboutUsViewController.m
//  ELiuYan
//
//  Created by shanchen on 14-4-24.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "AboutUsViewController.h"
#import "AppDelegate.h"
#import "Activity.h"
#import "DefineModel.h"
#import "WebViewController.h"

@interface AboutUsViewController ()
{
    Activity * myActivity;
}
@property (nonatomic,strong) AppDelegate * app;
@end

@implementation AboutUsViewController
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
//    self.nameLabel.text=@"关于我们";
    [self.orderView removeFromSuperview];
//    self.navigationItem.title = @"关于我们";
    NavCustom *nav=[[NavCustom alloc] init];
    [nav setNav:@"关于我们" mySelf:self];
    [appDelegate hidenTabbar];


    //初始化app
    _app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    //初始化数组
    dataArray = [[NSArray alloc] initWithObjects:@"去评分",@"欢迎页",@"使用条款", nil];
    
    NSLog(@"self view frame height is %f",self.view.frame.size.height);
    
    
    //初始化logo
    UIImageView * imageLogo = [[UIImageView alloc] initWithFrame:CGRectMake(110, 40, 100, 90)];
    [imageLogo setImage:[UIImage imageNamed:@"关于我们_03.png"]];
    [self.view addSubview:imageLogo];
    
    //初始化版本号
    UILabel * versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageLogo.frame.origin.y+imageLogo.frame.size.height +10, 320, 20)];
    NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    versionLabel.text = [NSString stringWithFormat:@"一溜烟%@版",localVersion];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:versionLabel];
    
    //初始化table
    table = [[UITableView alloc ] initWithFrame:CGRectMake(5,versionLabel.frame.size.height+versionLabel.frame.origin.y+10 , 310, 150)];
    table.delegate = self;
    table.dataSource =self;
    table.backgroundColor = [UIColor clearColor];
    table.scrollEnabled = NO;
    [self.view addSubview:table];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }

    
    //初始化版权
    UILabel * CopyRight = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, 320, 20)];
    CopyRight.text = @"CopyRight©2011-2014 潮涌文化 版权所有";
    CopyRight.textAlignment = NSTextAlignmentCenter;
    CopyRight.font = [UIFont systemFontOfSize:12];
    CopyRight.backgroundColor = [UIColor clearColor];
    [self.view addSubview:CopyRight];
    
    
    
    
    
    //初始化菊花
    myActivity = [[Activity alloc] initWithActivity:self.view];


}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strid = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:strid];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IOS_VERSION < 7)
    {
        [self setHidesBottomBarWhenPushed:YES];
    }
    
    
    if(indexPath.row == 0)
    {
        if(IOS_VERSION >= 6.0)
       {
           [myActivity start];
           
           
           [self evaluate];
       }
        else
        {
            [myActivity start];
            NSString *str = [NSString stringWithFormat:
                             @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",
                             768005105 ];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            [myActivity stop];
            
        }

    }
    else if(indexPath.row==1)
    {
        //加载宣传动画
        [_app createScrollerView];
    }
    else
    {
        //[myActivity start];
         WebViewController *webVC = [[WebViewController alloc] init];
        webVC.url=aboutUsHtml;
        webVC.name=@"使用条款";
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

//ios7方法
//应用内评价
- (void)evaluate
{
    
    //初始化控制器
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    //设置代理请求为当前控制器本身
    storeProductViewContorller.delegate = self;
    
    //加载一个新的视图展示
    [storeProductViewContorller loadProductWithParameters:
     //appId唯一的
     @{SKStoreProductParameterITunesItemIdentifier : @"768005105"} completionBlock:^(BOOL result, NSError *error) {
         //block回调
         if(result){
             [myActivity stop];
             //模态弹出appstore
             [self presentViewController:storeProductViewContorller animated:YES completion:^{
             }
              ];
             
         }
         else
         {
             [myActivity stop];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接App Store错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
             [alert show];
         }
     }];
}

//取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    
    [self dismissViewControllerAnimated:YES completion:^{

    }];
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
