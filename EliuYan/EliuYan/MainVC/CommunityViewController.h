//
//  CommunityViewController.h
//  EliuYan
//
//  Created by eliuyan_mac on 14-7-3.
//  Copyright (c) 2014年 eliuyan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "httpRequest.h"
#import "Activity.h"

@interface CommunityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,httpRequestDelegate>
{
    Activity * myActivity;
}

@property (nonatomic,strong) UITableView * table;
@property (nonatomic,strong) NSArray * dataArray;
@property (nonatomic,strong) NSString * CommunityName;
@property (nonatomic,strong) NSString * stroeID;
@property (nonatomic,strong) NSString * telPhone;

@end
