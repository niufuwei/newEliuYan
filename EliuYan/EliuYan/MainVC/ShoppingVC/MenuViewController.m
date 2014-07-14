//
//  MenuViewController.m
//  ELiuYan
//
//  Created by shanchen on 14-4-22.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "MenuViewController.h"
#import "StoreDetailViewController.h"
#import "httpRequest.h"
#import "GoodsDetail.h"
#import "CheckStandViewController.h"
#import "MemberCenterViewController.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#include <stdlib.h>
#import "NavViewController.h"
@interface MenuViewController ()
{
    NSInteger mCount;
    NSInteger totalCount;
    float sumPrice;
    BOOL isFirstSelected;
    NSMutableDictionary * jingeDic;
    NSMutableDictionary * menuSelectOnly;

    UITableView * searchTable;
}

@property (nonatomic,strong) MJRefreshFooterView * footer;

@property (nonatomic,strong) NavCustom *nav;

@end

@implementation MenuViewController
@synthesize nav;
@synthesize searchBar;

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
    //创建UI
    [self createUI];
    
    isSearchButtonPressed = FALSE;
    //初始化可变数组
    leftMenuID = [[NSMutableDictionary alloc] init];
    menuSelectOnly = [[NSMutableDictionary alloc] init];
    [menuSelectOnly setObject:@"ok" forKey:[NSString stringWithFormat:@"%d",0]];
    listMutableArray= [[NSMutableArray alloc] init];
    _goodsArray = [[NSMutableArray alloc] initWithCapacity:0];
    mutableArray = [[NSMutableArray alloc] initWithCapacity:0];
    NumberArray = [[NSMutableArray alloc] initWithCapacity:0];
    jingeDic = [[NSMutableDictionary alloc] init];
      //初始化数组和商品ID
    _categoryArray = [[NSMutableArray alloc] initWithCapacity:0];
    _goodsCategoryIdArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    //加载菊花
    activity=[[Activity alloc] initWithActivity:self.view];
    [activity start];
    
    //发送请求
//    NSLog(@"????????=%@",[appDelegate.appDefault objectForKey:@"UserId"]);
    httpRequest *request=[[httpRequest alloc] init];
    //判断userId 是否为空
//    NSLog(@"...%@",UserId);
    
    
    [request httpRequestSend:[NSString stringWithFormat:@"%@goods/GetCategoryList",SERVICE_ADD] parameter:[NSString stringWithFormat:@"UserId=%@&StoreId=%@",[appDelegate.appDefault objectForKey:@"UserId"],self.storeId] backBlock:(^(NSDictionary *dic){
        //解析数据
        
        dataArray=[dic objectForKey:@"List"];
//        NSLog(@">>>>%@",dataArray);
        if(dataArray.count==0)
        {
          LoadingView *  _loadView2 = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) image:@"无信息页面.png"];
            [_loadView2 changeLabel:@"我尽力了，还是看不到"];
            [self.view addSubview:_loadView2];
            
        }
        else
        {
            
            for (int i=0; i<dataArray.count; i++) {
                NSDictionary *detailDic=[dataArray objectAtIndex:i];
                //类别名字
                NSString *category=[detailDic objectForKey:@"CategoryName"];
                [_categoryArray addObject:category];
                //ID类型编号
                NSString *goodsId=[detailDic objectForKey:@"Id"];
                [_goodsCategoryIdArray addObject:goodsId];
                
            }
//            //菜单列表左边的标识
//            if (_categoryArray.count>0) {
//                _menuImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"按钮背景-未按.png"]];
//                _menuImageView.frame=CGRectMake(0,0, 5, 59);
//                [_menuTableView addSubview:_menuImageView];
//                
//            }
            //刷新表
            [_menuTableView reloadData];
            [activity stop];
            //默认显示第一个列表
            [self request:0 :0];
            mCount = 0;
            
        }
    }
)];
    [self addFooter];
    isFirstSelected = TRUE;
    //初始化字典
    _countDic = [[NSMutableDictionary alloc] init];
    _cellDict = [[NSMutableDictionary alloc] init];
   
       
}

-(void)addFooter{
    __unsafe_unretained MenuViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    if ([self.storeType isEqualToString:@"水果店"]) {
        footer.scrollView = _fruitTableView;
    }
    else
    {
        footer.scrollView = _displayTableView;
    }
    
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        
        
        _pageIndex++;
        
        if (_pageIndex >= [totalPage intValue])
        {
            [refreshView endRefreshing];
    
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
            [self request:mCount :_pageIndex];

        }
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

-(void)createUI
{
    nav=[[NavCustom alloc] init];
    if(self.storeName.length >8)
    {
        self.storeName = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"StoreDescription"] substringToIndex:8] stringByAppendingString:@"..."];
    }
    [nav setNav:[[NSUserDefaults standardUserDefaults] objectForKey:@"StoreDescription"] mySelf:self];
    
    //  添加结账点击事件
    
    [self.accountBtn addTarget:self action:@selector(accountBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    [self.returnBtn setBackgroundImage:[UIImage imageNamed:@"选择店铺-未按.png"] forState:UIControlStateNormal];

    [self.accountBtn setTitle:@"结算" forState:UIControlStateNormal];
    self.accountBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.accountBtn setBackgroundColor:eliuyan_color(0xe94f4f)];
    //[self.accountBtn setBackgroundImage:[UIImage imageNamed:@"切图_100.png"] forState:UIControlStateHighlighted];
    //店铺详情
    detailStoreBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    detailStoreBtn.frame=CGRectMake(320-40, 10, 27, 20);
    [detailStoreBtn setBackgroundImage:[UIImage imageNamed:@"搜索.png"] forState:UIControlStateNormal];
    [detailStoreBtn addTarget:self action:@selector(detailStoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:detailStoreBtn];
    
    //添加三张表
    //    菜单列表
    if (IOS_VERSION >= 7.0) {
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 90, self.view.frame.size.height-40-44-20) style:UITableViewStylePlain];
    }
    else
    {
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 90, self.view.frame.size.height-40-44) style:UITableViewStylePlain];
    }

    
    _menuTableView.delegate=self;
    _menuTableView.tag=100;
    _menuTableView.dataSource=self;
    _menuTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_menuTableView];
    
    
    //判断  如果商铺类型是水果店 进入水果店的界面
    if ([self.storeType isEqualToString:@"水果店"]) {
        
        //水果列表
        if (IOS_VERSION >=7.0) {
            _fruitTableView = [[UITableView alloc] initWithFrame:CGRectMake(90, 0, 320-90, self.view.frame.size.height-40-44-20) style:UITableViewStylePlain];
        }
        else
        {
            _fruitTableView = [[UITableView alloc] initWithFrame:CGRectMake(90, 0, 320-90, self.view.frame.size.height-40-44) style:UITableViewStylePlain];
        }

        _fruitTableView.tag=102;
        self.priceLabel.hidden=YES;
        _fruitTableView.delegate=self;
        _fruitTableView.dataSource=self;
        _fruitTableView.showsVerticalScrollIndicator = NO;

        [self.view addSubview:_fruitTableView];
        
    }
    else
    {
        
        //显示列表
        if (IOS_VERSION >= 7.0) {
            _displayTableView = [[UITableView alloc] initWithFrame:CGRectMake(90, 0, 320-90, self.view.frame.size.height-40-44-20) style:UITableViewStylePlain];
        }
        else
        {
            _displayTableView = [[UITableView alloc] initWithFrame:CGRectMake(90, 0, 320-90, self.view.frame.size.height-40-44) style:UITableViewStylePlain];
        }
        _displayTableView.tag=101;
        _displayTableView.delegate=self;
        _displayTableView.dataSource=self;
        _displayTableView.showsVerticalScrollIndicator = NO;

        [self.view addSubview:_displayTableView];
//        self.countLab.hidden=YES;
    }
    
   
}

-(void)viewWillDisappear:(BOOL)animated
{
    detailStoreBtn.hidden=YES;

}
-(void)viewWillAppear:(BOOL)animated
{
    detailStoreBtn.hidden=NO;
    [appDelegate hidenTabbar];

}

-(void)detailStoreBtnClick:(id)sender;
{
//    StoreDetailViewController *detailVC=[[StoreDetailViewController alloc] init];
//    detailVC.type = self.storeType;
//    [self.navigationController pushViewController:detailVC animated:YES];
    if(!isSearchButtonPressed)
    {
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
    UIView * myview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    [myview setBackgroundColor:[UIColor whiteColor]];
    [searchView addSubview:myview];
    
    UIView * textfieldBG = [[UIView alloc] initWithFrame:CGRectMake(10, 7.5, searchView.frame.size.width-80, 30)];
    [textfieldBG.layer setCornerRadius:3];
    [textfieldBG setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]];
    [searchView addSubview:textfieldBG];
    
    UIImageView * imgSearch = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 15)];
    [imgSearch setImage:[UIImage imageNamed:@"搜索.png"]];
    [searchView addSubview:imgSearch];
    
    searchBar = [[UITextField alloc] initWithFrame:CGRectMake(40, 7.5, searchView.frame.size.width-110, 30)];
    searchBar.placeholder = @"请输入要搜索的内容...";
    searchBar.delegate = self;
    searchBar.keyboardType = UIReturnKeyDone;
    [searchBar becomeFirstResponder];
    [searchBar addTarget:self action:@selector(onChange) forControlEvents:UIControlEventEditingChanged];
    searchBar.backgroundColor = [UIColor clearColor];
    
    [searchView setBackgroundColor:[UIColor clearColor]];
    
    [searchView addSubview:searchBar];
    
    UIButton * commit = [UIButton buttonWithType:UIButtonTypeCustom];
    commit.frame= CGRectMake(searchBar.frame.size.width+searchBar.frame.origin.x+5, 10, 60, 25);
    [commit setTitle:@"完成" forState:UIControlStateNormal];
    [commit addTarget:self action:@selector(onClickSearch:) forControlEvents:UIControlEventTouchUpInside];
    commit.tag = 102;
    [commit setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    commit.titleLabel.font = [UIFont systemFontOfSize:16];
    [searchView addSubview:commit];
    
    [_goodsArray removeAllObjects];
    searchTable = [[UITableView alloc] initWithFrame:CGRectMake(0, myview.frame.size.height+myview.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-myview.frame.size.height-myview.frame.origin.y)];
    [searchView addSubview:searchTable];
    searchTable.delegate = self;
    searchTable.dataSource = self;
    
    _footer.scrollView = searchTable;
    
    if (![self.storeType isEqualToString:@"水果店"])
    {
        searchTable.tag = 103;
    }
    else
    {
        searchTable.tag = 104;
    }
    searchTable.hidden = YES;
    
    _loadView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 45, 320, self.view.frame.size.height) image:@"无信息页面.png"];
    [_loadView changeLabel:@"没有搜索到数据"];
    [self.view addSubview:_loadView];
    _loadView.hidden = YES;
}

#pragma mark--
#pragma mark 搜索的代理方法

-(void)onChange
{
    isAddFooter = FALSE;
    searchTable.hidden = NO;
    _pageIndex =0;
    [_goodsArray removeAllObjects];
    if([searchBar.text length]!=0 && ![searchBar.text isEqualToString:@" "])
    {
        [self searchData:searchBar.text pageindex:_pageIndex];
    }
    if([searchBar.text isEqualToString:@" "]&& [searchBar.text length] ==1)
    {
        searchBar.text= @"";
        [_loadView setHidden:NO];

    }
    if([searchBar.text length]==0)
    {
        [_goodsArray removeAllObjects];
        [_loadView setHidden:NO];
    }
    [searchTable reloadData];

}
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
    [_goodsArray removeAllObjects];
    isSearchButtonPressed = FALSE;
    [searchView removeFromSuperview];
    _goodsArray = [NSMutableArray arrayWithArray:_temp__goodsArray];
    _pageIndex =0;
    
    if (![self.storeType isEqualToString:@"水果店"])
    {
        [_displayTableView reloadData];
        _footer.scrollView = _displayTableView;


    }
    else
    {
        [_fruitTableView reloadData];
        _footer.scrollView = _fruitTableView;


    }
    
    [_loadView removeFromSuperview];

    [_menuTableView reloadData];
    
    
}

-(void)searchData:(NSString*)str pageindex:(NSInteger)pageindex
{

    httpRequest *request=[[httpRequest alloc] init];
    
    [request httpRequestSend:[NSString stringWithFormat:@"%@goods/GetSearchGoodsList",SERVICE_ADD] parameter:[NSString stringWithFormat:@"StoreId=%@&GoodsValue=%@&PageIndex=%d",_storeId,searchBar.text,pageindex] backBlock:(^(NSDictionary *dic){
        
        if(!isAddFooter)
        {
            [_goodsArray removeAllObjects];
        }
        
        //总页数
        totalPage=[dic objectForKey:@"TotalPage"];
        listArray = [[NSArray alloc] init];
        listArray=[dic objectForKey:@"List"];
        
        for(int i=0;i<listArray.count;i++)
        {
            [listMutableArray addObject:[listArray objectAtIndex:i]];
        }
        
        for (int i=0; i<listArray.count; i++) {
            NSDictionary *detailDic=[listArray objectAtIndex:i];
            GoodsDetail *goods=[[GoodsDetail alloc] init];
            
            //商店的id
            NSString * storeID = [detailDic objectForKey:@"GoodsCategoryId"];
            goods.storeID = storeID;
            //商品名字
            NSString *goodsName=[detailDic objectForKey:@"GoodsName"];
            goods.goodsName=goodsName;
            //商品编号
            NSString *goodsId=[detailDic objectForKey:@"Id"];
            goods.goodsId=goodsId;
            //商品图片
            NSString *logoImage=[detailDic objectForKey:@"Image"];
            goods.logoImage=logoImage;
            //商品价格
            NSString *price=[detailDic objectForKey:@"Price"];
            goods.price=price;
            [_goodsArray addObject:goods];
            
            
        }
        //刷新表
        if([listArray count]!=0)
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
#pragma mark -
#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==100) {
        return _categoryArray.count;
    }
    else
    return _goodsArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 103 || tableView.tag ==104)
    {
        static NSString * strID=  @"Cell1";
        searchCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
        if(cell==nil)
        {
            cell = [[searchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
            if (tableView.tag==103) {//显示列表
                
                NSArray *cellArray=[[NSBundle mainBundle] loadNibNamed:@"GoodsTableViewCell" owner:nil options:nil];
                cell=[cellArray objectAtIndex:2];
                
                cell.jinButton.hidden=YES;
                cell.geButton.hidden=YES;
                cell.minusBtn.hidden=YES;
                cell.countLabel.hidden=YES;
                
            }
            if (tableView.tag==104) {//水果列表
                
                NSArray *cellArray=[[NSBundle mainBundle] loadNibNamed:@"GoodsTableViewCell" owner:nil options:nil];
                cell=[cellArray objectAtIndex:2];
                
                cell.minusBtn.hidden=YES;
                cell.countLabel.hidden=YES;
                
            }

        }
        
        if (_goodsArray.count==0) {
            
        }
        else
        {
            if (tableView.tag==103) {//超市列表
                cell.backgroundColor=[UIColor whiteColor];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                GoodsDetail *goodsDetail=[_goodsArray objectAtIndex:indexPath.row];
                cell.contentLabel.font = [UIFont systemFontOfSize:14.0];

                cell.contentLabel.text=goodsDetail.goodsName;
                [cell.logoImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",goodsDetail.logoImage]] placeholderImage:[UIImage imageNamed:@"暂无.png"]];
                cell.priceLabel.font = [UIFont systemFontOfSize:12.0];
                cell.priceLabel.text=[NSString stringWithFormat:@"￥:%@",goodsDetail.price];
                
                
                cell.plaseBtn.tag=(indexPath.row+1)+((mCount+1)*1000);
                cell.minusBtn.tag=(indexPath.row+1)+((mCount+1)*1000);
                
                
                cell.countLabel.font = [UIFont systemFontOfSize:10.0];
                cell.countLabel.text=[_countDic objectForKey:goodsDetail.goodsId];
                if([cell.countLabel.text intValue] ==0)
                {
                    cell.minusBtn.hidden=YES;
                    cell.countLabel.hidden=YES;
                    [cell.plaseBtn setBackgroundImage:[UIImage imageNamed:@"联华超市_10.png"] forState:UIControlStateNormal];
                }
                else
                {
                    cell.minusBtn.hidden=NO;
                    cell.countLabel.hidden=NO;
                    [cell.plaseBtn setBackgroundImage:[UIImage imageNamed:@"联华超市_18.png"] forState:UIControlStateNormal];
                }
                
                [cell.plaseBtn addTarget:self action:@selector(plaseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.minusBtn addTarget:self action:@selector(minusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                //        cell.jinButton.tag=10000+indexPath.row;
                //        cell.geButton.tag=10001+indexPath.row;
                [cell.jinButton addTarget:self action:@selector(jinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.geButton addTarget:self action:@selector(geBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            
            if (tableView.tag==104) {//水果列表
                cell.backgroundColor=[UIColor whiteColor];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                GoodsDetail *goodsDet=[_goodsArray objectAtIndex:indexPath.row];
                cell.contentLabel.font = [UIFont systemFontOfSize:14.0];
                cell.contentLabel.text=goodsDet.goodsName;
                cell.logoImage.frame=CGRectMake(10, 10, 60, 60);
                [cell.logoImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",goodsDet.logoImage]] placeholderImage:[UIImage imageNamed:@"暂无.png"]];
                cell.priceLabel.font = [UIFont systemFontOfSize:12.0];

                cell.priceLabel.text=[NSString stringWithFormat:@"%@/斤",goodsDet.price];
                cell.priceLabel.frame=CGRectMake(10, 65, 60, 30);
                
                cell.plaseBtn.tag=(indexPath.row+1)+((mCount+1)*1000);
                cell.minusBtn.tag=(indexPath.row+1)+((mCount+1)*1000);
                
                cell.jinButton.tag =((indexPath.row+1)+((mCount+1)*1000))+1;
                cell.geButton.tag =((indexPath.row+1)+((mCount+1)*1000))+1;
                
                
//                if([[jingeDic objectForKey:[NSString stringWithFormat:@"%d",cell.jinButton.tag]] isEqualToString:@"jin"] || ![jingeDic objectForKey:[NSString stringWithFormat:@"%d",cell.jinButton.tag]])
//                {
//                    [cell.jinButton setBackgroundImage:[UIImage imageNamed:@"水果店_切换按钮 (1).png"] forState:UIControlStateNormal];
//                    [cell.geButton setBackgroundImage:[UIImage imageNamed:@"水果店_切换按钮 (2).png"] forState:UIControlStateNormal];
//                    
//                    [jingeDic setObject:@"jin" forKey:[NSString stringWithFormat:@"%d",cell.geButton.tag]];
//                    
//                }
//                else
//                {
                    [cell.jinButton setBackgroundImage:[UIImage imageNamed:@"水果店_切换按钮 (6).png"] forState:UIControlStateNormal];
                    [cell.geButton setBackgroundImage:[UIImage imageNamed:@"水果店_切换按钮 (5).png"] forState:UIControlStateNormal];
                    
                    [jingeDic setObject:@"ge" forKey:[NSString stringWithFormat:@"%d",cell.geButton.tag]];
                    
//                }
                cell.countLabel.font = [UIFont systemFontOfSize:10.0];
                cell.countLabel.text=[_countDic objectForKey:goodsDet.goodsId];
                if([cell.countLabel.text intValue] ==0)
                {
                    cell.minusBtn.hidden=YES;
                    cell.countLabel.hidden=YES;
                    [cell.plaseBtn setBackgroundImage:[UIImage imageNamed:@"联华超市_10.png"] forState:UIControlStateNormal];
                }
                else{
                    cell.minusBtn.hidden=NO;
                    cell.countLabel.hidden=NO;
                    [cell.plaseBtn setBackgroundImage:[UIImage imageNamed:@"联华超市_18.png"] forState:UIControlStateNormal];
                }
                
                [cell.plaseBtn addTarget:self action:@selector(plaseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.minusBtn addTarget:self action:@selector(minusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
//                [cell.jinButton addTarget:self action:@selector(jinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//                [cell.geButton addTarget:self action:@selector(geBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            
        }
        tableView.backgroundColor=[UIColor whiteColor];
        return cell;

    }
    else
    {
        static NSString *cellIndentifier=@"Cell";
        GoodsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        if (cell==nil) {
            if (tableView.tag==100) {
                
                
                cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"超市、物业左边栏背景.png"]];
                
                NSArray *cellArray=[[NSBundle mainBundle] loadNibNamed:@"GoodsTableViewCell" owner:nil options:nil];
                cell=[cellArray objectAtIndex:0];
                
                UIImageView *backImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"水果店_分隔条.png"]];
                backImage.frame=CGRectMake(0,59, 90, 1);
                [cell.contentView addSubview:backImage];
                
                UIView * myView = [[UIView alloc] init];
                [myView setBackgroundColor:[UIColor whiteColor]];
                cell.selectedBackgroundView = myView;
                cell.categoryLabel.font = [UIFont systemFontOfSize:13.0];

                if(isFirstSelected)
                {
//                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                    cell.categoryLabel.textColor = eliuyan_color(0xe94f4f);
//                    [_menuTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
                    [menuSelectOnly setObject:@"ok" forKey:@"0"];
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                    isFirstSelected = FALSE;
                }
                
                if([[leftMenuID objectForKey:[_goodsCategoryIdArray objectAtIndex:indexPath.row]] intValue] ==0)
                {
                    cell.detailCount.hidden=YES;
                    cell.detailImage.hidden=YES;
                }
                else
                {
                    cell.detailImage.hidden=NO;
                    cell.detailCount.hidden=NO;
                    
                }
                
            }
            if (tableView.tag==101) {//显示列表
                
                NSArray *cellArray=[[NSBundle mainBundle] loadNibNamed:@"GoodsTableViewCell" owner:nil options:nil];
                cell=[cellArray objectAtIndex:1];
                
                cell.jinButton.hidden=YES;
                cell.geButton.hidden=YES;
                cell.minusBtn.hidden=YES;
                cell.countLabel.hidden=YES;
                
            }
            if (tableView.tag==102) {//水果列表
                
                NSArray *cellArray=[[NSBundle mainBundle] loadNibNamed:@"GoodsTableViewCell" owner:nil options:nil];
                cell=[cellArray objectAtIndex:1];
                
                cell.minusBtn.hidden=YES;
                cell.countLabel.hidden=YES;
                
            }
            
        }
        
        
        if (tableView.tag==100) {
            tableView.showsVerticalScrollIndicator=NO;
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            cell.categoryLabel.text=[_categoryArray objectAtIndex:indexPath.row];
            cell.detailCount.text=[leftMenuID objectForKey:[_goodsCategoryIdArray objectAtIndex:indexPath.row]];
            
            if([[menuSelectOnly objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]] isEqualToString:@"ok"])
            {
//                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
//                [_menuTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
                isFirstSelected = FALSE;
                cell.categoryLabel.textColor =  eliuyan_color(0xe94f4f);
                cell.contentView.backgroundColor = [UIColor whiteColor];
            }
            else
            {
                cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"超市、物业左边栏背景.png"]];

            }
            
        }
        if (_goodsArray.count==0) {
            
        }
        else
        {
            if (tableView.tag==101) {//超市列表
                cell.backgroundColor=[UIColor whiteColor];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                GoodsDetail *goodsDetail=[_goodsArray objectAtIndex:indexPath.row];
                cell.contentLabel.text=goodsDetail.goodsName;
                [cell.logoImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",goodsDetail.logoImage]] placeholderImage:[UIImage imageNamed:@"暂无.png"]];
                cell.priceLabel.text=[NSString stringWithFormat:@"￥:%@",goodsDetail.price];
                
                cell.plaseBtn.tag=(indexPath.row+1)+((mCount+1)*1000);
                cell.minusBtn.tag=(indexPath.row+1)+((mCount+1)*1000);
                
                cell.countLabel.text=[_countDic objectForKey:goodsDetail.goodsId];
                if([cell.countLabel.text intValue] ==0)
                {
                    cell.minusBtn.hidden=YES;
                    cell.countLabel.hidden=YES;
                    [cell.plaseBtn setBackgroundImage:[UIImage imageNamed:@"联华超市_10.png"] forState:UIControlStateNormal];
                }
                else
                {
                    cell.minusBtn.hidden=NO;
                    cell.countLabel.hidden=NO;
                    [cell.plaseBtn setBackgroundImage:[UIImage imageNamed:@"联华超市_18.png"] forState:UIControlStateNormal];
                }
                
                [cell.plaseBtn addTarget:self action:@selector(plaseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.minusBtn addTarget:self action:@selector(minusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                //        cell.jinButton.tag=10000+indexPath.row;
                //        cell.geButton.tag=10001+indexPath.row;
                [cell.jinButton addTarget:self action:@selector(jinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.geButton addTarget:self action:@selector(geBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            
            if (tableView.tag==102) {//水果列表
                cell.backgroundColor=[UIColor whiteColor];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                GoodsDetail *goodsDet=[_goodsArray objectAtIndex:indexPath.row];
                cell.contentLabel.text=goodsDet.goodsName;
                cell.logoImage.frame=CGRectMake(10, 10, 60, 60);
                [cell.logoImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",goodsDet.logoImage]] placeholderImage:[UIImage imageNamed:@"暂无.png"]];
                cell.priceLabel.text=[NSString stringWithFormat:@"%@/斤",goodsDet.price];
                cell.priceLabel.frame=CGRectMake(10, 65, 60, 30);
                
                cell.plaseBtn.tag=(indexPath.row+1)+((mCount+1)*1000);
                cell.minusBtn.tag=(indexPath.row+1)+((mCount+1)*1000);
                
                cell.jinButton.tag =((indexPath.row+1)+((mCount+1)*1000))+1;
                cell.geButton.tag =((indexPath.row+1)+((mCount+1)*1000))+1;
                
//                
//                if([[jingeDic objectForKey:[NSString stringWithFormat:@"%d",cell.jinButton.tag]] isEqualToString:@"jin"] || ![jingeDic objectForKey:[NSString stringWithFormat:@"%d",cell.jinButton.tag]])
//                {
//                    [cell.jinButton setBackgroundImage:[UIImage imageNamed:@"水果店_切换按钮 (1).png"] forState:UIControlStateNormal];
//                    [cell.geButton setBackgroundImage:[UIImage imageNamed:@"水果店_切换按钮 (2).png"] forState:UIControlStateNormal];
//                    
//                    [jingeDic setObject:@"jin" forKey:[NSString stringWithFormat:@"%d",cell.geButton.tag]];
//                    
//                }
//                else
//                {
                    [cell.jinButton setBackgroundImage:[UIImage imageNamed:@"水果店_切换按钮 (6).png"] forState:UIControlStateNormal];
                    [cell.geButton setBackgroundImage:[UIImage imageNamed:@"水果店_切换按钮 (5).png"] forState:UIControlStateNormal];
                    
                    [jingeDic setObject:@"ge" forKey:[NSString stringWithFormat:@"%d",cell.geButton.tag]];
                    
//                }
                
                cell.countLabel.text=[_countDic objectForKey:goodsDet.goodsId];
                if([cell.countLabel.text intValue] ==0)
                {
                    cell.minusBtn.hidden=YES;
                    cell.countLabel.hidden=YES;
                    [cell.plaseBtn setBackgroundImage:[UIImage imageNamed:@"联华超市_10.png"] forState:UIControlStateNormal];
                }
                else{
                    cell.minusBtn.hidden=NO;
                    cell.countLabel.hidden=NO;
                    [cell.plaseBtn setBackgroundImage:[UIImage imageNamed:@"联华超市_18.png"] forState:UIControlStateNormal];
                }
                
                [cell.plaseBtn addTarget:self action:@selector(plaseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.minusBtn addTarget:self action:@selector(minusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//                
//                [cell.jinButton addTarget:self action:@selector(jinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//                [cell.geButton addTarget:self action:@selector(geBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//                
            }
            
        }
        tableView.backgroundColor=[UIColor whiteColor];
        return cell;

    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==100) {
        return 60;
    }
    else
    return 90;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //移除提示商品没有的view
    [_aView removeFromSuperview];
       if (tableView.tag==100)
       {
//           [_displayTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
//           if([[menuSelectOnly objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]] isEqualToString:@"ok"])
//           {
//           ((GoodsTableViewCell*)[tableView cellForRowAtIndexPath:indexPath]).categoryLabel.textColor = [UIColor redColor];
//           }
//           else
//           {
//           
//               ((GoodsTableViewCell*)[tableView cellForRowAtIndexPath:indexPath]).categoryLabel.textColor = [UIColor blackColor];
//           
//           
//           }

           if ([self.storeType isEqualToString:@"水果店"])
           {
               [_fruitTableView setContentOffset:CGPointMake(0,0) animated:NO];
           }
           else
           {
               [_displayTableView setContentOffset:CGPointMake(0,0) animated:NO];
           }
           
        
        if(![[menuSelectOnly objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]] isEqualToString:@"ok"])
        {
            
            
            
            _goodsArray = [[NSMutableArray alloc] initWithCapacity:0];
//            GoodsTableViewCell *cell=(GoodsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            _pageIndex=0;
            //根据点击的row去获得商品分类编号 请求数据  self.storeId  （商铺编号）
            //发送请求
            [self request:indexPath.row :0];
            
            //_menuImageView.frame=CGRectMake(0,60*indexPath.row+1-1, 5, 59);
            
            mCount = indexPath.row;
            listMutableArray = [[NSMutableArray alloc] init];
//            if([cell.detailCount.text isEqualToString:@""] || cell.detailCount.text ==nil)
//            {
//                count = 0;
//            }
//            else
//            {
//                count = [cell.detailCount.text intValue];
//            }
            
            
            for (int i=0; i<[[menuSelectOnly allKeys] count]; i++)
            {
                [menuSelectOnly setObject:@"" forKey:[[menuSelectOnly allKeys] objectAtIndex:i]];
                
                ((GoodsTableViewCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[[[menuSelectOnly allKeys] objectAtIndex:i] intValue] inSection:0]]).categoryLabel.textColor = [UIColor blackColor];
                 ((GoodsTableViewCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[[[menuSelectOnly allKeys] objectAtIndex:i] intValue] inSection:0]]).contentView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"超市、物业左边栏背景.png"]];
            }
            ((GoodsTableViewCell*)[tableView cellForRowAtIndexPath:indexPath]).categoryLabel.textColor = eliuyan_color(0xe94f4f);
            [menuSelectOnly setObject:@"ok" forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
            ((GoodsTableViewCell*)[tableView cellForRowAtIndexPath:indexPath]).contentView.backgroundColor = [UIColor whiteColor];
            
        }
        else
        {
            
        }
        
    }

}
-(void)request:(int)indexPath :(int)aPage
{
    httpRequest *request=[[httpRequest alloc] init];
    request.httpDelegate=self;
    [request httpRequestSend:[NSString stringWithFormat:@"%@goods/GetGoodsList",SERVICE_ADD] parameter:[NSString stringWithFormat:@"UserId=%@&StoreId=%@&GoodsCategoryId=%@&PageIndex=%d",[appDelegate.appDefault objectForKey:@"UserId"],self.storeId,[_goodsCategoryIdArray objectAtIndex:indexPath] ,aPage] backBlock:(^(NSDictionary *dic){
        //解析数据
        //总页数
        totalPage=[dic objectForKey:@"TotalPage"];
        listArray = [[NSArray alloc] init];
        listArray=[dic objectForKey:@"List"];
        
        for(int i=0;i<listArray.count;i++)
        {
            [listMutableArray addObject:[listArray objectAtIndex:i]];
        }
        
            for (int i=0; i<listArray.count; i++) {
            NSDictionary *detailDic=[listArray objectAtIndex:i];
            GoodsDetail *goods=[[GoodsDetail alloc] init];
            //商店的id
            NSString * storeID = [detailDic objectForKey:@"GoodsCategoryId"];
            goods.storeID = storeID;
            //商品名字
            NSString *goodsName=[detailDic objectForKey:@"GoodsName"];
            goods.goodsName=goodsName;
            //商品编号
            NSString *goodsId=[detailDic objectForKey:@"Id"];
            goods.goodsId=goodsId;
            //商品图片
            NSString *logoImage=[detailDic objectForKey:@"Image"];
            goods.logoImage=logoImage;
            //商品价格
            NSString *price=[detailDic objectForKey:@"Price"];
            goods.price=price;
            [_goodsArray addObject:goods];
            
            
        }
        _temp__goodsArray  = [NSMutableArray arrayWithArray:_goodsArray] ;
        

        //刷新表
        [_fruitTableView reloadData];
        [_displayTableView reloadData];
       
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
#pragma mark_
#pragma mark - BtnClick

//加号按钮
-(void)plaseBtnClick:(id)sender
{
    
    UIButton *btn=(UIButton *)sender;
    //判断所点击的是哪个类型
    self.countLab.hidden=NO;
    GoodsTableViewCell *cell;
    if (IOS_VERSION >= 7.0) {
       cell=(GoodsTableViewCell *)[[[btn superview] superview]superview];
    }
    else
    {
        cell=(GoodsTableViewCell *)[[btn superview]superview];
    }
    [cell.plaseBtn setBackgroundImage:[UIImage imageNamed:@"联华超市_18.png"] forState:UIControlStateNormal];
    
    cell.minusBtn.hidden=NO;
    cell.countLabel.hidden=NO;
    GoodsDetail *goodsDetail=[_goodsArray objectAtIndex:btn.tag-(mCount+1)*1000-1];
    
    //菜单栏的小红帽自加
    if(![leftMenuID objectForKey:goodsDetail.storeID] && [[leftMenuID objectForKey:goodsDetail.storeID] intValue] <=0)
    {
        count =0;
    }
    else
    {
        count =[[leftMenuID objectForKey:goodsDetail.storeID] intValue];
    }
    
    if(![_countDic objectForKey:goodsDetail.goodsId])
    {
        currentCount = 1;
        [_countDic setObject:[NSString stringWithFormat:@"%d",currentCount] forKey:goodsDetail.goodsId];
        cell.countLabel.text = [_countDic objectForKey:goodsDetail.goodsId];
        
        count++;
        totalCount ++;
        
    }
    else
    {
        [_countDic setObject:[NSString stringWithFormat:@"%d",[[_countDic objectForKey:goodsDetail.goodsId] intValue]+1] forKey:goodsDetail.goodsId];
        cell.countLabel.text = [_countDic objectForKey:goodsDetail.goodsId];
        
        count ++;
        totalCount++;
        
    }
    
    [_countDic setObject:cell.countLabel.text forKey:goodsDetail.goodsId];
    
    //计算价格
    if ([self.storeType isEqualToString:@"水果店"])
    {
      
       sumPrice += [cell.priceLabel.text floatValue];
       self.countLab.text=[NSString stringWithFormat:@"%d（斤/个）",totalCount];
       self.priceLabel.hidden=YES;

    }else{
        
        NSString * str=[cell.priceLabel.text substringFromIndex:2];
        sumPrice += [str floatValue];
        self.countLab.text=[NSString stringWithFormat:@"%d件",totalCount];
        self.priceLabel.hidden = NO;
    }
    
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f元",sumPrice];
    

    //显示小红帽

    if ([cell.countLabel.text intValue]>0) {
        
        NSInteger currentMenu=0;
        for(int i =0;i<[_goodsCategoryIdArray count];i++)
        {
            if([[_goodsCategoryIdArray objectAtIndex:i] isEqualToString:goodsDetail.storeID])
            {
                currentMenu = i;
                break;
            }
        }
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForItem:currentMenu inSection:0];
        //获取; 的cell
        GoodsTableViewCell *menuCell=(GoodsTableViewCell *)[_menuTableView cellForRowAtIndexPath:indexPath];
        
        menuCell.detailImage.hidden=NO;
        menuCell.detailCount.hidden=NO;
        menuCell.detailCount.text=[NSString stringWithFormat:@"%d",count];

        [leftMenuID setObject:[NSString stringWithFormat:@"%d",count] forKey:goodsDetail.storeID];
    }
    
    //检查一下数组里面有没有对应的这个key
    if(mutableArray.count ==0)
    {
        
        //把点击过的数据放到字典并追加到可变数组
        NSMutableDictionary * saveToNextDic = [[NSMutableDictionary alloc] init];
        
        for(int i =0;i<[listMutableArray count];i++)
        {
            if([[[listMutableArray objectAtIndex:i] objectForKey:@"Id"] isEqualToString:goodsDetail.goodsId])
            {
                [saveToNextDic setObject:[listMutableArray objectAtIndex:i] forKey:goodsDetail.goodsId];
            }
        }
        
        [mutableArray addObject:saveToNextDic];
        
    }
    else
    {
        if([self getObjectWithKey:goodsDetail.goodsId from:mutableArray isAdd:YES])
        {
            
        }
        else
        {
            //把点击过的数据放到字典并追加到可变数组
            NSMutableDictionary * saveToNextDic = [[NSMutableDictionary alloc] init];
            //[saveToNextDic setObject:[listMutableArray objectAtIndex:btn.tag - ((mCount+1)*1000)-1] forKey:goodsDetail.goodsId];
            for(int i =0;i<[listMutableArray count];i++)
            {
                if([[[listMutableArray objectAtIndex:i] objectForKey:@"Id"] isEqualToString:goodsDetail.goodsId])
                {
                    [saveToNextDic setObject:[listMutableArray objectAtIndex:i] forKey:goodsDetail.goodsId];
                }
            }

            
            [mutableArray addObject:saveToNextDic];
        }
 
    }
    
    
    NSLog(@"before plase totalCount is %d",totalCount);
}

//减号按钮
-(void)minusBtnClick:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    GoodsTableViewCell *cell;
    if (IOS_VERSION >= 7.0) {
        cell=(GoodsTableViewCell *)[[[btn superview] superview]superview];
    }
    else
    {
        cell=(GoodsTableViewCell *)[[btn superview]superview];
    }
     GoodsDetail *goodsDetail=[_goodsArray objectAtIndex:btn.tag-(mCount+1)*1000-1];
    
    cell.countLabel.text=[NSString stringWithFormat:@"%d",[[_countDic objectForKey:goodsDetail.goodsId] intValue]-1];
    [_countDic setObject:[NSString stringWithFormat:@"%d",[[_countDic objectForKey:goodsDetail.goodsId] intValue]-1] forKey:goodsDetail.goodsId];
    
    if([leftMenuID objectForKey:goodsDetail.storeID] && [[leftMenuID objectForKey:goodsDetail.storeID] intValue]>0)
    {
        count = [[leftMenuID objectForKey:goodsDetail.storeID] intValue];
    }
    else
    {
        count =0;
    }
    count--;
    totalCount--;
   
    if ([[_countDic objectForKey:goodsDetail.goodsId] intValue]<1) {
        cell.minusBtn.hidden=YES;
        cell.countLabel.hidden=YES;
        [cell.plaseBtn setBackgroundImage:[UIImage imageNamed:@"联华超市_10.png"] forState:UIControlStateNormal];
        //去数组查询有没有这个对应的字典，有，则删除，没有则不作处理
        
        if([self getObjectWithKey:goodsDetail.goodsId from:mutableArray isAdd:NO])
        {
            NSLog(@"删除成功");
        }
        else
        {
            NSLog(@"删除失败!");
        }

    }
    
    NSInteger currentMenu=0;
    for(int i =0;i<[_goodsCategoryIdArray count];i++)
    {
        if([[_goodsCategoryIdArray objectAtIndex:i] isEqualToString:goodsDetail.storeID])
        {
            currentMenu = i;
            break;
        }
    }
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForItem:currentMenu inSection:0];

    //获取mennuTable 的cell
    GoodsTableViewCell *menuCell=(GoodsTableViewCell *)[_menuTableView cellForRowAtIndexPath:indexPath];
    if (count<1) {
        menuCell.detailImage.hidden=YES;
        menuCell.detailCount.hidden=YES;
    }
    menuCell.detailCount.text=[NSString stringWithFormat:@"%d",count];
    self.countLab.text=[NSString stringWithFormat:@"%d件（斤/个）",totalCount];
    if (totalCount==0) {
        self.countLab.hidden=YES;
        self.priceLabel.hidden = YES;
    }
    
    [leftMenuID setObject:[NSString stringWithFormat:@"%d",count] forKey:goodsDetail.storeID];
    
    [_countDic setObject:cell.countLabel.text forKey:goodsDetail.goodsId];
    //计算价格
    if ([self.storeType isEqualToString:@"水果店"])
    {
        sumPrice -= [cell.priceLabel.text floatValue];
        self.countLab.text=[NSString stringWithFormat:@"%d（斤/个）",totalCount];
        
    }else{
        
        NSString * str=[cell.priceLabel.text substringFromIndex:2];
        sumPrice -= [str floatValue];
        self.countLab.text=[NSString stringWithFormat:@"%d件",totalCount];
        
    }
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f元",sumPrice];
    
    NSLog(@" after min totalCount is %d",totalCount);
}
//结账按钮
-(void)accountBtnClick:(id)sender
{
    //判断是否有购买的商品和是否登录
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"hasLogIn"] isEqualToString:@"1"]) {
        
        if (totalCount>0) {
            if ([self.storeType isEqualToString:@"水果店"])
            {
                    NSMutableArray * dataMutableArray = [[NSMutableArray alloc] init];
                    
                    for(int i =0; i<mutableArray.count;i++)
                    {
                        NSString * myTag = [[[mutableArray objectAtIndex:i] allKeys] objectAtIndex:0];
                        
                        NSArray * dataArr;
                        if([self.storeType isEqualToString:@"水果店"])
                        {
                            //斤或者个 是按照 个数的tag值来判断的
//                            dataArr = [[NSArray alloc ]initWithObjects:[_countDic objectForKey:[NSString stringWithFormat:@"%d",myTag]],[jingeDic objectForKey:[NSString stringWithFormat:@"%d",myTag+1]],[[mutableArray objectAtIndex:i] objectForKey:[[[mutableArray objectAtIndex:i] allKeys] objectAtIndex:0]],nil];
                            dataArr = [[NSArray alloc ]initWithObjects:[_countDic objectForKey:myTag],@"ge",[[mutableArray objectAtIndex:i] objectForKey:[[[mutableArray objectAtIndex:i] allKeys] objectAtIndex:0]],nil];
                        }
                        else
                        {
                            dataArr = [[NSArray alloc ]initWithObjects:[_countDic objectForKey:myTag],[[mutableArray objectAtIndex:i] objectForKey:[[[mutableArray objectAtIndex:i] allKeys] objectAtIndex:0]],nil];
                            
                        }
                        
                        [dataMutableArray addObject:dataArr];
                        
                    }
                
                    //记录所点击的单元格 保存商品名称，价格，图片
                    CheckStandViewController * check= [[CheckStandViewController alloc] init];
                    check.dataMutableArray = dataMutableArray;
                    [self.navigationController pushViewController:check animated:YES];
                    
                }
            else
            {

                NSString *sumPr=[NSString stringWithFormat:@"%.2f",sumPrice];
                sumPrice = [sumPr floatValue];
                if (sumPrice<[[[NSUserDefaults standardUserDefaults] objectForKey:@"MinBuy"] floatValue]) {
                    //提示小于最低起送价格
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"对不起，没有达到起送价格" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else
                {
                    NSMutableArray * dataMutableArray = [[NSMutableArray alloc] init];
                    
                    for(int i =0; i<mutableArray.count;i++)
                    {
                        NSString * myTag = [[[mutableArray objectAtIndex:i] allKeys] objectAtIndex:0];
                        
                        NSArray * dataArr;
//                        if([self.storeType isEqualToString:@"水果店"])
//                        {
//                            //斤或者个 是按照 个数的tag值来判断的
//                            dataArr = [[NSArray alloc ]initWithObjects:[_countDic objectForKey:[NSString stringWithFormat:@"%d",myTag]],[jingeDic objectForKey:[NSString stringWithFormat:@"%d",myTag+1]],[[mutableArray objectAtIndex:i] objectForKey:[[[mutableArray objectAtIndex:i] allKeys] objectAtIndex:0]],nil];
//                        }
//                        else
//                        {
                        dataArr = [[NSArray alloc ]initWithObjects:[_countDic objectForKey:myTag],[[mutableArray objectAtIndex:i] objectForKey:[[[mutableArray objectAtIndex:i] allKeys] objectAtIndex:0]],nil];
                            
//                        }
                        
                        [dataMutableArray addObject:dataArr];
                        
                    }
                    
                    //记录所点击的单元格 保存商品名称，价格，图片
                    CheckStandViewController * check= [[CheckStandViewController alloc] init];
                    check.dataMutableArray = dataMutableArray;
                    [self.navigationController pushViewController:check animated:YES];
                    
                }
                
                
            }

        }
        
        else
        {
            UIAlertView *alert1=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您还没购买商品哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert1 show];

        }
        
    }else{
        
        //给一个返回对应的界面的状态
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isBack"];

        //提示框
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您还没有登录，请登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alert.delegate=self;
        alert.tag=111;
        [alert show];
        
    }
    
}


//斤按钮
-(void)jinBtnClick:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    
    GoodsTableViewCell *cell;
    if (IOS_VERSION >=7.0) {
        cell=(GoodsTableViewCell *)[[[btn superview] superview]superview];
    }
    else
    {
        cell=(GoodsTableViewCell *)[[btn superview]superview];
    }
    
    [cell.jinButton setBackgroundImage:[UIImage imageNamed:@"水果店_切换按钮 (1).png"] forState:UIControlStateNormal];
    [cell.geButton setBackgroundImage:[UIImage imageNamed:@"水果店_切换按钮 (2).png"] forState:UIControlStateNormal];
    
    [jingeDic setObject:@"jin" forKey:[NSString stringWithFormat:@"%d",btn.tag]];
    
}
//个按钮
-(void)geBtnClick:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    GoodsTableViewCell *cell;
    if (IOS_VERSION >=7.0) {
        cell=(GoodsTableViewCell *)[[[btn superview] superview]superview];
    }
    else
    {
        cell=(GoodsTableViewCell *)[[btn superview]superview];
    }
    
    [cell.jinButton setBackgroundImage:[UIImage imageNamed:@"水果店_切换按钮 (6).png"] forState:UIControlStateNormal];
    [cell.geButton setBackgroundImage:[UIImage imageNamed:@"水果店_切换按钮 (5).png"] forState:UIControlStateNormal];

    [jingeDic setObject:@"ge" forKey:[NSString stringWithFormat:@"%d",btn.tag]];

}
#pragma mark -
#pragma mark -UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
        if (buttonIndex==0) {
            //跳转到登录界面
            MemberCenterViewController *memberVC=[[MemberCenterViewController alloc] init];
            UINavigationController *nav1 = [[NavViewController alloc] initWithRootViewController:memberVC];
            [self presentViewController:nav1 animated:YES completion:^{
                
            }];
        }
        
        else
            return;
    
}

//#pragma mark -
//#pragma mark navDelegate

-(BOOL )getObjectWithKey:(NSString *)key from:(NSMutableArray *)array isAdd:(BOOL)isAdd{
    
    if (nil == array || array.count == 0) {
        return FALSE;
    }
    NSMutableArray *targetArray = [NSMutableArray array];

    __block BOOL isMin = FALSE;
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = (NSDictionary *)obj;
        if([dic objectForKey:key] == nil)
        {
            
        }
        else
        {
            //如果是加号时候执行
            if(isAdd)
            {
                [targetArray addObject:[dic objectForKey:key]];

            }
            else
            {
                //减号执行
                [mutableArray removeObjectAtIndex:idx];
                isMin = TRUE;
            }
        }
        
    }];
   
    if(isAdd)
    {
        if(targetArray.count >0)
        {
            return TRUE;
        }
        else
        {
            return FALSE;
        }

    }
    else
    {
        if(isMin)
        {
            return TRUE;
        }
        else
        {
            return FALSE;
        }

    }
}
-(NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr]; 
    } 
    return hexStr; 
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
