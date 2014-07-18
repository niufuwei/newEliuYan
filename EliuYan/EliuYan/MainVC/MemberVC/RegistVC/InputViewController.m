//
//  InputViewController.m
//  ELiuYan
//
//  Created by shanchen on 14-4-24.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "InputViewController.h"
#import "httpRequest.h"
#import "AppDelegate.h"
#import "DefineModel.h"
#import "MemberDetailViewController.h"
#import "NavCustom.h"
@interface InputViewController ()

@end

@implementation InputViewController
@synthesize authReturnData;

-(id)initWithPhoneNumber:(NSString *)phoneNumer
{

    self =  [super init];
    if (self) {
        self.phone = phoneNumer;
        
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.orderView removeFromSuperview];

    
    NavCustom *navCust = [[NavCustom alloc] init];
    [navCust setNav:@"账号注册" mySelf:self];
    
   UILabel * headerLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 250, 44)];
    headerLabel.text=@"请填写您收到的验证码及密码";
    headerLabel.textColor=[UIColor grayColor];
    headerLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerLabel];
    
    
    if (IOS_VERSION < 7.0) {
        _authTF=[[UITextField alloc] initWithFrame:CGRectMake(30, 60, 180, 44)];

    } else {
        _authTF=[[UITextField alloc] initWithFrame:CGRectMake(30, 50, 180, 44)];

    }
    _authTF.delegate=self;
    [_authTF becomeFirstResponder];
    _authTF.placeholder = @"验证码";
    _authTF.tag = 1;
    if (IOS_VERSION < 7.0)
    {
        [_authTF setFrame:CGRectMake(90, 60, 100, 44)];
    }
    [self.view addSubview:_authTF];
    
    _lineImageView1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"线5.png"]];
    _lineImageView1.frame=CGRectMake(30, 50+34, 170, 1);
    [self.view addSubview:_lineImageView1];
    
    
    _getAuth = [[UIButton alloc] initWithFrame:CGRectMake(200, 55, 100, 30)];
    [_getAuth setTitle:@"重新获取" forState:UIControlStateNormal];
    [_getAuth setBackgroundColor:eliuyan_color(0xe94f4f)];
    [_getAuth addTarget:self action:@selector(getTheAuth:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getAuth];
    
    
    
    
      if (IOS_VERSION < 7.0) {
        _codeTF=[[UITextField alloc] initWithFrame:CGRectMake(30, 110, 250, 44)];

    } else {
        _codeTF=[[UITextField alloc] initWithFrame:CGRectMake(30, 100, 250, 44)];

    }
    _codeTF.delegate=self;
    _codeTF.tag = 2;
    _codeTF.placeholder = @"密码";
    _codeTF.secureTextEntry = YES;
    if (IOS_VERSION < 7.0)
    {
        [_codeTF setFrame:CGRectMake(80, 100, 200, 44)];
    }
    [self.view addSubview:_codeTF];
    
    _lineImageView2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"线5.png"]];
    _lineImageView2.frame=CGRectMake(30, 100+34, 240, 1);
    [self.view addSubview:_lineImageView2];
    
    
    UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 150, 70, 30)];
    showLabel.text = @"显示密码";
    showLabel.textColor = eliuyan_color(0xe94f4f);
    showLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:showLabel];
    
    
    UIButton *showBtn = [[UIButton alloc] initWithFrame:CGRectMake(260, 155, 20, 20)];
    [showBtn setBackgroundImage:[UIImage imageNamed:@"显示密码-未选.png"] forState:UIControlStateNormal];
    [showBtn addTarget:self action:@selector(showBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showBtn];
    
    
    
    //下一步btn
    UIButton * nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame=CGRectMake(40, 240, 240, 40);
    [nextBtn setTitle:@"提交" forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:eliuyan_color(0xe94f4f)];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    _registerData =[[NSDictionary alloc] init];
   
    _isShow = NO;
    
    

    
}


-(void)getTheAuth:(UIButton *)btn
{

    
    Activity *activity = [[Activity alloc]initWithActivity:self.view];
    [activity start];
    
    
     httpRequest *http = [[httpRequest alloc] init];
    [http httpRequestSend:[NSString stringWithFormat:@"%@user/SenderCode",SERVICE_ADD] parameter:[NSString stringWithFormat:@"TelPhoneNum=%@&CodeType=%@",_phone,@"0"] backBlock:(^(NSDictionary * dic) {
        
        if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
        {
            authReturnData = dic;
            [_getAuth setTitle:@"重新获取" forState:UIControlStateNormal];
            [activity stop];
            
            
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"1"])
        {
            [activity stop];

            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码已注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert1 show];
            
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"2"])
        {
        
            [activity stop];

            UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不是有效的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert2 show];
        
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"99"])
        {
        
            [activity stop];

            UIAlertView *alert3 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"系统异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert3 show];
        
        }
    })];
    

}
-(void)showBtn:(UIButton *)btn
{

    _isShow = !_isShow;
    
    if (_isShow)
    {
        _codeTF.secureTextEntry = NO;
        [btn setBackgroundImage:[UIImage imageNamed:@"显示密码-已选.png"] forState:UIControlStateNormal];

    }
    else
    {
    
    _codeTF.secureTextEntry = YES;
    [btn setBackgroundImage:[UIImage imageNamed:@"显示密码-未选.png"] forState:UIControlStateNormal];
    }



}
-(void)nextBtnClick:(UIButton *)btn
{
    
//    int length = [text length];
//    
//    for (int i=0; i<length; ++i)
//    {
//        NSRange range = NSMakeRange(i, 1);
//        NSString *subString = [text substringWithRange:range];
//        const char *cString = [subString UTF8String];
//        if (strlen(cString) == 3)
//        {
//            NSLog(@"汉字:%s", cString);
//        }
//    }
    
    if (![_authTF.text isEqualToString:[authReturnData objectForKey:@"Code"]])
    {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert1 show];
        
        return;
    }

    
    if ([_codeTF.text length] < 6 ||[_codeTF.text length] >12)
    {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码长度为6-12位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert1 show];
        
        return;
    }
    
    Activity *activity = [[Activity alloc] initWithActivity:self.view];
    [activity start];
    
    
    //
    
    httpRequest *http1 = [[httpRequest alloc] init];
    [http1 httpRequestSend:[NSString stringWithFormat:@"%@user/UserRegister",SERVICE_ADD] parameter:[NSString stringWithFormat:@"LoginName=%@&PassWord=%@&DeviceName=%@&DeviceVersion=%@&SystemType=%@&DeviceToken=%@",_phone,_codeTF.text,[[UIDevice currentDevice] name],[NSString stringWithFormat:@"%f",IOS_VERSION],@"ios",[appDelegate.appDefault objectForKey:@"DeviceToken"]] backBlock:(^(NSDictionary * dic ) {
        
        if ([[dic objectForKey:@"ReturnValues"]isEqualToString:@"0"])
        {
            _registerData = dic;
            [activity stop];
            [self loginBtnClick];
            
           
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"1"])
        {
            
            [activity stop];

            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码已注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert1 show];
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"2"])
        {
            
            [activity stop];

            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不是有效的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert1 show];
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"99"])
        {
            
            [activity stop];

        
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"系统异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert1 show];
        }
    })];



}
- (BOOL)checkTel:(NSString *)tel
{
    
    if ([tel length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"号码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    
    NSString *regex;
    
    
    regex = [NSString stringWithFormat:@"%@", @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,2,3,5-9]))\\d{8}[xX]{0,1}$"];
    
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:tel];
    
    if (!isMatch)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    return YES;
}
//登陆
-(void)loginBtnClick
{
    
    Activity *cativity = [[Activity alloc] initWithActivity:self.view];
    
    [cativity start];
    
    BOOL check = [self checkTel:_phone];
    
    if (check == NO)
    {
        
        [cativity stop];
        
        return;
    }
    
    
    httpRequest *request = [[httpRequest alloc] init];
    [request httpRequestSend:[NSString stringWithFormat:@"%@user/UserLogin",SERVICE_ADD] parameter:[NSString stringWithFormat:@"LoginName=%@&PassWord=%@&DeviceName=%@&DeviceVersion=%@&SystemType=%@",_phone,_codeTF.text,[[UIDevice currentDevice] name],[NSString stringWithFormat:@"%f" ,IOS_VERSION],@"ios"] backBlock:(^(NSDictionary * dic) {
        
        if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
        {
            [cativity stop];
            //登陆成功
            [appDelegate.appDefault setObject:[dic objectForKey:@"UserId"] forKey:@"UserId"];
            [appDelegate.appDefault setObject:[dic objectForKey:@"LoginName"] forKey:@"LoginName"];
            [appDelegate.appDefault setObject:[dic objectForKey:@"Token"] forKey:@"Token"];
            
            [appDelegate.appDefault setObject:@"1" forKey:@"hasLogIn"];
            
            
            
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
            
            
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"2"])
        {
            [cativity stop];
            
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不是有效手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert1 show];
            
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"3"])
        {
            [cativity stop];
            
            UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert2 show];
            
            
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"4"])
        {
            
            [cativity stop];
            
            UIAlertView *alert3 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"账号已锁定" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert3 show];
            
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"99"])
        {
            [cativity stop];
            
            UIAlertView *alert4 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"系统异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert4 show];
            
        }
        
    })];
    
    
    
    
    
    
}
#pragma mark -
#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _authTF.keyboardType=UIKeyboardTypeNumberPad;
    _codeTF.keyboardType=UIKeyboardTypeASCIICapable;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //原密码的判断
    if (textField.tag==1) {
        if ([textField.text isEqual:@""]) {
            _lineImageView1.image=[UIImage imageNamed:@"线5.png"];
        }
        else
        {
            _lineImageView1.image=[UIImage imageNamed:@"线4.png"];
        }
        
    }
    //新密码的判断
    if (textField.tag==2) {
        if ([textField.text isEqual:@""]) {
            _lineImageView2.image=[UIImage imageNamed:@"线5.png"];
        }
        else
        {
            _lineImageView2.image=[UIImage imageNamed:@"线4.png"];
        }
    }
}
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
