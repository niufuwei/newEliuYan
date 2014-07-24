//
//  RegistViewController.m
//  ELiuYan
//
//  Created by shanchen on 14-4-23.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "RegistViewController.h"
#import "InputViewController.h"
#import "SecretViewController.h"
#import "NavCustom.h"

@interface RegistViewController ()
{
    Activity *activity;
}

@end

@implementation RegistViewController

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
    //创建UI
    [self createUI];
    [self.orderView removeFromSuperview];

    
}

//创建UI
-(void)createUI
{
    
    NavCustom *navCust = [[NavCustom alloc] init];
    [navCust setNav:@"账号注册" mySelf:self];
    
   
    //请填写手机号码
    _headerLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 44)];
    _headerLabel.text=@"请填写手机号码";
    _headerLabel.textColor=[UIColor grayColor];
    _headerLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_headerLabel];
    
    
    if (IOS_VERSION < 7.0)
    {
        _numberTF=[[UITextField alloc] initWithFrame:CGRectMake(40, 60, 280, 44)];
    }
    else
    {
    
        _numberTF=[[UITextField alloc] initWithFrame:CGRectMake(40, 50, 280, 44)];

    }
    _numberTF.placeholder = @"手机号码";
    [_numberTF becomeFirstResponder];
    _numberTF.delegate=self;
    _numberTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_numberTF];
    
    _lineImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"线5.png"]];
    _lineImageView.frame=CGRectMake(40, 50+34, 240, 1);
    [self.view addSubview:_lineImageView];
    _agree = NO;
    
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(35, 100, 20, 20)];
    [btn setBackgroundImage:[UIImage imageNamed:@"显示密码-已选.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(agreeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    _agree = YES;
    
    
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 95,90, 30)];
    desLabel.text = @"已阅读并同意";
    desLabel.font = [UIFont systemFontOfSize:14.0];
    desLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:desLabel];
    
    
    UIButton *xieyi = [[UIButton alloc] initWithFrame:CGRectMake(150, 93, 60, 35)];
    [xieyi setTitle:@"服务协议" forState:UIControlStateNormal];
    [xieyi addTarget:self action:@selector(showXieyi:) forControlEvents:UIControlEventTouchUpInside];
    xieyi.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [xieyi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [xieyi setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.view addSubview:xieyi];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(150, 93 + 24, 60, 1)];
    imageView1.image = [UIImage imageNamed:@"线5"];
    [self.view addSubview:imageView1];
    
    
   
    
    
    
    
    //下一步btn
    _nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame=CGRectMake(40, 150, 240, 40);
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn setBackgroundColor:eliuyan_color(0xe94f4f)];
    [_nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];

    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==_numberTF)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];

    }
    return YES;
}

-(void)showXieyi:(UIButton *)btn
{
    
    SecretViewController *secretVC = [[SecretViewController alloc] init];
    
    [self.navigationController pushViewController: secretVC animated:YES];
    
    
}

-(void)agreeBtn:(UIButton *)btn
{
    _agree = !_agree;
    
    if (_agree)
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"显示密码-已选.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"显示密码-未选.png"] forState:UIControlStateNormal];
        
    }
    
}

- (BOOL)checkTel:(NSString *)tel
{
    
    if ([tel length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
//返回按钮
-(void)returnBtnClick:(id)sender
{
    NSLog(@"返回按钮被点击了");
    //pop出去
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)nextBtnClick:(id)sender
{
    if ([self checkTel:_numberTF.text] == YES)
    {
        
        if (_agree)
        {
            activity = [[Activity alloc]initWithActivity:self.view];
            [activity start];
            
            
            httpRequest *http = [[httpRequest alloc] init];
            http.httpDelegate = self;
            [http httpRequestSend:[NSString stringWithFormat:@"%@user/SenderCode",SERVICE_ADD] parameter:[NSString stringWithFormat:@"TelPhoneNum=%@&CodeType=%@",_numberTF.text,@"0"] backBlock:(^(NSDictionary * dic) {
                [activity stop];
                
                if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
                {
                    InputViewController *inputVC=[[InputViewController alloc] initWithPhoneNumber:_numberTF.text];
                    inputVC.authReturnData = dic;
                    [self.navigationController pushViewController:inputVC animated:YES];
                    
                }
                else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"1"])
                {
                    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码已注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert1 show];
                    
                }
                else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"2"])
                {
                    
                    UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不是有效的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert2 show];
                    
                }
                else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"99"])
                {
                    
                    UIAlertView *alert3 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"系统异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert3 show];
                    
                }
            })];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"需要接受相关协议" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
    
    NSLog(@"注册下一步按钮被点击了");
    //如果号码符合就跳转到提交注册界面
    
}

-(void)httpRequestError:(NSString *)str
{
    [activity stop];
}
#pragma mark -
#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _numberTF.keyboardType=UIKeyboardTypeNumberPad;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if ([textField.text isEqual:@""]) {
        _lineImageView.image=[UIImage imageNamed:@"线5.png"];
    }
    else
    {
        _lineImageView.image=[UIImage imageNamed:@"线4.png"];
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
