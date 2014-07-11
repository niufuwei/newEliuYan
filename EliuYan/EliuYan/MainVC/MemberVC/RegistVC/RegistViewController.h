//
//  RegistViewController.h
//  ELiuYan
//
//  Created by shanchen on 14-4-23.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "TopViewViewController.h"
#import "httpRequest.h"


@interface RegistViewController : TopViewViewController
<UITextFieldDelegate,httpRequestDelegate>
{
    UITextField *_numberTF;//手机号码文本框
    UIImageView *_lineImageView;//手机号码下划线
    UIButton *_nextBtn;//下一步
    UILabel *_headerLabel;
    
    BOOL _agree;

}

@property(nonatomic,strong)UITextField *numberTF;
@property(nonatomic,strong)UILabel *numberLabel;
@property(nonatomic,strong)UIButton *nextBtn;
@property(nonatomic,strong)UILabel *headerLabel;
@property(nonatomic,strong)UIImageView *lineImageView;



@end
