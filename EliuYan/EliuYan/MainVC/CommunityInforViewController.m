//
//  CommunityInforViewController.m
//  EliuYan
//
//  Created by laoniu on 14-7-3.
//  Copyright (c) 2014年 eliuyan.com. All rights reserved.
//

#import "CommunityInforViewController.h"
#import "NavCustom.h"

@interface CommunityInforViewController ()
{
    NavCustom * myNavCustom;
}
@end

@implementation CommunityInforViewController
@synthesize userLocation;

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
    [myNavCustom setNav:@"切换小区" mySelf:self];
    [appDelegate hidenTabbar];

    //初始化可用变量
    _dataArray = [[NSMutableArray alloc] init];
    
    
    if(![CLLocationManager locationServicesEnabled]) {
        NSLog(@"没有开启");
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isCLLocationFirst"] isEqualToString:@"no"])
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在系统设置中开启定位服务（设置->隐私->定位服务->开启一溜烟）" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"isCLLocationFirst"];
        }
        
    }
    else
    {
        //  //获取当前位置坐标
        self.userLocation = [[BMKUserLocation alloc] init];
        [self.userLocation startUserLocationService];
        self.userLocation.delegate = self;
        
        search = [[BMKSearch alloc] init];
        search.delegate = self;
        
        //添加当前位置的View
        UIView *locationView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 32)];
        [locationView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"缴费 物业费背景.png"]]];
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 30)];
        label.font=[UIFont systemFontOfSize:15];
        label.backgroundColor=[UIColor clearColor];
        label.text=@"当前位置：";
        label.textColor=[UIColor whiteColor];
        [locationView addSubview:label];
        
        //显示位置的label
        _locationLabel=[[UILabel alloc] initWithFrame:CGRectMake(80, 0, 220, 30)];
        _locationLabel.backgroundColor=[UIColor clearColor];
        _locationLabel.textColor=[UIColor whiteColor];
        [locationView addSubview:_locationLabel];
        
        
        
        //分割线
//        UIImageView *lineImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"线4.png"]];
//        lineImageView.frame=CGRectMake(10, 30, 300, 1);
//        [locationView addSubview:lineImageView];
        
        //添加刷新按钮
        UIButton *refreshBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        refreshBtn.frame=CGRectMake(280, 2.5, 25, 25);
        [refreshBtn setBackgroundImage:[UIImage imageNamed:@"刷新.png"] forState:UIControlStateNormal];
        [refreshBtn addTarget:self action:@selector(refreshBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [locationView addSubview:refreshBtn];
        
        [self.view addSubview:locationView];
        
        //初始化表
        _tabel = [[UITableView alloc] initWithFrame:CGRectMake(0, locationView.frame.size.height+locationView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-(locationView.frame.size.height+locationView.frame.origin.y)-64)];
        _tabel.delegate = self;
        _tabel.dataSource = self;
        [self.view addSubview:_tabel];
    }
    
    [self setExtraCellLineHidden:_tabel];
    
    ac = [[Activity alloc] initWithActivity:self.view];
    [ac start];

    // Do any additional setup after loading the view.
}

-(void)getComName:(void (^)(NSString *,NSString*,NSString*))bl
{
    if(self)
    {
        _myBlock= bl;
    }
}

//获取物理位置信息
-(void)onGetAddrResult:(BMKSearch *)searcher result:(BMKAddrInfo *)result errorCode:(int)error
{
    if(error==0)
    {
        
    }
}

#pragma mark -
#pragma mark MAPKIT

-(void)viewDidGetLocatingUser:(CLLocationCoordinate2D)userLoc
{
    NSLog(@"取得的经纬度是%f   %f",userLoc.latitude,userLoc.longitude);
    NSString *lat=[NSString stringWithFormat:@"%f",userLoc.latitude];
    NSString *lng=[NSString stringWithFormat:@"%f",userLoc.longitude];
    //存到本地
    [[NSUserDefaults standardUserDefaults] setObject:lat forKey:@"lat"];
    
    [[NSUserDefaults standardUserDefaults] setObject:lng forKey:@"lng"];
    
    
    [self.userLocation stopUserLocationService];
    
    //发送请求
    
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@store/GetCommunityList",SERVICE_ADD]]];
    [request addPostValue:lng forKey:@"Lng"];
    [request addPostValue:lat forKey:@"Lat"];
    request.delegate=self;
    request.timeOutSeconds=60;
    [request startAsynchronous];
    
    
}
#pragma mark_
#pragma mark - ASIHttpRequest
-(void)requestFinished:(ASIHTTPRequest *)request
{
    [ac stop];
    isRefresh = FALSE;
    
    //显示当前位置
    SBJSON *json=[[SBJSON alloc] init];
    NSMutableDictionary *dic=[json objectWithString:request.responseString error:nil];
    NSString *aLocation=[dic objectForKey:@"Address"];
    _locationLabel.font=[UIFont systemFontOfSize:15];
    
    NSRange range = [aLocation rangeOfString:@"市"];
    NSString *substring = [aLocation substringFromIndex:NSMaxRange(range)];
    _locationLabel.text=[[NSString alloc] initWithFormat:@"%@",substring];

    _dataArray = [dic objectForKey:@"List"];
    NSLog(@"%@",_dataArray);
    if([_dataArray count]==0)
    {
    
        loadView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) image:@"无信息页面.png"];
        [loadView changeLabel:@"抱歉,没有搜到附近的小区"];
        [self.view addSubview:loadView];
        
    }
    else
    {
        [_tabel reloadData];
    }

}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"请求失败");
    //加载出错界面
    LoadingView *aLloadView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) image:@"无服务.png"];
    [aLloadView changeLabel:@"您的网络出小差了哦"];
    [self.view addSubview:aLloadView];
    [self.view bringSubviewToFront:aLloadView];
}

#pragma mark_
#pragma mark - BtnClick

//刷新按钮
-(void)refreshBtnClick:(id)sender
{
    NSLog(@"刷新按钮被点击了");
    if(!isRefresh)
    {
        [ac start];
        isRefresh = TRUE;
        //获取当前位置坐标
        //    [_mapView setShowsUserLocation:YES];
        [self.userLocation startUserLocationService];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if(cell ==nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
    }
    if([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"StoreName"] isEqualToString:_CommunityName])
    {
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [image setImage:[UIImage imageNamed:@"单选-选中 .png"]];
        cell.accessoryView = image;
    }
    else
    {
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [image setImage:[UIImage imageNamed:@"单选-未选中 .png"]];
        cell.accessoryView = image;
    }
 
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    cell.textLabel.text = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"StoreName"];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    return cell;
}
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    _myBlock(cell.textLabel.text,[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Id"],[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"TelPhone"]);
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
