//
//  ChangePswViewController.m
//  ELiuYan
//
//  Created by shanchen on 14-4-24.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "ChangePswViewController.h"
#import "httpRequest.h"
#import "AppDelegate.h"
#import "MemberDetailViewController.h"
#import "MemberCenterViewController.h"
#import "NavViewController.h"
//#import <CommonCrypto/CommonDigest.h>
@interface ChangePswViewController ()

@end

@implementation ChangePswViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.nameLabel.text=@"修改密码";
    self.orderView.hidden = YES;
//    self.navigationItem.title = @"修改密码";
    NavCustom *nav=[[NavCustom alloc] init];
    [nav setNav:@"修改密码" mySelf:self];
    [appDelegate hidenTabbar];

    
    //请填写手机号码
    _headerLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 44)];
    _headerLabel.text=@"请填写原密码与新密码";
    _headerLabel.textColor=[UIColor grayColor];
    _headerLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_headerLabel];
    
    
    if (IOS_VERSION < 7.0)
    {
        _numberTF=[[UITextField alloc] initWithFrame:CGRectMake(50, 60, 270, 44)];
    }
    else
    {
        
        _numberTF=[[UITextField alloc] initWithFrame:CGRectMake(40, 50, 270, 44)];
        
    }
    _numberTF.delegate=self;
    _numberTF.tag = 100;
    _numberTF.secureTextEntry = YES;
    [_numberTF becomeFirstResponder];
    _numberTF.placeholder = @"原密码";
    [self.view addSubview:_numberTF];
    
    _lineImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"线5.png"]];
    _lineImageView.frame=CGRectMake(20, 50+34, 280, 1);
    [self.view addSubview:_lineImageView];
    
    
    
    
    
    
       if (IOS_VERSION < 7.0) {
        _newPswTF=[[UITextField alloc] initWithFrame:CGRectMake(50, 110, 270, 44)];

    } else {
        _newPswTF=[[UITextField alloc] initWithFrame:CGRectMake(40, 100, 270, 44)];

    }
    _newPswTF.delegate=self;
    _newPswTF.tag=101;
    _newPswTF.secureTextEntry = YES;
    _newPswTF.placeholder = @"新密码";
    [self.view addSubview:_newPswTF];
    
    _newPswLineImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"线5.png"]];
    _newPswLineImageView.frame=CGRectMake(20, 100+34, 280, 1);
    [self.view addSubview:_newPswLineImageView];
    
    
    
    UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(225, 150, 70, 30)];
    showLabel.text = @"显示密码";
    showLabel.font=[UIFont systemFontOfSize:14.0];
    showLabel.textColor = [UIColor redColor];
    showLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:showLabel];
    
    
    UIButton *showBtn = [[UIButton alloc] initWithFrame:CGRectMake(285, 158, 15, 15)];
    [showBtn setBackgroundImage:[UIImage imageNamed:@"显示密码-未选.png"] forState:UIControlStateNormal];
    [showBtn addTarget:self action:@selector(showBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showBtn];
    
    
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 152, 210, 30)];
    descriptionLabel.text = @"若没设置过密码，则原密码不需填写";
    descriptionLabel.font = [UIFont fontWithName:@"helvetica" size:12.0];
    descriptionLabel.textColor = [UIColor grayColor];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:descriptionLabel];
    
    
    //保存按钮
    UIButton *saveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame=CGRectMake(320-60+3, 12, 40, 20);
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    saveBtn.tag = 2049;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:saveBtn];

    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
 
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];

}


-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:YES];
    if (!_isLoginViewShow)
    {
        [[self.navigationController.navigationBar viewWithTag:2049] removeFromSuperview];

    }
    
}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:YES];

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogIn"] isEqualToString:@""])
    {
        [[self.navigationController.navigationBar viewWithTag:2049] removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }

}
-(void)showBtn:(UIButton *)btn
{
    
    _isShow = !_isShow;
    
    if (_isShow)
    {
        _numberTF.secureTextEntry = NO;
        _newPswTF.secureTextEntry = NO;
        
        [btn setBackgroundImage:[UIImage imageNamed:@"显示密码-已选.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        
        _numberTF.secureTextEntry = YES;
        _newPswTF.secureTextEntry = YES;

        [btn setBackgroundImage:[UIImage imageNamed:@"显示密码-未选.png"] forState:UIControlStateNormal];
    }
    
    
}
#pragma mark -
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _numberTF.keyboardType = UIKeyboardTypeASCIICapable;
    _newPswTF.keyboardType=UIKeyboardTypeASCIICapable;
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //原密码的判断
    if (textField.tag==100) {
        if ([textField.text isEqual:@""]) {
            _lineImageView.image=[UIImage imageNamed:@"线5.png"];
        }
        else
        {
            _lineImageView.image=[UIImage imageNamed:@"线4.png"];
        }

    }
        //新密码的判断
    if (textField.tag==101) {
        if ([textField.text isEqual:@""]) {
            _newPswLineImageView.image=[UIImage imageNamed:@"线5.png"];
        }
        else
        {
            _newPswLineImageView.image=[UIImage imageNamed:@"线4.png"];
        }
    }
    
}

#pragma mark_
#pragma mark - BtnClick
//保存按钮
-(void)saveBtnClick:(id)sender
{
    
  
    NSLog(@"保存按钮被点击了");
    
//    UIButton *btn1 = (UIButton *)sender;

    _numberTF.text = [_numberTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _newPswTF.text = [_newPswTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    int length = [_newPswTF.text length];
    
    for (int i=0; i<length; ++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [_newPswTF.text substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3)
        {
            NSLog(@"汉字:%s", cString);
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"对不起密码格式错误，请输入数字或英文字符" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }

    
    if ([_newPswTF.text length] < 6 || [_newPswTF.text length] >12)
    {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码长度为6-12位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert1 show];
        
        return;
    }
    
    
    Activity *activity = [[Activity alloc] initWithActivity:self.view];
    [activity start];
    
    
    httpRequest *http = [[httpRequest alloc] init];
    [http httpRequestSend:[NSString stringWithFormat:@"%@user/UpdatePassword",SERVICE_ADD] parameter:[NSString stringWithFormat:@"Id=%@&OldPwd=%@&NewPwd=%@&Token=%@",[appDelegate.appDefault objectForKey:@"UserId"],_numberTF.text,_newPswTF.text,[appDelegate.appDefault objectForKey:@"Token"]] backBlock:^(NSDictionary * dic) {

        
        if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
        {
            [activity stop];
            
            
            [[self.navigationController.navigationBar viewWithTag:2049] removeFromSuperview];

            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"1"])
        {
            [activity stop];

          UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"提示" message:@"旧密码不匹配" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"99"])
        {
            [activity stop];

        
            UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"提示" message:@"系统异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"88"])
        {
            [activity stop];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您的账号在别处登录,请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.delegate = self;
            alert.tag=10010;
            [alert show];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LoginName"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ReallyName"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hasLogIn"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Token"];
            
        }
        
        
    }];
    
    
    

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        MemberCenterViewController *memCenter = [[MemberCenterViewController alloc] init];
        UINavigationController *nav = [[NavViewController alloc] initWithRootViewController:memCenter];
        _isLoginViewShow = YES;

        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }
    else
    {
    
        [self.navigationController popViewControllerAnimated:YES];
    
    }
    
    
}

//#pragma mark --SHA1加密
//- (NSString*)sha1:(NSString *)str
//{
//    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
//    NSData *data = [NSData dataWithBytes:cstr length:str.length];
//    
//    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
//    
//    CC_SHA1(data.bytes, data.length, digest);
//    
//    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
//    
//    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
//        [output appendFormat:@"%02x", digest[i]];
//    
//    return output;
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
