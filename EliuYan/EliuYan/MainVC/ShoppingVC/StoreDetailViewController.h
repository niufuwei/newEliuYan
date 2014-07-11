//
//  StoreDetailViewController.h
//  ELiuYan
//
//  Created by shanchen on 14-4-24.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "TopViewViewController.h"
#import "httpRequest.h"


@interface StoreDetailViewController : UIViewController<UITextViewDelegate,NavCustomDelegate,UIAlertViewDelegate,httpRequestDelegate>
{
    UITextView * opinionText;
    UIButton *closeBtn;
    __block Activity * ac;
}

@property (nonatomic,strong) NavCustom *nav;
@property (nonatomic,strong) NSString * type;

@end
