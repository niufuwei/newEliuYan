//
//  ChangePswViewController.h
//  ELiuYan
//
//  Created by shanchen on 14-4-24.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "RegistViewController.h"

@interface ChangePswViewController : TopViewViewController<UIAlertViewDelegate,UITextFieldDelegate>

{
    UITextField *_newPswTF;//新密码文本框
    UIImageView *_newPswLineImageView;//新密码下划线
    
    
    BOOL _isShow;
    
    UILabel *_headerLabel;
    UITextField *_numberTF;
    
    UIImageView *_lineImageView;
    
    BOOL _isLoginViewShow;

}

@end
