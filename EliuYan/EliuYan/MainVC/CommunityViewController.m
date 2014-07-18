//
//  CommunityViewController.m
//  EliuYan
//
//  Created by eliuyan_mac on 14-7-3.
//  Copyright (c) 2014年 eliuyan.com. All rights reserved.
//

#import "CommunityViewController.h"
#import "CommunityInforViewController.h"
#import "PropertyCostViewController.h"
#import "NavCustom.h"
#import "MaintenanceViewController.h"
#import "LoadingView.h"

@interface CommunityViewController ()
{
    NavCustom * myNavCustom;
}

@end

@implementation CommunityViewController
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
    self.view.backgroundColor=eliuyan_color(0xf5f5f5);

    //初始化导航条
    myNavCustom = [[NavCustom alloc] init];
    [myNavCustom setNav:@"社区服务" mySelf:self];
    
    //初始化可用变量
    _CommunityName = @"请选择";
    _dataArray = [NSArray arrayWithObjects:@"上门维修", nil];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor =[UIColor clearColor];
    table.scrollEnabled= NO;
    [self.view addSubview:table];
    myActivity = [[Activity alloc] initWithActivity:self.view];
    [myActivity start];

    httpRequest * http = [[httpRequest alloc] init];
    http.httpDelegate = self;
    [http httpRequestSend:[NSString stringWithFormat:@"%@store/GetRecentCommunity",SERVICE_ADD] parameter:[NSString stringWithFormat:@"Lng=%@&Lat=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"lng"],[[NSUserDefaults standardUserDefaults]objectForKey:@"lat"]] backBlock:^(NSDictionary *str) {
        [myActivity stop];
        _CommunityName = [[str objectForKey:@"StoreName"] length]==0?@"请选择":[str objectForKey:@"StoreName"];
        _stroeID = [str objectForKey:@"StoreId"];
        _telPhone = [str objectForKey:@"TelPhone"];
        [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if([[str objectForKey:@"StoreName"] length]==0)
        {
            LoadingView* _loadView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
            _loadView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) image:@"无服务.png"];
            [_loadView changeLabel:@"喔哦,社区服务暂未覆盖您的小区"];
            [self.view addSubview:_loadView];        }
    }];
   
    
    // Do any additional setup after loading the view.
}

-(void)httpRequestError:(NSString *)str
{
    [myActivity stop];
   LoadingView* _loadView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    _loadView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) image:@"无服务.png"];
    [_loadView changeLabel:@"喔哦,社区服务暂未覆盖您的小区"];
    [self.view addSubview:_loadView];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section ==0)
    {
        return 1;
    }
    else
    {
        return [_dataArray count];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0)
    {
        return 40;
    }
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * strID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
    
    if(cell==nil)
    {
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
//        UIImageView * imageHeng = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-1, self.view.frame.size.width, 1)];
//        [imageHeng setBackgroundColor:[UIColor blackColor]];
//        [cell addSubview:imageHeng];

//        if(indexPath.section == 1)
//        {
//            if(indexPath.row ==0)
//            {
//                UIImageView * imageHeng2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
//                [imageHeng2 setBackgroundColor:[UIColor blackColor]];
//                [cell addSubview:imageHeng2];
//
//            }
//        }
//        colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 220, 40)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = NSTextAlignmentRight;
        nameLabel.tag = 606;
        nameLabel.textColor = [UIColor whiteColor];
        [cell addSubview:nameLabel];
        
    }
    if(indexPath.section ==0)
    {
        UIImageView * image = [[UIImageView alloc] initWithFrame:cell.frame];
        [image setImage:[UIImage imageNamed:@"缴费 物业费背景.png"]];
        cell.backgroundView =image;
        

        cell.textLabel.text = @"小区";
        
       
       ((UILabel *)[cell viewWithTag:606]).text = _CommunityName;
        
        
        
        
        UIImageView * image2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
        [image2 setImage:[UIImage imageNamed:@"进入2.png"]];
        cell.accessoryView = image2;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    else
    {
        cell.backgroundColor= [UIColor clearColor];
        cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
        [image setImage:[UIImage imageNamed:@"进入.png"]];
        cell.accessoryView = image;
        
        UIImageView * imageHeng = [[UIImageView alloc] initWithFrame:CGRectMake(15,55 ,self.view.frame.size.width-30, 1)];
        [imageHeng setBackgroundColor:[UIColor colorWithRed:218.0/255.0 green:217.0/255.0 blue:206.0/255.0 alpha:1]];
        [cell addSubview:imageHeng];

    }
    table.separatorStyle =UITableViewCellSeparatorStyleNone;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (IOS_VERSION < 7)
//    {
//        [self setHidesBottomBarWhenPushed:YES];
//    }
    if(indexPath.section ==0)
    {
        CommunityInforViewController * infor = [[CommunityInforViewController alloc] init];
        infor.CommunityName = _CommunityName;
        [infor getComName:^(NSString *name,NSString * storeid,NSString*phone) {
            
            _CommunityName = name;
            _stroeID = storeid;
            _telPhone = phone;
            [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        [self.navigationController pushViewController:infor animated:YES];
    }
    else
    {
       if(indexPath.row == 0)
       {
           MaintenanceViewController * main = [[MaintenanceViewController alloc] init];
           main.storeID = _stroeID;
           [[NSUserDefaults standardUserDefaults] setObject:_CommunityName forKey:@"StoreName"];
           [[NSUserDefaults standardUserDefaults] setObject:_telPhone forKey:@"TelPhone"];
           [[NSUserDefaults standardUserDefaults] setObject:@"--" forKey:@"StoreDescription"];
           [[NSUserDefaults standardUserDefaults] setObject:_stroeID forKey:@"storeId"];
           [self.navigationController pushViewController:main animated:YES];
       }
        else
        {
            if([_CommunityName isEqualToString:@"请选择"])
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择小区" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                PropertyCostViewController * property = [[PropertyCostViewController alloc] init];
                property.CommunityName = _CommunityName;
                [self.navigationController pushViewController:property animated:YES];
            }
            
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{    self.tabBarController.tabBar.hidden = YES;
    [appDelegate showTabbar];
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
