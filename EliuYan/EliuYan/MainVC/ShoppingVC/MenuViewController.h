//
//  MenuViewController.h
//  ELiuYan
//
//  Created by shanchen on 14-4-22.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "TopViewViewController.h"
#import "GoodsTableViewCell.h"
#import "Activity.h"
#import "LoadingView.h"
#import "httpRequest.h"
#import "searchCell.h"

@interface MenuViewController : TopViewViewController
<UITableViewDataSource,UITableViewDelegate,NavCustomDelegate,UIAlertViewDelegate,httpRequestDelegate,UITextFieldDelegate,UITextFieldDelegate>
{
    
    UITableView *_menuTableView;//菜单列表
    UITableView *_displayTableView;//显示列表
    UITableView *_fruitTableView;//水果列表
    UIImageView *_menuImageView; //菜单列表左边的标识
    NSMutableArray *_categoryArray;
    
    NSMutableArray *_goodsCategoryIdArray;
    NSString *_storeType;
   __block NSMutableArray *_goodsArray;
    NSMutableArray * _temp__goodsArray;
    int currentCount;
    NSMutableDictionary *_countDic;
    int count;
    BOOL isAddFooter;

    Activity *activity;
    float currentPrice1;
    float currentPrice2;
    
    NSMutableArray * mutableArray;
    NSArray * dataArray;
    
    NSMutableArray * NumberArray;
    NSArray * listArray;
    NSMutableArray * listMutableArray;
    
    NSMutableDictionary * leftMenuID;
    NSMutableDictionary *_cellDict;
    
    LoadingView *_loadView;
    
    int _pageIndex;
    NSString *totalPage;
    UIButton *detailStoreBtn;
    UIButton *underSearchBtn;
    
    
    UIView *_aView;
    NSMutableDictionary * id_and_tag;
    BOOL isSearchButtonPressed;
    BOOL _isRemove;
    UIButton * searchView;
    
}

@property (nonatomic,strong) UITextField * searchBar;
@property(nonatomic,strong)NSString *storeId;//商铺编号
@property(nonatomic,strong)NSString *storeType;//商铺类型
@property(nonatomic,strong)NSString *storeName;//商铺名称

@end
