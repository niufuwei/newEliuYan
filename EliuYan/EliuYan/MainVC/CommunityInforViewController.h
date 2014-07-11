//
//  ;;
//  EliuYan
//
//  Created by laoniu on 14-7-3.
//  Copyright (c) 2014年 eliuyan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKUserLocation.h"
#import "BMKSearch.h"
#import "Activity.h"
#import "LoadingView.h"

typedef void (^Block)(NSString *,NSString *,NSString*);

@interface CommunityInforViewController : UIViewController<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,BMKUserLocationDelegate,BMKSearchDelegate>
{
    CLLocationManager *_location;//定位
    
    NSString *_latStr;//维度
    NSString *_lngStr;//经度
    BMKUserLocation *userLocation;
    BOOL isRefresh;
    Activity * ac;
    BMKSearch * search;
    UILabel *_locationLabel;//显示位置
    LoadingView * loadView;
}

@property (nonatomic,strong) BMKUserLocation *userLocation;
@property (nonatomic,strong) UITableView * tabel;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) Block myBlock;
@property (nonatomic,strong) NSString * CommunityName;

-(void)getComName:(void(^)(NSString*,NSString*,NSString*))bl;

@end
