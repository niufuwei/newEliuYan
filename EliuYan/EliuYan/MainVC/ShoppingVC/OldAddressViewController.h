//
//  OldAddressViewController.h
//  ELiuYan
//
//  Created by laoniu on 14-5-1.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "httpRequest.h"
#import "LoadingView.h"

typedef void(^block)(NSString*);

@interface OldAddressViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,httpRequestDelegate>

{
    __block Activity * ac;
    
    NSIndexPath * CurrentPath;
    
    NSString *_str;
    
    BOOL _isSureDelete;
    
    LoadingView *_loadView;
}

@property (nonatomic,strong) __block UITableView * table;
@property (nonatomic,strong) block  myBlock;
@property (nonatomic,strong) NSMutableArray * dataArray;

-(void)getAddress:(void(^)(NSString*))addres;
@end
