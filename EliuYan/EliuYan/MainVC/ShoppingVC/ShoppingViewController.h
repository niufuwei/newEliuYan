//
//  ShoppingViewController.h
//  ELiuYan
//
//  Created by shanchen on 14-4-22.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "TopViewViewController.h"
#import "Activity.h"
#import "LoadingView.h"
#import "BMKUserLocation.h"
#import "BMKSearch.h"
#import "JCTopic.h"
@interface ShoppingViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,ASIHTTPRequestDelegate,BMKUserLocationDelegate,BMKSearchDelegate,UIAlertViewDelegate,UIScrollViewDelegate,JCTopicDelegate>

{
    Activity *activity;
    
    UITableView *_tableView;
    CLLocationManager *_location;//定位
    
    NSString *_latStr;//维度
    NSString *_lngStr;//经度
    
    UILabel *_locationLabel;//显示位置
    NSMutableArray *_storeDetailArray;//店铺详情
//    BuyShopping *_buyShop;
    
    UIActivityIndicatorView *_indictorView;
    LoadingView *_loadView;
//    BMKMapView * _mapView;
     BMKUserLocation *userLocation;
    
    BMKSearch * search;
    
    BOOL isRefresh;
    
    NSString *_titleName;
    NSMutableArray *_urlArray;
    NSMutableArray *_activityIdArray;
    NSMutableArray *_titleArray;
    
}

@property (nonatomic,strong) BMKUserLocation *userLocation;
@property (nonatomic,strong) JCTopic * Topic;
@end
