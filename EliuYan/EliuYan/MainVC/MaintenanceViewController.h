//
//  MaintenanceViewController.h
//  EliuYan
//
//  Created by laoniu on 14-7-4.
//  Copyright (c) 2014年 eliuyan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavCustom.h"
#import "httpRequest.h"
#import "LoadingView.h"

@interface MaintenanceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NavCustomDelegate,UITextFieldDelegate,httpRequestDelegate>
{
    UILabel * numberPrice;
    UILabel * Price ;
    UILabel * numberService;
    LoadingView *_loadView;
    NSInteger _pageIndex;
    NSInteger mCountService;
    NSString * totalPage;//总页数
    UIView *_aView;
    BOOL _isRemove;
    BOOL isSearchButtonPressed;
    
    UIButton *searchView;
    UITextField * searchBar;
    UITableView * searchTable;
    NSMutableArray * _temp__goodsArray;
    BOOL isFirstRun;
    NSInteger selectMenuRow;
    
    NSString * advertisement;
    BOOL isAddFooter;
    
    UIButton *detailStoreBtn;

}

@property (nonatomic,strong) NSString * storeID;
@property (nonatomic,strong) UITableView * menuTable;
@property (nonatomic,strong) UITableView * ContentTable;
@property (nonatomic,strong) NSMutableArray * menuNameArray;
@property (nonatomic,strong) NSMutableArray * menuIdArray;
@property (nonatomic,strong) NSMutableArray * ContentArray;
@property (nonatomic,strong) NSMutableDictionary * IDDictionary;
@property (nonatomic,strong) NSMutableDictionary * contentSelectDictionary;
@property (nonatomic,strong) NSMutableDictionary * menuSelectDictionary;
@property (nonatomic,strong) NSMutableArray * allData;
@end
