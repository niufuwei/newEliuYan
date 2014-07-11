//
//  MemberCenterViewController.h
//  ELiuYan
//
//  Created by shanchen on 14-4-22.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "TopViewViewController.h"
#import "httpRequest.h"


typedef void (^block)(NSString *);

@interface MemberCenterViewController : UIViewController
<UITextFieldDelegate,httpRequestDelegate>
{
    UITextField *_numberTF;//手机号码文本框
    UITextField *_pswTF;//密码文本框

    Activity *cativity;
}

@property (nonatomic,strong)block backBlock;
-(void)getBackBlock:(void(^)(NSString *))block;
@end
