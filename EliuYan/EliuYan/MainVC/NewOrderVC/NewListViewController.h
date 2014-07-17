//
//  NewListViewController.h
//  ELiuYan
//
//  Created by shanchen on 14-4-21.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "TopViewViewController.h"
#import "httpRequest.h"
#import "MemberCenterViewController.h"
typedef void (^block)(NSString *str);
@protocol RootViewDelegate
- (void)sendRequest:(NSDictionary *)allDic orderIdArray:(NSArray *)array withTag:(int)tag;
@end

@interface NewListViewController : TopViewViewController<UIScrollViewDelegate,NavCustomDelegate,httpRequestDelegate,UIAlertViewDelegate>
{
    id<RootViewDelegate> rootDelegate;
    BOOL isPlay;
    UITableView *_tableView;
    NSMutableDictionary * mutableDic;
    NSMutableDictionary * deleteDic;
   __block NSString *totalPage;//总页数
    __block NSString *isTotalPage;
    NSInteger currentIndexPage;
    NSInteger tempIndex;
    BOOL isAccount;
    UIButton * Confirm;//确认收货按钮
    NSString * orderId;
    NSMutableArray * newOrderRecord;
    
    
    CGFloat  contentOfSet;
    CGFloat contentOfSet1;
    
    BOOL contentHasSaved;
    NSArray *_orderIdArray;//服务器返回额订单id 的数组
    BOOL isFirstRequest;
    NSMutableDictionary *_currentPageDic;
    
    BOOL _comeBackFromBackground;
    
    
}
@property(nonatomic, strong) id<RootViewDelegate> rootDelegate;
@property (nonatomic,strong) UIScrollView * backScrollview;

@property (nonatomic,strong) UIActivityIndicatorView *activity;
@property (nonatomic,strong) NavCustom * myNavCustom;

@property (nonatomic,strong) block backOrder1;
-(void)getBackOrder:(void(^)(NSString*))backOrder1;
@end
