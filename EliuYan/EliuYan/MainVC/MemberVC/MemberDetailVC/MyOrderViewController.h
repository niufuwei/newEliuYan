//
//  MyOrderViewController.h
//  ELiuYan
//
//  Created by shanchen on 14-4-24.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "TopViewViewController.h"
#import "MJRefresh.h"
#import "httpRequest.h"
@interface MyOrderViewController : TopViewViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,UIAlertViewDelegate,httpRequestDelegate>
{

    UITableView *_myOrderTableView;
    int _totalCount;
    int _totalPage;
    NSMutableArray *_list;

    
    int _pageIndex;
    MJRefreshFooterView *_footer;

    UIView *_aView;
    BOOL _isRemove;
    BOOL isRepeat;
    
    Activity *activity;
    
}
@property (nonatomic,assign)int totalCount;
@property (nonatomic,assign) int totalPage;
@property (nonatomic,strong)UITableView *myOrderTableView;
@property (nonatomic,strong) NSMutableArray *list;
@end
