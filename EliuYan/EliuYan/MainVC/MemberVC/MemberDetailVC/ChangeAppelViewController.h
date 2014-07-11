//
//  ChangeAppelViewController.h
//  ELiuYan
//
//  Created by eliuyan_mac on 14-4-28.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "TopViewViewController.h"
#import "httpRequest.h"
typedef void(^block)(NSString*);
@interface ChangeAppelViewController : TopViewViewController<UITextFieldDelegate,UIAlertViewDelegate,httpRequestDelegate>
{

    UIImageView *_lineImageView;
    UITextField *_numberTF;
    Activity *activity;
    
    BOOL _isLoginViewShow;

}
@property (nonatomic,strong) UIImageView *lineImageView;
@property (nonatomic,strong) UITextField *numberTF;
@property (nonatomic,strong) block backName;

-(void)getBackName:(void(^)(NSString*))backName;
@end
