//
//  MemberCenterViewController.m
//  ELiuYan
//
//  Created by shanchen on 14-4-22.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "MemberCenterViewController.h"
#import "RegistViewController.h"
#import "FindPswViewController.h"
#import "MemberDetailViewController.h"
#import "httpRequest.h"
#import "AppDelegate.h"
#import "NavCustom.h"
@interface MemberCenterViewController ()
{


    NavCustom *myNavCustom;

}
@end

@implementation MemberCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setLeftItem];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

    //创建UI
    //初始化导航条
    myNavCustom = [[NavCustom alloc] init];
    [myNavCustom setNav:@"登录" mySelf:self];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUI];
    
}

-(void)getBackBlock:(void (^)(NSString *))block
{
    if(self)
    {
        _backBlock = block;
    }
}

//创建UI
-(void)createUI
{
    
    
    if (IOS_VERSION < 7.0)
    {
        _numberTF=[[UITextField alloc] initWithFrame:CGRectMake(20, 20, 280, 44)];
    }
    else
    {
    
        _numberTF=[[UITextField alloc] initWithFrame:CGRectMake(20, 20, 280, 44)];
        
    
    }
    _numberTF.delegate=self;
    [self.view addSubview:_numberTF];
    _numberTF.placeholder = @"手机号码";
    //[_numberTF becomeFirstResponder];
    UIImageView *lineImageView1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"线4.png"]];
    if (IOS_VERSION < 7.0)
    {
        
        lineImageView1.frame=CGRectMake(20, 20+24, 280, 1);
    }
    else
    {
        lineImageView1.frame=CGRectMake(20, 20+34, 280, 1);
        
    }
    [self.view addSubview:lineImageView1];
    
    
    if (IOS_VERSION < 7.0)
    {
        _pswTF=[[UITextField alloc] initWithFrame:CGRectMake(20, 65, 280, 44)];
    }
    else
    {
    
        _pswTF=[[UITextField alloc] initWithFrame:CGRectMake(20, 65, 280, 44)];
    
    }
    _pswTF.secureTextEntry = YES;
    _pswTF.placeholder = @"密码";
    [self.view addSubview:_pswTF];
    
    //分割线
    UIImageView *lineImageView2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"线4.png"]];
     if (IOS_VERSION < 7.0)
     {
         
    
         lineImageView2.frame=CGRectMake(20, 65+24, 280, 1);
     }
     else
     {
      lineImageView2.frame=CGRectMake(20, 65+34, 280, 1);
     
     }
    [self.view addSubview:lineImageView2];
    
    //登陆按钮
    UIButton *loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame=CGRectMake(40, 125, 240, 40);
    loginBtn.tag = 1111;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:eliuyan_color(0xe94f4f)];
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    //找回密码
    UIButton *findPswBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    findPswBtn.frame=CGRectMake(320-40-60, 170, 60, 40);
    [findPswBtn setBackgroundImage:[UIImage imageNamed:@"找回密码-未按.png"] forState:UIControlStateNormal];
    [findPswBtn addTarget:self action:@selector(findPswBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:findPswBtn];
    
    //账号注册
    UIButton *registBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame=CGRectMake(40, 170, 60, 40);
    [registBtn setBackgroundImage:[UIImage imageNamed:@"账号注册-未按.png"] forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(registBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];


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
#pragma mark_
#pragma mark - BtnClick

//登陆按钮
-(void)loginBtnClick:(id)sender
{
    
     cativity = [[Activity alloc] initWithActivity:self.view];
    [cativity start];
    
    UIButton *btn = (UIButton *)sender;
    btn.userInteractionEnabled = NO;
    
    _numberTF.text = [_numberTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] ];
    _pswTF.text = [_pswTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] ];
    
     BOOL check = [self checkTel:_numberTF.text];
    
        if (check == NO)
        {
            [cativity stop];
            btn.userInteractionEnabled = YES;
            return;
        }

    httpRequest *request = [[httpRequest alloc] init];
    request.httpDelegate = self;
    [request httpRequestSend:[NSString stringWithFormat:@"%@user/UserLogin",SERVICE_ADD] parameter:[NSString stringWithFormat:@"LoginName=%@&PassWord=%@&DeviceName=%@&DeviceVersion=%@&SystemType=%@&DeviceToken=%@",_numberTF.text,_pswTF.text,[[UIDevice currentDevice] name],[NSString stringWithFormat:@"%f" ,IOS_VERSION],@"ios",[appDelegate.appDefault objectForKey:@"DeviceToken"]] backBlock:(^(NSDictionary * dic) {
        
        if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
        {
            [cativity stop];
            //登陆成功
            btn.userInteractionEnabled = YES;

            
            
            [appDelegate.appDefault setObject:[dic objectForKey:@"UserId"] forKey:@"UserId"];
            [appDelegate.appDefault setObject:[dic objectForKey:@"LoginName"] forKey:@"LoginName"];
            [appDelegate.appDefault setObject:[dic objectForKey:@"ReallyName"] forKey:@"ReallyName"];
            
            [appDelegate.appDefault setObject:[dic objectForKey:@"Token"] forKey:@"Token"];
            
            [appDelegate.appDefault setObject:@"1" forKey:@"hasLogIn"];
            
            

            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isBack"] isEqualToString:@"0"])
            {
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isBackToDelivery"] isEqualToString:@"0"])
                {
                    self.backBlock([NSString stringWithFormat:@"%@,%@",[appDelegate.appDefault objectForKey:@"LoginName"],[appDelegate.appDefault objectForKey:@"ReallyName"]]);
                }
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isBackToDelivery"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isBack"];
            }
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"2"])
        {
            [cativity stop];

            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不是有效手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert1 show];

            btn.userInteractionEnabled = YES;

        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"3"])
        {
            [cativity stop];

            UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert2 show];

            btn.userInteractionEnabled = YES;

        
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"4"])
        {
        
            [cativity stop];

            UIAlertView *alert3 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"账号已锁定" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert3 show];
            btn.userInteractionEnabled = YES;


        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"99"])
        {
            [cativity stop];

            UIAlertView *alert4 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"系统异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert4 show];
        
            btn.userInteractionEnabled = YES;

        }
        
    })];
    
    
        
}
-(void)httpRequestError:(NSString *)str
{
    ((UIButton *)[self.view viewWithTag:1111]).userInteractionEnabled = YES;
    [cativity stop];
    
}
//找回密码
-(void)findPswBtnClick:(id)sender
{
//    UIButton *btn = (UIButton *)sender;
//    [btn setBackgroundImage:[UIImage imageNamed:@"找回密码-按住"] forState:UIControlStateNormal];
    FindPswViewController *findPswVC=[[FindPswViewController alloc] init];
    [self.navigationController pushViewController:findPswVC animated:YES];
    /////////////
}
//账号注册
-(void)registBtnClick:(id)sender
{
//    UIButton *btn = (UIButton *)sender;
//    [btn setBackgroundImage:[UIImage imageNamed:@"账号注册-按住"] forState:UIControlStateNormal];
    RegistViewController *registVC=[[RegistViewController alloc] init];
    [self.navigationController pushViewController:registVC animated:YES];
}


#pragma mark - 
#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _numberTF.keyboardType=UIKeyboardTypeNumberPad;
}

-(void ) setLeftItem{
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"返回.png"];
    
    backButton.backgroundColor=[UIColor clearColor];
    backButton.frame = CGRectMake(-20, 0, 12, 20);
    [backButton setBackgroundImage:image forState:UIControlStateNormal];

    [backButton addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    if([UIDevice currentDevice].systemVersion.floatValue >= 7.0f){
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -7.5;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftButtonItem];
    }
    else{
        self.navigationItem.leftBarButtonItem = leftButtonItem;
    }
}

-(void)popself
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
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
