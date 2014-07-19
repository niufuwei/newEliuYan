//
//  MaintenanceViewController.m
//  EliuYan
//
//  Created by laoniu on 14-7-4.
//  Copyright (c) 2014年 eliuyan.com. All rights reserved.
//

#import "MaintenanceViewController.h"
#import "MenuCell.h"
#import "ContentCell.h"
#import "AppDelegate.h"
#import "checkViewController.h"
#import "Activity.h"
#import "MJRefresh.h"
#import "CoreDataModel.h"

@interface MaintenanceViewController ()
{
    AppDelegate * app;
    NavCustom * customNav;
    Activity * activity;
    UILabel * advert;
    UIView * advertView;
    UIButton * commit;
}
@property (nonatomic,strong) MJRefreshFooterView * footer;

@end

@implementation MaintenanceViewController
@synthesize menuTable;
@synthesize ContentTable;
@synthesize contentSelectDictionary;
@synthesize menuSelectDictionary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [advertView removeFromSuperview];
    advertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [advertView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"上门维修-滚动背景-#ff9d9d.png"]]];
    [self.view addSubview:advertView];
    
    advert = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, self.view.frame.size.width-60, 40)];
    advert.textAlignment = NSTextAlignmentCenter;
    advert.text = @"正在加载社区通知...";
    //开始动画
    advert.backgroundColor = [UIColor clearColor];
    advert.font = [UIFont systemFontOfSize:15];
    advert.text = advertisement;
    advert.textColor =[ UIColor whiteColor];
    [advertView addSubview:advert];
    
    
    UIImageView * image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [image1 setImage:[UIImage imageNamed:@"上门维修-滚动背景-#ff9d9d.png"]];
    [advertView addSubview:image1];
    
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    [image setImage:[UIImage imageNamed:@"上门维修-滚动背景-图标.png"]];
    [advertView addSubview:image];

    [self startAnimationIfNeeded];
}
-(void)viewWillDisappear:(BOOL)animated
{

    detailStoreBtn.hidden = YES;

}
-(void)viewWillAppear:(BOOL)animated
{

    detailStoreBtn.hidden = NO;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    //初始化导航栏
    customNav = [[NavCustom alloc] init];
    [customNav setNav:@"上门维修" mySelf:self];
    customNav.NavDelegate = self;

    //[customNav setNavRightBtnImage:@"搜索.png" RightBtnSelectedImage:@"" mySelf:self width:27 height:20];
    
    
    detailStoreBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    detailStoreBtn.frame=CGRectMake(320-100, 7, 100, 26);
    detailStoreBtn.backgroundColor = [UIColor clearColor];
    [detailStoreBtn setHighlighted:NO];
    UIImageView *searchImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"搜索.png"]];
    searchImage.frame = CGRectMake(60, 4, 26, 20);
    [detailStoreBtn addSubview:searchImage];
    //[detailStoreBtn setBackgroundImage:[UIImage imageNamed:@"搜索.png"] forState:UIControlStateNormal];
    [detailStoreBtn addTarget:self action:@selector(detailStoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:detailStoreBtn];
    
    //加载导航栏左边按钮
    [self setLeftItem];
    
    //初始化数据变量
    _allData = [[NSMutableArray alloc] init];
    _pageIndex = 0;
    isFirstRun = TRUE;
    mCountService = 0;
    _IDDictionary = [[NSMutableDictionary alloc] init];
   // _menuArray = [[NSMutableArray alloc] init];
    app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app hidenTabbar];
    _ContentArray = [[NSMutableArray alloc] init];
    _menuNameArray  =[[NSMutableArray alloc] init];
    _menuIdArray = [[NSMutableArray alloc] init];
    contentSelectDictionary = [[NSMutableDictionary alloc] init];
    menuSelectDictionary = [[NSMutableDictionary alloc] init];
    //默认选中第0个
//    [menuSelectDictionary setObject:@"ok" forKey:[NSString stringWithFormat:@"%d",0]];
   
    
    //滚动广告视图设计
    advertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [advertView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"上门维修-滚动背景-#ff9d9d.png"]]];
    [self.view addSubview:advertView];
    
    advert = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, self.view.frame.size.width-60, 40)];
    advert.textAlignment = NSTextAlignmentCenter;
    advert.text = @"正在加载社区通知...";
    //开始动画
    advert.backgroundColor = [UIColor clearColor];
    advert.font = [UIFont systemFontOfSize:15];
    advert.textColor = [UIColor whiteColor];
    [advertView addSubview:advert];

    
    UIImageView * image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [image1 setImage:[UIImage imageNamed:@"上门维修-滚动背景-#ff9d9d.png"]];
    [advertView addSubview:image1];
    
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    [image setImage:[UIImage imageNamed:@"上门维修-滚动背景-图标.png"]];
    [advertView addSubview:image];
    
    
    //初始化table
    //菜单table
    menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 40,90, self.view.frame.size.height-40-40-20-44)];
    menuTable.delegate =self;
    menuTable.dataSource = self;
    menuTable.tag = 101;
    [menuTable setBackgroundColor:[UIColor clearColor]];
    menuTable.showsVerticalScrollIndicator = NO;

    [self.view addSubview:menuTable];
    
    //内容table
    ContentTable = [[UITableView alloc] initWithFrame:CGRectMake(90, 40, self.view.frame.size.width-90, self.view.frame.size.height-40-44-20-40)];
    ContentTable.delegate = self;
    ContentTable.dataSource = self;
    ContentTable.tag = 102;
    [ContentTable setBackgroundColor:[UIColor clearColor]];
    ContentTable.showsVerticalScrollIndicator = NO;
    [self.view addSubview:ContentTable];
    
    
    //加载底部视图
    [self initBottomView];
    
    //异步获取菜单栏
    
    //加载菊花
    activity=[[Activity alloc] initWithActivity:self.view];
    [activity start];
    
    //发送请求
    //    NSLog(@"????????=%@",[appDelegate.appDefault objectForKey:@"UserId"]);
    httpRequest *request=[[httpRequest alloc] init];
    //判断userId 是否为空
    request.httpDelegate = self;
    
    [request httpRequestSend:[NSString stringWithFormat:@"%@store/CommunityNotice",SERVICE_ADD] parameter:[NSString stringWithFormat:@"StoreId=%@",_storeID] backBlock:^(NSDictionary *str) {
       advert.text = [str objectForKey:@"Notice"];
        advertisement  = [str objectForKey:@"Notice"];
       [self startAnimationIfNeeded];

    }];
    
    [self loadRequestData];
    //异步获取内容页面

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil]; //监听是否重新进入程序程序.
       // Do any additional setup after loading the view.
}

-(void)loadRequestData
{
    httpRequest *request=[[httpRequest alloc] init];
    request.httpDelegate = self;
    [request httpRequestSend:[NSString stringWithFormat:@"%@goods/GetCategoryList",SERVICE_ADD] parameter:[NSString stringWithFormat:@"UserId=%@&StoreId=%@",[appDelegate.appDefault objectForKey:@"UserId"],_storeID] backBlock:(^(NSDictionary *dic){
        //解析数据
        
        NSMutableArray * menuArr =[dic objectForKey:@"List"];
        if(menuArr.count==0)
        {
           LoadingView * _loadView2 = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) image:@"无信息页面.png"];
            [_loadView2 changeLabel:@"我尽力了，还是看不到"];
            [self.view addSubview:_loadView2];
            
        }
        else
        {
            
            for (int i=0; i<menuArr.count; i++) {
                NSDictionary *detailDic=[menuArr objectAtIndex:i];
                //类别名字
                NSString *category=[detailDic objectForKey:@"CategoryName"];
                [_menuNameArray addObject:category];
                //ID类型编号
                NSString *goodsId=[detailDic objectForKey:@"Id"];
                [_menuIdArray addObject:goodsId];
                
            }
            
            //刷新表
            [menuTable reloadData];
            [activity stop];
            //默认显示第一个列表
            [self request:0 :0];
        }
    }
)];

}

-(void)request:(int)indexPath :(int)aPage
{
    httpRequest *request=[[httpRequest alloc] init];
    request.httpDelegate=self;
    [request httpRequestSend:[NSString stringWithFormat:@"%@goods/GetGoodsList",SERVICE_ADD] parameter:[NSString stringWithFormat:@"UserId=%@&StoreId=%@&GoodsCategoryId=%@&PageIndex=%d",[appDelegate.appDefault objectForKey:@"UserId"],_storeID,[_menuIdArray objectAtIndex:indexPath] ,aPage] backBlock:(^(NSDictionary *dic){
        //解析数据
        //总页数
        totalPage=[dic objectForKey:@"TotalPage"];

        NSArray * listArray = [[NSArray alloc] init];
        listArray=[dic objectForKey:@"List"];
        
        for(int i=0;i<listArray.count;i++)
        {
            [_ContentArray addObject:[listArray objectAtIndex:i]];
            [_allData addObject:[listArray objectAtIndex:i]];
        }
        
        //刷新表
        [ContentTable reloadData];

//        [ContentTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];

    })];
    
}
-(void)httpRequestError:(NSString *)str
{
    //加载出错界面
    LoadingView *loadView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) image:@"无服务.png"];
    [loadView changeLabel:@"您的网络出小差了哦"];
    [self.view addSubview:loadView];
    [self.view bringSubviewToFront:loadView];
    
    [activity stop];
}

-(void)initBottomView
{
    UIView * bottomView ;
    
    if (IOS_VERSION < 7)
    {
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44-40, self.view.frame.size.width, 40)];
        
        CGRect yy = menuTable.frame;
        yy.size.height = self.view.frame.size.height-40 - 44 - 40;
        menuTable.frame = yy;
        
        
        CGRect yy1 = ContentTable.frame;
        yy1.size.height = self.view.frame.size.height-40 - 44 - 40;
        ContentTable.frame = yy1;
        
    }
    else
    {
    
      bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-64-40, self.view.frame.size.width, 40)];
    
    
    }
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *lineImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"线4.png"]];
    lineImageView.frame=CGRectMake(0, 0, 320, 1);
    [bottomView addSubview:lineImageView];

    
    //购买的服务个数
    numberService = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 40)];
    numberService.backgroundColor = [UIColor clearColor];
    numberService.textAlignment = NSTextAlignmentCenter;
    numberService.textAlignment = NSTextAlignmentLeft;
    numberService.textColor = [UIColor colorWithRed:233.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1];
    [bottomView addSubview:numberService];
    
    //购买的价格
    numberPrice = [[UILabel alloc] initWithFrame:CGRectMake(numberService.frame.size.width+numberService.frame.origin.x+5, 0, 150, 40)];
    numberPrice.backgroundColor = [UIColor clearColor];
    numberPrice.textAlignment = NSTextAlignmentCenter;
    numberPrice.textAlignment = NSTextAlignmentLeft;
    numberPrice.textColor = [UIColor colorWithRed:233.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1];
    numberPrice.text = @"共                元";
    [bottomView addSubview:numberPrice];
    
    //购买的价格2222
    Price = [[UILabel alloc] initWithFrame:CGRectMake(numberService.frame.size.width+numberService.frame.origin.x+40, 0, 110, 40)];
    Price.backgroundColor = [UIColor clearColor];
    Price.textAlignment = NSTextAlignmentCenter;
    Price.textAlignment = NSTextAlignmentLeft;
    Price.textColor = [UIColor colorWithRed:233.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1];
    if([Price.text length]==0)
    {
        [numberService setHidden:YES];
        [numberPrice setHidden:YES];
    }
    [bottomView addSubview:Price];
    
    //下一步
    
    UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame= CGRectMake(self.view.frame.size.width - 70, 5.5, 60, 30);
//    nextButton.layer.borderColor = [UIColor grayColor].CGColor;
//    nextButton.layer.borderWidth=1;
//    nextButton.backgroundColor = [UIColor clearColor];
//    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
//    [nextButton setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
//    [nextButton setBackgroundImage:[UIImage imageNamed:@"结算-未按.png"] forState:UIControlStateNormal];
//    [nextButton setBackgroundImage:[UIImage imageNamed:@"结算-未按.png"] forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [nextButton setTitle:@"结算" forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [nextButton setBackgroundColor:eliuyan_color(0xe94f4f)];
     nextButton.adjustsImageWhenHighlighted = NO;
    nextButton.tag = 103;
    [nextButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:nextButton];
    
    [self.view addSubview:bottomView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 101)
    {
        return [_menuNameArray count];
    }
    else
    {
        if (_pageIndex+1 >= [totalPage intValue])
        {
            return [_ContentArray count];

        }
        if([totalPage intValue] >1)
        {
            return [_ContentArray count]+1;
        }
        else
        {
            return [_ContentArray count];
        }

    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==101) {
        return 60;
    }
    else
        return 90;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag ==101)
    {
        static NSString * strID = @"cell_menu";
        MenuCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
        if(cell == nil)
        {
            cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
            UIImageView *backImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"水果店_分隔条.png"]];
            backImage.frame=CGRectMake(0,59, 90, 1);
            [cell.contentView addSubview:backImage];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        
        if(isFirstRun && [_menuIdArray objectAtIndex:indexPath.row])
        {
            [menuSelectDictionary setObject:@"ok" forKey:[_menuIdArray objectAtIndex:0]];
            isFirstRun = FALSE;
        }
        //判断是否被选中
        if([[menuSelectDictionary objectForKey:[_menuIdArray objectAtIndex:indexPath.row]] isEqualToString:@"ok"])
        {
            [menuSelectDictionary setObject:@"ok" forKey:[_menuIdArray objectAtIndex:indexPath.row]];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.MenuName.textColor = [UIColor colorWithRed:233.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1];

        }
        else
        {
            [menuSelectDictionary setObject:@"no" forKey:[_menuIdArray objectAtIndex:indexPath.row]];
            cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"超市、物业左边栏背景.png"]];
             cell.MenuName.textColor = [UIColor blackColor];
        }
        cell.MenuName.text = [_menuNameArray objectAtIndex:indexPath.row];
        if([[_IDDictionary allKeys] count] ==0 || ![_IDDictionary objectForKey:[_menuIdArray objectAtIndex:indexPath.row]] || [[_IDDictionary objectForKey:[_menuIdArray objectAtIndex:indexPath.row]] isEqualToString:@"0"])
        {
            [cell.number setHidden:YES];
        }
        else
        {
            [cell.number setHidden:NO];
            [cell.number setTitle:[_IDDictionary objectForKey:[_menuIdArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];

        }
        return cell;

    }
    else
    {
        
        static NSString * strID = @"cell_content";
        ContentCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
        if(cell == nil)
        {
            cell = [[ContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
        }

        cell.textLabel.text = @"";
        if([_ContentArray count]==0)
        {
            return cell;
        }
        else{
            
            cell.logoImage.hidden = NO;
            cell.money.hidden=  NO;
            cell.selectButton.hidden= NO;
            
            if(indexPath.row <[_ContentArray count])
            {
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                
                [cell.logoImage setImageWithURL:[NSURL URLWithString:[[_ContentArray objectAtIndex:indexPath.row] objectForKey:@"Image"]] placeholderImage:[UIImage imageNamed:@"暂无.png"]];
                cell.title.text = [[_ContentArray objectAtIndex:indexPath.row] objectForKey:@"GoodsName"];
                cell.money.text  = [NSString stringWithFormat:@"￥%@",[[_ContentArray objectAtIndex:indexPath.row] objectForKey:@"Price"]];
                
                cell.selectButton.tag = indexPath.row+1;
                [cell.selectButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell setBackgroundColor:[UIColor clearColor]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                
                //判断如果是第一次进入的话默认第一个地址是选中的状态，否则 根据用户点击的地址 为选中的状态
                
                if([[contentSelectDictionary objectForKey:[[_ContentArray objectAtIndex:indexPath.row] objectForKey:@"Id"]] isEqualToString:@"isChoose"])
                {
                    [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"多选-选择.png"] forState:UIControlStateNormal];
                    
                }
                else
                {
                    [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"多选-未选 .png"] forState:UIControlStateNormal];
                    
                }
                
                //根据搜索按钮按下与否来决定table的cell的frame
                if(isSearchButtonPressed)
                {
                    cell.title.frame= CGRectMake(cell.logoImage.frame.size.width+cell.logoImage.frame.origin.x+5, 15, 180, 40);
                    cell.selectButton.frame = CGRectMake(self.view.frame.size.width -50, 30, 30, 30);
                    
                }
                else
                {
                    
                }
                
            }
            else
            {
                cell.title.text = @"正在加载...";
                cell.logoImage.hidden = YES;
                cell.money.hidden=  YES;
                cell.selectButton.hidden= YES;
                [self loadMore];
                
            }

        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    if([_menuIdArray count]==0 || [_ContentArray count]==0)
    {
        NSLog(@"休息一会");
    }
    else
    {
        [_aView removeFromSuperview];

        if(tableView.tag==101)
        {
            [ContentTable setContentOffset:CGPointMake(0, 0) animated:NO];
            
            
            BOOL isSelected = FALSE;
            for(int i=0;i<[[menuSelectDictionary allKeys] count];i++)
            {
                if([[menuSelectDictionary objectForKey:[[menuSelectDictionary allKeys] objectAtIndex:i]] isEqualToString:@"ok"])
                {
                    if([_menuIdArray objectAtIndex:indexPath.row] == [[menuSelectDictionary allKeys] objectAtIndex:i])
                    {
                        isSelected = TRUE;
                        break;
                    }
                    else
                    {
                        
                        NSIndexPath * index = [NSIndexPath indexPathForItem:selectMenuRow inSection:0];
                        [menuSelectDictionary removeObjectForKey:[[menuSelectDictionary allKeys] objectAtIndex:i]];
                        MenuCell * cell2 = (MenuCell*)[menuTable cellForRowAtIndexPath:index];
                        [cell2.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"超市、物业左边栏背景.png"]]];
                        
                         cell2.MenuName.textColor = [UIColor blackColor];
                    }
                }
            }
            
            if(!isSelected)
            {
                MenuCell * cell = (MenuCell*)[menuTable cellForRowAtIndexPath:indexPath];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.MenuName.textColor = [UIColor colorWithRed:233.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1];
                [menuSelectDictionary setObject:@"ok" forKey:[_menuIdArray objectAtIndex:indexPath.row]];
                [_ContentArray removeAllObjects];
                _pageIndex = 0;
                [self request:indexPath.row :0];
                
            }
            selectMenuRow = indexPath.row;

        }
        else
        {
            ContentCell * cell;

            if(isSearchButtonPressed)
            {
               cell = (ContentCell*)[searchTable cellForRowAtIndexPath:indexPath];

            }
            else
            {
                cell = (ContentCell*)[ContentTable cellForRowAtIndexPath:indexPath];
            }
            
            if(![[contentSelectDictionary objectForKey:[[_ContentArray objectAtIndex:indexPath.row] objectForKey:@"Id"]] isEqualToString:@"isChoose"])
            {
                [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"多选-选择.png"] forState:UIControlStateNormal];
                [contentSelectDictionary setObject:@"isChoose" forKey:[[_ContentArray objectAtIndex:indexPath.row] objectForKey:@"Id"]];
                [self setMenuNumber:1 row:indexPath.row];
                mCountService ++;
                if([Price.text length]==0)
                {
                    Price.text = [[_ContentArray objectAtIndex:indexPath.row] objectForKey:@"Price"];
                }
                else
                {
                    Price.text = [NSString stringWithFormat:@"%.2f",[Price.text floatValue] + [[[_ContentArray objectAtIndex:indexPath.row] objectForKey:@"Price"] floatValue]];
                }
                
                numberPrice.hidden = NO;
                numberService.hidden = NO;
                numberService.text = [NSString stringWithFormat:@"%d项服务",mCountService];
            }
            else
            {
                mCountService --;
                [self setMenuNumber:-1 row:indexPath.row];
                
                [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"多选-未选 .png"] forState:UIControlStateNormal];
                [contentSelectDictionary setObject:@"" forKey:[[_ContentArray objectAtIndex:indexPath.row] objectForKey:@"Id"]];
                
                if(mCountService<=0)
                {
                    Price.text = @"";
                    numberPrice.hidden = YES;
                    numberService.hidden = YES;
                    numberService.text = [NSString stringWithFormat:@"%d项服务",mCountService];
                    mCountService =0;
                    
                }
                else
                {
                    Price.text = [NSString stringWithFormat:@"%.2f",[Price.text floatValue] - [[[_ContentArray objectAtIndex:indexPath.row] objectForKey:@"Price"] floatValue]];
                    numberPrice.hidden = NO;
                    numberService.hidden = NO;
                    numberService.text = [NSString stringWithFormat:@"%d项服务",mCountService];
                    
                }
                
            }
            
        }

    }
}

-(void)setMenuNumber:(NSInteger)number row:(NSInteger)row
{
    NSIndexPath * index = [NSIndexPath indexPathForItem: [_menuIdArray indexOfObject:[[_ContentArray objectAtIndex:row] objectForKey:@"GoodsCategoryId"]] inSection:0];
    MenuCell * cell = (MenuCell*)[menuTable cellForRowAtIndexPath:index];
    cell.number.hidden = NO;

    if(number>0)
    {
        [_IDDictionary setObject:[NSString stringWithFormat:@"%d",[[_IDDictionary objectForKey:[[_ContentArray objectAtIndex:row] objectForKey:@"GoodsCategoryId"]] intValue]+1] forKey:[[_ContentArray objectAtIndex:row] objectForKey:@"GoodsCategoryId"]];
    
        [cell.number setTitle:[_IDDictionary objectForKey:[[_ContentArray objectAtIndex:row] objectForKey:@"GoodsCategoryId"]] forState:UIControlStateNormal];
    }
    else
    {
        if([[_IDDictionary objectForKey:[[_ContentArray objectAtIndex:row] objectForKey:@"GoodsCategoryId"]] intValue]-1<=0)
        {
            [cell.number setHidden:YES];
            [cell.number setTitle:[ NSString stringWithFormat:@"%d",0] forState:UIControlStateNormal];
            [_IDDictionary setObject:[NSString stringWithFormat:@"%d",0] forKey:[[_ContentArray objectAtIndex:row] objectForKey:@"GoodsCategoryId"]];

            
        }
        else
        {
            [_IDDictionary setObject:[NSString stringWithFormat:@"%d",[[_IDDictionary objectForKey:[[_ContentArray objectAtIndex:row] objectForKey:@"GoodsCategoryId"]] intValue]-1] forKey:[[_ContentArray objectAtIndex:row] objectForKey:@"GoodsCategoryId"]];

            [cell.number setTitle:[_IDDictionary objectForKey:[[_ContentArray objectAtIndex:row] objectForKey:@"GoodsCategoryId"]] forState:UIControlStateNormal];

        }
        
    }

    
}
-(IBAction)onClick:(id)sender
{

    UIButton * btn = (UIButton *)sender;
    if(btn.tag ==103)
    {
        if(mCountService ==0||!mCountService)
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请购买商品" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
            [alert show];
        }
        else
        {
            NSMutableArray * tempArray = [[NSMutableArray alloc] init];
            for(NSString * str in [contentSelectDictionary allKeys])
            {
                if([[contentSelectDictionary objectForKey:str] isEqualToString:@"isChoose"])
                {
                    for(int i=0;i<[_allData count] ;i++)
                    {
                        if([[[_allData objectAtIndex:i] objectForKey:@"Id"] isEqualToString:str])
                        {
                            [tempArray addObject:[_allData objectAtIndex:i]];
                            break;
                        }
                    }
                }
            }
            NSString * numSer = [NSString stringWithFormat:@"%d",mCountService];
            
            NSMutableDictionary * typeDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:Price.text,@"price",numSer,@"service",tempArray,@"data",nil];
            
            checkViewController * check = [[checkViewController alloc] init];
            check.contentDictionary = typeDic;
            [self.navigationController pushViewController:check animated:YES];
        }
       
    }
    else
    {
        if([_menuIdArray count]==0 || [_ContentArray count]==0)
        {
            NSLog(@"休息一会");
        }
        else
        {
            if(![[contentSelectDictionary objectForKey:[[_ContentArray objectAtIndex:btn.tag-1] objectForKey:@"Id"]] isEqualToString:@"isChoose"])
            {
                [btn setBackgroundImage:[UIImage imageNamed:@"多选-选择.png"] forState:UIControlStateNormal];
                [contentSelectDictionary setObject:@"isChoose" forKey:[[_ContentArray objectAtIndex:btn.tag-1] objectForKey:@"Id"]];
                
                [self setMenuNumber:1 row:btn.tag-1];
                
                mCountService ++;
                if([Price.text length]==0)
                {
                    Price.text = [[_ContentArray objectAtIndex:btn.tag-1] objectForKey:@"Price"];
                }
                else
                {
                    Price.text = [NSString stringWithFormat:@"%.2f",[Price.text floatValue] + [[[_ContentArray objectAtIndex:btn.tag-1] objectForKey:@"Price"] floatValue]];
                }
                
                numberPrice.hidden = NO;
                numberService.hidden = NO;
                numberService.text = [NSString stringWithFormat:@"%d项服务",mCountService];
            }
            else
            {
                [btn setBackgroundImage:[UIImage imageNamed:@"多选-未选 .png"] forState:UIControlStateNormal];
                [contentSelectDictionary setObject:@"" forKey:[[_ContentArray objectAtIndex:btn.tag-1] objectForKey:@"Id"]];
                [self setMenuNumber:-1 row:btn.tag-1];
                
                
                mCountService --;
                if(mCountService<=0)
                {
                    Price.text = @"";
                    numberPrice.hidden = YES;
                    numberService.hidden = YES;
                    numberService.text = [NSString stringWithFormat:@"%d项服务",mCountService];
                    mCountService =0;
                    
                }
                else
                {
                    Price.text = [NSString stringWithFormat:@"%.2f",[Price.text floatValue] -[[[_ContentArray objectAtIndex:btn.tag-1] objectForKey:@"Price"] floatValue]];
                    numberPrice.hidden = NO;
                    numberService.hidden = NO;
                    numberService.text = [NSString stringWithFormat:@"%d项服务",mCountService];
                    
                }
                
            }

            
        }
        
    }
}

//点击导航栏右按钮触发
-(void)detailStoreBtnClick:(id)sender
{
    //    StoreDetailViewController *detailVC=[[StoreDetailViewController alloc] init];
    //    detailVC.type = self.storeType;
    //    [self.navigationController pushViewController:detailVC animated:YES];
    if(!isSearchButtonPressed)
    {
        self.navigationController.navigationBarHidden = YES;
        advertView.hidden = YES;
        searchView = [UIButton buttonWithType:UIButtonTypeCustom];
        searchView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        searchView.tag = 101;
        [searchView addTarget:self action:@selector(onClickSearch:) forControlEvents:UIControlEventTouchUpInside];
        [searchView setBackgroundImage:[UIImage imageNamed:@"alphaClean.png"] forState:UIControlStateNormal];
        [self.view addSubview:searchView];
        [self showInView];
        isSearchButtonPressed = TRUE;
        
    }
}

#pragma mark -
#pragma mark - 搜索功能实现

-(void)showInView
{
    //将现有数据保存起来
    _temp__goodsArray  = [NSMutableArray arrayWithArray:_ContentArray] ;
    
    UIView * myview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    [myview setBackgroundColor:[UIColor whiteColor]];
    [searchView addSubview:myview];
    
    UIView * textfieldBG = [[UIView alloc] initWithFrame:CGRectMake(10, 20+7.5, searchView.frame.size.width-80, 30)];
    [textfieldBG.layer setCornerRadius:3];
    [textfieldBG setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]];
    [searchView addSubview:textfieldBG];
    
    UIImageView * imgSearch = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20+15, 20, 15)];
    [imgSearch setImage:[UIImage imageNamed:@"搜索.png"]];
    [searchView addSubview:imgSearch];
    
    searchBar = [[UITextField alloc] initWithFrame:CGRectMake(40, 20+7.5, searchView.frame.size.width-110, 30)];
    searchBar.placeholder = @"请输入要搜索的内容...";
    searchBar.delegate = self;
    searchBar.keyboardType = UIReturnKeyDone;
    
    [searchBar addTarget:self action:@selector(onChange) forControlEvents:UIControlEventEditingChanged];
    searchBar.backgroundColor = [UIColor clearColor];
    [searchView setBackgroundColor:[UIColor clearColor]];
    [searchView addSubview:searchBar];
    [searchBar becomeFirstResponder];
    
    commit = [UIButton buttonWithType:UIButtonTypeCustom];
    commit.frame= CGRectMake(searchBar.frame.size.width+searchBar.frame.origin.x+5, 20+10, 60, 25);
    [commit setTitle:@"取消" forState:UIControlStateNormal];
    [commit addTarget:self action:@selector(onClickSearch:) forControlEvents:UIControlEventTouchUpInside];
    commit.tag = 102;
    [commit setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    commit.titleLabel.font = [UIFont systemFontOfSize:16];
    [searchView addSubview:commit];
    
    searchTable = [[UITableView alloc] initWithFrame:CGRectMake(0, myview.frame.size.height+myview.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-myview.frame.size.height-myview.frame.origin.y)];
    [searchView addSubview:searchTable];
    searchTable.delegate = self;
    searchTable.dataSource = self;
    searchTable.showsVerticalScrollIndicator = NO;
    _footer.scrollView = searchTable;
    searchTable.tag = 103;
    
    searchTable.hidden = YES;
    
    _loadView = [[LoadingView alloc] initWithFrame:CGRectMake(0, myview.frame.size.height+myview.frame.origin.y+20, 320, self.view.frame.size.height) image:@"无信息页面.png"];
    [_loadView changeLabel:@"没有搜索到数据"];
    [self.view addSubview:_loadView];
    _loadView.hidden = YES;

}

-(void)onChange
{
    isAddFooter = FALSE;
    [_ContentArray removeAllObjects];
    searchTable.hidden = NO;
    _pageIndex =0;
    if([searchBar.text length]!=0 && ![searchBar.text isEqualToString:@" "])
    {
        [commit setTitle:@"完成" forState:UIControlStateNormal];
        [self searchData:searchBar.text pageindex:_pageIndex];
    }
    if([searchBar.text isEqualToString:@" "] && [searchBar.text length] ==1)
    {
        searchBar.text= @"";
        [_loadView setHidden:NO];

    }
    if([searchBar.text length]==0)
    {
        [_ContentArray removeAllObjects];
        [_loadView setHidden:NO];

    }
    
    [searchTable reloadData];

}
#pragma mark--
#pragma mark 搜索的代理方法

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    [_ContentArray removeAllObjects];
//
//    searchTable.hidden = NO;
//    _pageIndex =0;
//    if([searchBar.text length]!=0 && ![textField.text isEqualToString:@" "])
//    {
//        [self searchData:textField.text pageindex:_pageIndex];
//    }
//    if([textField.text isEqualToString:@" "])
//    {
//        textField.text= @"";
//    }
//    if([searchBar.text length]==0)
//    {
//        [_ContentArray removeAllObjects];
//    }
//     [searchTable reloadData];
//    return YES;
//}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBard
{
    [searchBar resignFirstResponder];

    if([searchBar.text length]!=0 && ![searchBar.text isEqualToString:@" "])
    {
        [self searchData:searchBar.text pageindex:_pageIndex];
    }
}
#pragma mark --
#pragma mark 点击完成按钮
-(void)onClickSearch:(id)sender
{
    self.navigationController.navigationBarHidden = NO;
    advertView.hidden = NO;

    [_ContentArray removeAllObjects];
    isSearchButtonPressed = FALSE;
    [searchView removeFromSuperview];
    _ContentArray = [NSMutableArray arrayWithArray:_temp__goodsArray];
    _pageIndex =0;
    
    [ContentTable reloadData];
    _footer.scrollView = ContentTable;
 
    [_loadView removeFromSuperview];
    [menuTable reloadData];
}

-(void)searchData:(NSString*)str pageindex:(NSInteger)pageindex
{
    httpRequest *request=[[httpRequest alloc] init];
    //判断userId 是否为空
    //    NSLog(@"...%@",UserId);
    [request httpRequestSend:[NSString stringWithFormat:@"%@goods/GetSearchGoodsList",SERVICE_ADD] parameter:[NSString stringWithFormat:@"StoreId=%@&GoodsValue=%@&PageIndex=%d",_storeID,searchBar.text,pageindex] backBlock:(^(NSDictionary *dic){
        
        //总页数
        totalPage=[dic objectForKey:@"TotalPage"];
        NSArray * listArray = [[NSArray alloc] init];
        listArray=[dic objectForKey:@"List"];
    
        if(!isAddFooter)
        {
            [_ContentArray removeAllObjects];
        }
        
        for(int i=0;i<listArray.count;i++)
        {
            [_ContentArray addObject:[listArray objectAtIndex:i]];
        }
        
        NSLog(@"%d",[_ContentArray count]);
        //刷新表
        if([_ContentArray count]!=0)
        {
            [_loadView setHidden:YES];
            [searchTable reloadData];
        }
        else
        {
            [_loadView setHidden:NO];

        }
    })];
    
}


-(void)removeView
{
    [_aView removeFromSuperview];
    _isRemove=FALSE;
  
}

-(void)loadMore{
    // Load some data here, it may take some time
    [self performSelector:@selector(loadFinish) withObject:nil afterDelay:0.0];
    
    //    [self performSelectorOnMainThread:@selector(loadFinish) withObject:nil waitUntilDone:YES];
}

-(void)loadFinish{
    
    _pageIndex++;
    
    if (_pageIndex >= [totalPage intValue])
    {
        //添加一个提示view  提示商品加载完成了
        if (!_isRemove) {
            _isRemove=TRUE;
            _aView=[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height-65, 100, 25)];
            _aView.backgroundColor=[UIColor blackColor];
            UILabel *aLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, _aView.frame.size.width, _aView.frame.size.height)];
            aLabel.font=[UIFont systemFontOfSize:13];
            aLabel.textAlignment=YES;
            aLabel.textColor=[UIColor whiteColor];
            aLabel.backgroundColor = [UIColor clearColor];
            aLabel.text=@"没有更多商品";
            [_aView addSubview:aLabel];
            [self.view addSubview:_aView];
            //1秒后消失
            [self performSelector:@selector(removeView) withObject:self afterDelay:1];
            
        }
            return;
    }
    
    if(isSearchButtonPressed)
    {
        isAddFooter = TRUE;
        [self searchData:searchBar.text pageindex:_pageIndex];
        
    }
    else
    {
        [self request:[menuTable indexPathForSelectedRow].row :_pageIndex];
        //
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
}

-(void)startAnimationIfNeeded{
    //取消、停止所有的动画
    [advert.layer removeAllAnimations];
    CGSize textSize = [advert.text sizeWithFont:advert.font];
    CGRect lframe = advert.frame;
    lframe.size.width = textSize.width;
    advert.frame = lframe;
    const float oriWidth = 230;
    if (textSize.width > oriWidth) {
        float offset = textSize.width - oriWidth;
        [UIView animateWithDuration:10.0
                              delay:0
                            options:UIViewAnimationOptionRepeat //动画重复的主开关
         |UIViewAnimationOptionAutoreverse //动画重复自动反向，需要和上面这个一起用
         |UIViewAnimationOptionCurveLinear //动画的时间曲线，滚动字幕线性比较合理
                         animations:^{
                             advert.transform = CGAffineTransformMakeTranslation(-offset, 0);
                         }
                         completion:^(BOOL finished) {
                             
                         }
         ];
    }
}

-(void) setLeftItem{
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"返回.png"];
    
    backButton.backgroundColor=[UIColor clearColor];
    backButton.frame = CGRectMake(-20, 0, 12, 18);
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton setBackgroundImage: [UIImage imageNamed:@"返回.png"] forState:UIControlStateHighlighted];
    
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

-(void)popself
{
    [advert removeFromSuperview];
    [detailStoreBtn removeFromSuperview];
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
