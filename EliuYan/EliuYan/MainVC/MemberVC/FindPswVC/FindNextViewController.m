//
//  FindNextViewController.m
//  ELiuYan
//
//  Created by eliuyan_mac on 14-4-28.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "FindNextViewController.h"
#import "httpRequest.h"
#import "MemberDetailViewController.h"
#import "AppDelegate.h"
#import "NavCustom.h"
@interface FindNextViewController ()

@end

@implementation FindNextViewController

-(id)initWithPhoneNumber:(NSString *)phoneNumer
{
    
    self =  [super init];
    if (self) {
        self.phone1 = phoneNumer;
        
    }
    
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameLabel.text=@"找回密码";
    [self.orderView removeFromSuperview];
    
    
    NavCustom *navCust = [[NavCustom alloc] init];
    [navCust setNav:@"找回密码" mySelf:self];
    
    
    //self.navigationItem.title = @"找回密码";

    UILabel * headerLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 250, 44)];
    headerLabel.text=@"请填写您收到的验证码及密码";
    headerLabel.textColor=[UIColor grayColor];
    headerLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerLabel];
    
    if (IOS_VERSION < 7.0) {
        _authTF1=[[UITextField alloc] initWithFrame:CGRectMake(30, 60, 160, 44)];

    } else {
        _authTF1=[[UITextField alloc] initWithFrame:CGRectMake(30, 50, 160, 44)];

    }
    _authTF1.delegate=self;
    _authTF1.tag = 3;
    _authTF1.placeholder = @"验证码";
    [self.view addSubview:_authTF1];
    
    _lineImageView1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"线5.png"]];
    _lineImageView1.frame=CGRectMake(30, 50+34, 170, 1);
    [self.view addSubview:_lineImageView1];
    
    
    _getAuth1 = [[UIButton alloc] initWithFrame:CGRectMake(200, 55, 100, 30)];
    [_getAuth1 setTitle:@"重新获取" forState:UIControlStateNormal];
    [_getAuth1 setBackgroundColor:eliuyan_color(0xe94f4f)];
    _getAuth1.tag = 1000;
    [_getAuth1 addTarget:self action:@selector(getTheAuth1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getAuth1];
    
    
    
    
    if (IOS_VERSION <7.0)
    {
        _codeTF1=[[UITextField alloc] initWithFrame:CGRectMake(30, 110, 240, 44)];

    }
    else
    {
        _codeTF1=[[UITextField alloc] initWithFrame:CGRectMake(30, 100, 240, 44)];

    }
    _codeTF1.delegate=self;
    _codeTF1.tag = 4;
    _codeTF1.secureTextEntry = YES;
    _codeTF1.placeholder = @"密码";
    [self.view addSubview:_codeTF1];
    
    _lineImageView2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"线5.png"]];
    _lineImageView2.frame=CGRectMake(30, 100+34, 240, 1);
    [self.view addSubview:_lineImageView2];
    
    
    UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 150, 70, 30)];
    showLabel.text = @"显示密码";
    showLabel.textColor = [UIColor redColor];
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
    
    _isShow1 = NO;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==_codeTF1)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
        
    }
    return YES;
}


#pragma mark -
#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.authTF1.keyboardType=UIKeyboardTypeNumberPad;
    
    _codeTF1.keyboardType=UIKeyboardTypeASCIICapable;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //原密码的判断
    if (textField.tag==3) {
        if ([textField.text isEqual:@""]) {
            self.lineImageView1.image=[UIImage imageNamed:@"线5.png"];
        }
        else
        {
            self.lineImageView1.image=[UIImage imageNamed:@"线4.png"];
        }
        
    }
    //新密码的判断
    if (textField.tag==4) {
        if ([textField.text isEqual:@""]) {
            self.lineImageView2.image=[UIImage imageNamed:@"线5.png"];
        }
        else
        {
            self.lineImageView2.image=[UIImage imageNamed:@"线4.png"];
        }
    }
}


-(void)getTheAuth1:(UIButton *)btn
{
    
    
    if (btn.tag == 1000)
    {
    
        Activity *activity = [[Activity alloc] initWithActivity:self.view];
        [activity start];
        
        
        
    httpRequest *http = [[httpRequest alloc] init];
    [http httpRequestSend:[NSString stringWithFormat:@"%@user/SenderCode",SERVICE_ADD] parameter:[NSString stringWithFormat:@"TelPhoneNum=%@&CodeType=%@",self.phone1,@"1"] backBlock:(^(NSDictionary * dic) {
        
        if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
        {
            self.authReturnData1 = dic;
            [self.getAuth1 setTitle:@"重新获取" forState:UIControlStateNormal];
            [activity stop];
            [_authTF1 resignFirstResponder];

            MBProgressHUD *indicator = [[MBProgressHUD alloc] initWithView:self.view];
            indicator.labelText = @"发送成功";
            indicator.mode = MBProgressHUDModeText;
            [self.view addSubview:indicator];
            [indicator showAnimated:YES whileExecutingBlock:^{
                sleep(1.2);
            } completionBlock:^{
                [indicator removeFromSuperview];
                
                
            }];
            
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"1"])
        {
            [activity stop];

            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
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
}
-(void)showBtn:(UIButton *)btn
{
    
    self.isShow1 = !self.isShow1;
    
    if (self.isShow1)
    {
        self.codeTF1.secureTextEntry = NO;
        [btn setBackgroundImage:[UIImage imageNamed:@"显示密码-已选.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        
        self.codeTF1.secureTextEntry = YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"显示密码-未选.png"] forState:UIControlStateNormal];
    }
    
    
    
}
-(void)nextBtnClick:(UIButton *)btn
{

    if (![self.authTF1.text isEqualToString:[self.authReturnData1 objectForKey:@"Code"]])
    {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert1 show];
        
        return;
    }
    
    
    if ([self.codeTF1.text length] <6 || [self.codeTF1.text length] > 12)
    {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码长度为6-12位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert1 show];
        
        return;
    }
    Activity *activity = [[Activity alloc] initWithActivity:self.view];
    [activity start];
    
   
    httpRequest *http1 = [[httpRequest alloc] init];
    [http1 httpRequestSend:[NSString stringWithFormat:@"%@user/FindPassWord",SERVICE_ADD] parameter:[NSString stringWithFormat:@"LoginName=%@&PassWord=%@",self.phone1,self.codeTF1.text] backBlock:(^(NSDictionary * dic ) {
        
        if ([[dic objectForKey:@"ReturnValues"]isEqualToString:@"0"])
        {
            [activity stop];
            
            
            [self loginBtnClick];
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
    
    httpRequest *request = [[httpRequest alloc] init];
    
    [request httpRequestSend:[NSString stringWithFormat:@"%@user/UserLogin",SERVICE_ADD] parameter:[NSString stringWithFormat:@"LoginName=%@&PassWord=%@&DeviceName=%@&DeviceVersion=%@&SystemType=%@",self.phone1,self.codeTF1.text,[[UIDevice currentDevice] name],[NSString stringWithFormat:@"%f" ,IOS_VERSION],@"ios"] backBlock:(^(NSDictionary * dic) {
        
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
