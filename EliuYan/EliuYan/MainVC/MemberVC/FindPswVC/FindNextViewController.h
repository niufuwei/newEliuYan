//
//  FindNextViewController.h
//  ELiuYan
//
//  Created by eliuyan_mac on 14-4-28.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "TopViewViewController.h"

@interface FindNextViewController : TopViewViewController<UITextFieldDelegate>
{

    NSString *_phone1;
    UITextField *_authTF1;
    UITextField *_codeTF1;
    UIButton *_getAuth1;

    
    UIImageView * _lineImageView1;
    UIImageView * _lineImageView2;
    
    
    NSDictionary *_authReturnData1;
    
    
    BOOL _isShow1;
    
    
}
@property (strong,nonatomic)NSString *phone1;
@property (strong,nonatomic)NSDictionary *authReturnData1;
@property (strong, nonatomic)UITextField *authTF1;
@property (strong, nonatomic)UITextField *codeTF1;
@property (strong, nonatomic)UIImageView *lineImageView1;
@property (strong, nonatomic)UIImageView *lineImageView2;
@property (assign, nonatomic) BOOL isShow1;
@property (strong,nonatomic) UIButton *getAuth1;
-(id)initWithPhoneNumber:(NSString *)phoneNumer;














@end
