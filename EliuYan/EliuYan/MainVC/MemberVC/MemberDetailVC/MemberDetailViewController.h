//
//  MemberDetailViewController.h
//  ELiuYan
//
//  Created by shanchen on 14-4-24.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "TopViewViewController.h"
#import "httpRequest.h"
#import "MemberCenterViewController.h"

@interface MemberDetailViewController : TopViewViewController
<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,httpRequestDelegate>

{
    UITableView *_tableView;
    NSArray *_array;//保存固定信息的数组
    NSArray *_array1;
    NSArray *_array2;
    
    
    BOOL isRepeat;
    NSMutableDictionary *_memberInfo;
    Activity *cativity;
    
}




@end
