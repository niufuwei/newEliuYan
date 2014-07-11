//
//  RootView.h
//  ELiuYan
//
//  Created by apple on 14-4-27.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewListCell.h"
#import "NewListViewController.h"
#import "MJRefresh.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import <AVFoundation/AVFoundation.h>

typedef void (^callBack)(NSString*);
@interface RootView : UIView<UITableViewDataSource,UITableViewDelegate,RootViewDelegate,UIAlertViewDelegate,AVAudioPlayerDelegate>
{
    NSString * httpUrl;
    NSInteger pageIndex;
    MJRefreshFooterView *_footer;
    UITableView *_tableView;
    UILabel * MoneyLabel;
    NSDictionary *_allDict;
    NSMutableArray *_goodsArray;
    
    int totalCount;
    
    UILabel * ShopName;//店铺名称
    UILabel * descriptionShop;//店铺描述
    UILabel * phoneNumber;//电话号码
    UILabel * OrderNumber;//订单编号
    UILabel * OrderMoney;//订单金额
    UILabel * OrderTime;//下单时间
    UILabel * Remarks;//备注信息
    UILabel * prompt;//店铺状态
    UILabel * _statusLabel;
    UILabel * alarmLabel;
    UILabel * payWay;
    UIButton * _VoiceBtn;//语音播放按钮
    NSString *_oredrId;//订单ID
    NSString *_values;
    NSString *telNum;//店铺号码
    NSString *orderPrice;//订单金额
    __block NSString *totalPage;//总页数
    
    UIButton * Confirm;//确认收货按钮
}
@property (nonatomic,strong) UITableView * table;
@property(nonatomic,strong)NSDictionary *allDict;
@property(nonatomic,strong)NSString *oredrId;//订单ID
@property(nonatomic,strong)NSString *values;
@property (nonatomic,strong) callBack Back;
@property (nonatomic,strong) AVAudioPlayer * Player;
@property (nonatomic,strong) UILabel * statusLabel;

-(void)call_Back:(void(^)(NSString*))call;
@end
