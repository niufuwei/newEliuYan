//
//  MyOrderDetailViewController.h
//  ELiuYan
//
//  Created by eliuyan_mac on 14-4-28.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "TopViewViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "httpRequest.h"


typedef void (^block)(NSString *str);

@interface MyOrderDetailViewController : TopViewViewController<UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate,UIAlertViewDelegate,httpRequestDelegate>

{

    NSString *_orderId;
    NSDictionary *_myOrderDic;
    
    
    UITableView *_goodsListTableView;
    
    
    NSString *_storeName;
    NSString *_telNumber;
    NSString *_storeId;
    NSString *_status;
    NSString *_orderNumber;
    NSString *_orderPrice;
    NSString *_createTime;
    NSString *_descriptionType;
    NSString *_description;
    NSMutableArray *_detailsList;
    
    
    
    
    
    UILabel *_label1;
    UILabel *_label2;
    UILabel *_label3;
    UILabel *_label4;
    UILabel *_label5;
    UILabel *_label6;
    UILabel *_label7;
    UILabel *_label8;
    UILabel *_label9;
    UILabel *_label10;
    UILabel *_label11;
    UILabel * descriptionShop;//店铺描述
    UIView *aView;
    
    
    UILabel * _descriptionLabel;
    
    UIImageView * _lineImageView;
    
    int _totalGoods;
    
    AVAudioPlayer *_player;
    Activity *_activity;
    NSString *_savePath;
    NSString *_tempPath;
   
    UIImageView * _lineImageView1;
    
    //NSTimer * _minTimer;
    
    
    UIButton *Confirm;


}
@property (strong,nonatomic) NSString *orderId;
@property (strong,nonatomic)NSDictionary *myOrderDic;
@property (nonatomic,strong)UITableView *goodsListTableView;

@property (nonatomic,strong)NSString *storeName;
@property (nonatomic,strong)NSString *telNumber;
@property (nonatomic,strong)NSString *storeId;
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong) NSString *orderNumber;
@property (nonatomic,strong) NSString *orderPrice;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *descriptionType;
@property (nonatomic,strong) NSString *description;

@property (nonatomic,strong) block backOrder;
@property (nonatomic,strong) NSMutableArray *detailsList;

@property (nonatomic,strong) AVAudioPlayer *player;

//@property (nonatomic) NSInteger minCount;

-(void)getBackOrder:(void(^)(NSString*))backOrder;
-(id)initWithOrderId:(NSString *)orderId;











@end
