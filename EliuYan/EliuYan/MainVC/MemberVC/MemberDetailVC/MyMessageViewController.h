//
//  MyMessageViewController.h
//  ELiuYan
//
//  Created by eliuyan_mac on 14-4-28.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "TopViewViewController.h"
#import "MJRefresh.h"
#import "httpRequest.h"
typedef void(^block)(NSString*);

@interface MyMessageViewController : TopViewViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,UIAlertViewDelegate,httpRequestDelegate>
{

    UITableView *_messageTableView;
    int _totalMessageCount;
    int _totalMessagePage;
    NSMutableArray *_messageArray;
    
    MJRefreshFooterView *_footer;

    int  _pageIndex;
    Activity *activity;
    
    UIView *_aView;
    BOOL _isRemove;
    
    
    
}
@property (nonatomic,strong)UITableView *messageTableView;
@property (nonatomic,strong)NSMutableArray *messageArray;
@property (nonatomic,assign)int totalMessageCount;
@property (nonatomic,assign)int totalMessagePage;
@property (nonatomic,strong)block backName;

-(void)getBackName:(void(^)(NSString*))backName;

@end
