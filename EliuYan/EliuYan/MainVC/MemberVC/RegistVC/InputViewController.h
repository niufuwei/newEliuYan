//
//  InputViewController.h
//  ELiuYan
//
//  Created by shanchen on 14-4-24.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "TopViewViewController.h"

@interface InputViewController : TopViewViewController<UITextFieldDelegate>

{

    NSString *_phone;
    UITextField *_authTF;
    UITextField *_codeTF;
    UIButton *_getAuth;
    
    UIImageView * _lineImageView1;
    UIImageView * _lineImageView2;
    
    
    
    NSDictionary *_registerData;
    
    
    BOOL _isShow;

}
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSDictionary *authReturnData;
-(id)initWithPhoneNumber:(NSString *)phoneNumer;
@end
