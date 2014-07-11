//
//  AboutUsViewController.h
//  ELiuYan
//
//  Created by shanchen on 14-4-24.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "TopViewViewController.h"
#import <StoreKit/StoreKit.h>

@interface AboutUsViewController : TopViewViewController<UITableViewDataSource,UITableViewDelegate,SKStoreProductViewControllerDelegate>
{
    NSArray * dataArray;
}

@property (nonatomic,strong) UITableView * table;

@end
