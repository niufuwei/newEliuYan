//
//  ShoppingViewController.m
//  ELiuYan
//
//  Created by shanchen on 14-4-22.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "ShoppingViewController.h"
#import "MenuViewController.h"
#import "StoreCell.h"
#import "httpRequest.h"
#import "MJRefresh.h"
#import "MJRefreshFooterView.h"
#import "BuyShopping.h"
#import "newVersion.h"
#import "AppDelegate.h"
#import "WebViewController.h"
@interface ShoppingViewController ()
{
    NSInteger pageIndex;
    newVersion * NVersion;
    
    UIPageControl * pageControl;
    UIImageView *image;
    
    UIImageView *locationView;

    
    
    
}
@property (nonatomic,strong) MJRefreshFooterView * footer;

@end

@implementation ShoppingViewController
@synthesize userLocation;
//@synthesize tableView=_tableView;

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
     [self hideTabBar:YES];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        
        NVersion = [[newVersion alloc] init];
        [NVersion begin:@"http://itunes.apple.com/lookup?id=768005105" boolBegin:NO];
    }


    //self.title = @"购物";
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:1];
    self.tabBarItem = tabBarItem;
    
    self.view.backgroundColor=eliuyan_color(0xf5f5f5);

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
        
        //NavCustom *nav=[[NavCustom alloc] init];
        //[nav setNav:@"一溜烟" mySelf:self];
        
       
        
        
        
        pageIndex = 0;
        
        [self addFooter];
        
        //  //获取当前位置坐标
        self.userLocation = [[BMKUserLocation alloc] init];
        [self.userLocation startUserLocationService];
        self.userLocation.delegate = self;
        
        search = [[BMKSearch alloc] init];
        search.delegate = self;
        
        //添加当前位置的View
        locationView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 80, 320, 32)];
        locationView.image = [UIImage imageNamed:@"首页 背景.png"];
        locationView.userInteractionEnabled = YES;
        
        
//        //分割线
//        UIImageView *lineImageView1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"线4.png"]];
//        lineImageView1.frame=CGRectMake(0, 0, 320, 1);
//        [locationView addSubview:lineImageView1];
        
        
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 1, 50, 30)];
        label.font=[UIFont systemFontOfSize:15];
        label.backgroundColor=[UIColor clearColor];
        label.text=@"当前:";
        label.textColor=[UIColor whiteColor];
        [locationView addSubview:label];
        
        //显示位置的label
        _locationLabel=[[UILabel alloc] initWithFrame:CGRectMake(55, 0, 200, 30)];
        _locationLabel.backgroundColor=[UIColor clearColor];
        _locationLabel.textColor=[UIColor whiteColor];
        [locationView addSubview:_locationLabel];
        
        
        
//        //分割线
//        UIImageView *lineImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"线4.png"]];
//        lineImageView.frame=CGRectMake(0, 30, 320, 1);
//        [locationView addSubview:lineImageView];
        
        //添加刷新按钮
        UIButton *refreshBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        refreshBtn.frame=CGRectMake(280, 3, 24, 24);
        [refreshBtn setBackgroundImage:[UIImage imageNamed:@"刷新.png"] forState:UIControlStateNormal];
        [refreshBtn addTarget:self action:@selector(refreshBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [locationView addSubview:refreshBtn];
        
        
        [self.view addSubview:locationView];
        
        
        //添加表
        if (IOS_VERSION >=7.0) {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 113, 320, self.view.frame.size.height-64-113-49) style:UITableViewStylePlain];
        }
        else
        {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 113, 320, self.view.frame.size.height-64-113+20-49) style:UITableViewStylePlain];
        }
        
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_tableView setHidden:YES];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        {
            _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        [self.view addSubview:_tableView];
        
        isRefresh = TRUE;
        
        
        
        [self createScrollerView];
        
        
        
        
        //加载菊花
        activity=[[Activity alloc] initWithActivity:self.view];
        [activity start];
        //判断如果没有开启手机定位 要有个提示
        //判断是否是程序第一次运行 如果是就不需要判断
    }
    
}
#pragma mark--
#pragma mark ----JCTopicDelegate
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
        _Topic = [[JCTopic alloc] initWithFrame:CGRectMake(10, 0, 300, 80)];
    }
    else
    {
        _Topic = [[JCTopic alloc] initWithFrame:CGRectMake(10, 0, 300, 80)];
    }
    
    [_Topic setBackgroundColor:eliuyan_color(0xf5f5f5)];
    _Topic.JCdelegate = self;
    
    [self.view addSubview:_Topic];
    
    
    //pagecontrol 的初始化
    if(!iPhone5)
    {
        pageControl= [[UIPageControl alloc] initWithFrame:CGRectMake(0, 70, 320, 20)];
    }
    else
    {
        pageControl= [[UIPageControl alloc] initWithFrame:CGRectMake(0,70, 320, 20)];
    }
    
    pageControl.currentPage=0;
    
    [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    
    
}
- (IBAction)pageTurn:(UIPageControl *)sender
{
    
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
    
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@store/BuyShoping",SERVICE_ADD]]];
    [request addPostValue:lng forKey:@"Lng"];
    [request addPostValue:lat forKey:@"Lat"];
    request.delegate=self;
    request.tag = 10086;
    request.timeOutSeconds=60;
    [request startAsynchronous];

    
}


#pragma mark_
#pragma mark - ASIHttpRequest
-(void)requestFinished:(ASIHTTPRequest *)request
{
//    NSLog(@"....%@",request.responseString);
    //初始化数组
    if (request.tag == 10086)
    {
     
    _storeDetailArray = [[NSMutableArray alloc] initWithCapacity:0];
    isRefresh = FALSE;

    [_loadView removeFromSuperview];
    [_tableView setHidden:NO];
    //显示当前位置
    SBJSON *json=[[SBJSON alloc] init];
    NSMutableDictionary *dic=[json objectWithString:request.responseString error:nil];
    NSString *aLocation=[dic objectForKey:@"Address"];
    _locationLabel.font=[UIFont systemFontOfSize:15];
        
       
    
    NSRange range = [aLocation rangeOfString:@"市"];
    NSString *substring = [aLocation substringFromIndex:NSMaxRange(range)];
    _locationLabel.text=[[NSString alloc] initWithFormat:@"%@",substring];

    [[NSUserDefaults standardUserDefaults] setObject:substring forKey:@"searchAddress"];
    //保存具体信息的数组
    NSMutableArray *array=[dic objectForKey:@"List"];
    NSLog(@"%@",array);
    if(array.count==0)
    {
        [activity stop];
        if (IOS_VERSION > 7) {
            _loadView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 113, 320, self.view.frame.size.height-113-49) image:@"无信息页面.png"];
        }
        else
        {
        _loadView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 113, 320, self.view.frame.size.height-113-49) image:@"无信息页面.png"];
            
        }
        
        [_loadView changeLabel:@"我尽力了，还是看不到"];
        [self.view addSubview:_loadView];
        
    }
    
    else
    {
        [_loadView removeFromSuperview];
        for (int i=0; i<[array count]; i++) {
            NSDictionary *detailDic=[array objectAtIndex:i];
          BuyShopping*_buyShop=[[BuyShopping alloc] init];
            //当前位置与店铺的距离
            NSString *delivery=[detailDic objectForKey:@"Delivery"];
            _buyShop.delivery=delivery;
            
            //店铺编号
            NSString *storeId=[detailDic objectForKey:@"Id"];
            _buyShop.storeId=storeId;
            //店铺LoGo
            NSString *logo=[detailDic objectForKey:@"LogUrl"];
            _buyShop.logUrl=logo;
            //店铺类型
            NSString *storeTypeName=[detailDic objectForKey:@"StoreTypeName"];
            _buyShop.storeTypeName=storeTypeName;
            //起送价格
            NSString *minBuy=[detailDic objectForKey:@"MinBuy"];
            _buyShop.minBuy=minBuy;
            //店铺名称
            NSString *storeNam=[detailDic objectForKey:@"StoreName"];
            
            _buyShop.storeName=storeNam;
            
//            NSLog(@"....=%@",_buyShop.storeName);
            //店铺地址
            NSString * address = [detailDic objectForKey:@"AddressInfo"];
            _buyShop.address = address;
            
            //店铺联系方式
            NSString * phone = [detailDic objectForKey:@"TelPhone"];
            _buyShop.phone = phone;
            
            //店铺营业开始时间
            NSString * stratTime = [detailDic objectForKey:@"StartTime"];
            _buyShop.strattime = stratTime;
            
            //店铺关门时间
            NSString * stopTime = [detailDic objectForKey:@"EndTime"];
            _buyShop.stopTime = stopTime;
            
            //店铺种类
            NSString * storeType = [detailDic objectForKey:@"StoreType"];
            _buyShop.storeType = storeType;
            
            
            //店铺的描述
            NSString *description = [detailDic objectForKey:@"Description"];
            _buyShop.description = description;
            
            
            [_storeDetailArray addObject:_buyShop];
            
        }
        //刷新表
        
        [_tableView reloadData];
        [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
       

        [activity stop];
        
    }
    }
    
    else if (request.tag == 10010)
    {
    
       //解析数据
        SBJSON *json=[[SBJSON alloc] init];
        NSDictionary *allDict=[json objectWithString:request.responseString error:nil];
        NSLog(@"公告栏数据是%@",allDict);
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
                for (int i= 0 ; i<array.count; i++)
                {
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

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"request tag is %d",request.tag);
    [activity stop];
    isRefresh = FALSE;
    if (IOS_VERSION > 7) {
        _loadView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 113, 320, self.view.frame.size.height-113-49) image:@"无信息页面.png"];
    }
    else
    {
        _loadView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 113, 320, self.view.frame.size.height-113-49) image:@"无信息页面.png"];
        
    }
    [_loadView changeLabel:@"我尽力了，还是看不到"];
    [self.view addSubview:_loadView];

}


#pragma mark_
#pragma mark - BtnClick

//刷新按钮
-(void)refreshBtnClick:(id)sender
{
    NSLog(@"刷新按钮被点击了");
    [_loadView removeFromSuperview];
    if(!isRefresh)
    {
        isRefresh = TRUE;
        [activity start];
        //获取当前位置坐标
        //    [_mapView setShowsUserLocation:YES];
        [self.userLocation startUserLocationService];
    }
}


#pragma mark -
#pragma mark - UITableViewDelegate

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _storeDetailArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifer=@"Cell";
    StoreCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if (cell==nil)
    {
        NSArray *aCell=[[NSBundle mainBundle] loadNibNamed:@"StoreCell" owner:nil options:nil];
        cell=[aCell objectAtIndex:0];
        cell.backgroundColor= eliuyan_color(0xf5f5f5);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
  BuyShopping*buyShop=[_storeDetailArray objectAtIndex:indexPath.row];
    
    if ([buyShop.storeTypeName isEqualToString:@"超市"])
    {
        [cell.logoImage setImage:[UIImage imageNamed:@"选择店铺_超市.png"]];
    }
    else if ([buyShop.storeTypeName isEqualToString:@"水果店"])
    {
        [cell.logoImage setImage:[UIImage imageNamed:@"选择店铺_水果店.png"]];

    }
    else
    {
        [cell.logoImage setImage:[UIImage imageNamed:@"选择店铺_杂货店.png"]];
    }
    
    cell.descriptionLabel.text=buyShop.description;
    
    
   
    
    cell.nameLabel.text=[NSString stringWithFormat:@"由%@经营",buyShop.storeName];

    
    float distance=[buyShop.delivery floatValue];
    cell.distanceLabel.textColor = eliuyan_color(0xe94f4f);
    if (distance>=1.0) {
        cell.distanceLabel.text=[NSString stringWithFormat:@"%.1f千米",distance];
    }
    else
    {
        if (distance*1000<100.00) {
            cell.distanceLabel.text=@"100米以内";
        }
        else if (distance*1000>=100.00&&distance*1000<200.00)
        {
            cell.distanceLabel.text=@"200米以内";
        }
        else if (distance*1000>=100.00&&distance*1000<300.00)
        {
            cell.distanceLabel.text=@"300米以内";
        }
        else if (distance*1000>=300.00&&distance*1000<400.00)
        {
            cell.distanceLabel.text=@"400米以内";
        }else if (distance*1000>=400.00&&distance*1000<500.00)
        {
            cell.distanceLabel.text=@"500米以内";
        }else if (distance*1000>=500.00&&distance*1000<600.00)
        {
            cell.distanceLabel.text=@"600米以内";
        }else if (distance*1000>=600.00&&distance*1000<700.00)
        {
            cell.distanceLabel.text=@"700米以内";
        }else if (distance*1000>=700.00&&distance*1000<800.00)
        {
            cell.distanceLabel.text=@"800米以内";
        }else if (distance*1000>=800.00&&distance*1000<900.00)
        {
            cell.distanceLabel.text=@"900米以内";
        }else if (distance*1000>=900.00&&distance*1000<1000.00)
        {
            cell.distanceLabel.text=@"1000米以内";
        }
        
        
        CGFloat min = [buyShop.minBuy floatValue];
        cell.minBuy.text =[NSString stringWithFormat:@"%.f元起送",min];
        
        
        NSString *startTime = [buyShop.strattime substringWithRange:NSMakeRange(11, 5)];
        NSString *stopTime = [buyShop.stopTime substringWithRange:NSMakeRange(11, 5)];
        cell.timeLabel.font = [UIFont systemFontOfSize:12.0];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",startTime,stopTime];
        
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

//    if (IOS_VERSION < 7)
//    {
//        [self setHidesBottomBarWhenPushed:YES];
//    }

   BuyShopping* _buyShop=[_storeDetailArray objectAtIndex:indexPath.row];
    //进入店铺界面
    MenuViewController *menuVC=[[MenuViewController alloc] init];
    //得到商铺编号 商铺名称  商铺类型
    menuVC.storeId=_buyShop.storeId;
    menuVC.storeName=_buyShop.storeName;
    menuVC.storeType=_buyShop.storeTypeName;
    
    //描述
    [[NSUserDefaults standardUserDefaults] setObject:_buyShop.description forKey:@"StoreDescription"];
    //商铺名称
    [[NSUserDefaults standardUserDefaults] setObject:_buyShop.storeName forKey:@"StoreName"];
    //起送价格
    [[NSUserDefaults standardUserDefaults] setObject:_buyShop.minBuy forKey:@"MinBuy"];
    //商铺logo
    [[NSUserDefaults standardUserDefaults] setObject:_buyShop.logUrl forKey:@"LogUrl"];
    //商铺距离
    [[NSUserDefaults standardUserDefaults] setObject:_buyShop.delivery forKey:@"Delivery"];
    //店铺地址
    [[NSUserDefaults standardUserDefaults] setObject:_buyShop.address forKey:@"Address"];
    //店铺联系方式
    [[NSUserDefaults standardUserDefaults] setObject:_buyShop.phone forKey:@"TelPhone"];
    //店铺营业开始时间
    [[NSUserDefaults standardUserDefaults] setObject:_buyShop.strattime forKey:@"StartTime"];
    //店铺结束时间
    [[NSUserDefaults standardUserDefaults] setObject:_buyShop.stopTime forKey:@"EndTime"];

    //商铺编号
    [[NSUserDefaults standardUserDefaults] setObject:_buyShop.storeId forKey:@"storeId"];
    //商铺类型
    [[NSUserDefaults standardUserDefaults] setObject:_buyShop.storeTypeName forKey:@"storeTypeName"];
    
    //[self.tabBarController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:menuVC animated:YES];
}
- (void) hideTabBar:(BOOL) hidden{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    
    for(UIView *view in self.tabBarController.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, iPhone5?568:480, view.frame.size.width, view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, iPhone5?568-49:480-49, view.frame.size.width, view.frame.size.height)];
            }
        }
        else
        {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, iPhone5?568:480)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,  iPhone5?568-49:480-49)];
            }
        }
    }
    
    [UIView commitAnimations];
}
-(void)viewWillAppear:(BOOL)animated
{
   
    [appDelegate showTabbar];
    
    UIImageView * topTitleView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 10, 60, 20)];
    topTitleView.image = [UIImage imageNamed:@"切图_179.png"];
    topTitleView.tag = 12345;
    [self.navigationController.navigationBar addSubview:topTitleView];
}
-(void)viewWillDisappear:(BOOL)animated
{

    [[self.navigationController.navigationBar viewWithTag:12345] removeFromSuperview];

}
- (void)addFooter
{
    __unsafe_unretained ShoppingViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = _tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        pageIndex++;
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:0.0];
        
    };
    _footer = footer;
    
}
- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [_tableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
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
