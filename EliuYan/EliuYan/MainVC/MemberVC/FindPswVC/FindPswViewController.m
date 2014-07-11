//
//  FindPswViewController.m
//  ELiuYan
//
//  Created by shanchen on 14-4-23.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "FindPswViewController.h"
#import "FindNextViewController.h"




@interface FindPswViewController ()
{
    Activity *activity;
}

@end

@implementation FindPswViewController

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
    self.nameLabel.text=@"找回密码";
    [self.orderView removeFromSuperview];
    self.navigationItem.title = @"找回密码";

    //请填写手机号码
    _headerLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 44)];
    _headerLabel.text=@"请填写手机号码";
    _headerLabel.textColor=[UIColor grayColor];

    _headerLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_headerLabel];
  
    
    if (IOS_VERSION < 7.0)
    {
        _numberTF=[[UITextField alloc] initWithFrame:CGRectMake(40, 50, 280, 44)];

    }
    else
    {
    
        _numberTF=[[UITextField alloc] initWithFrame:CGRectMake(40, 40, 280, 44)];

    
    }
    
    [_numberTF becomeFirstResponder];
    _numberTF.delegate=self;
    _numberTF.placeholder = @"手机号码";
    [self.view addSubview:_numberTF];
    
    _lineImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"线5.png"]];
    _lineImageView.frame=CGRectMake(40, 40+34, 240, 1);
    [self.view addSubview:_lineImageView];
    
    //下一步btn
    _nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame=CGRectMake(40, 120, 240, 40);
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn setBackgroundColor:[UIColor redColor]];
    [_nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    
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
//下一步按钮
-(void)nextBtnClick:(id)sender
{
    NSLog(@"找回密码下一步按钮被点击了");
    //跳转到修改密码界面
    
    NSLog(@"numeber is %@",_numberTF.text);
    if ([self checkTel:_numberTF.text])
    {
        activity = [[Activity alloc] initWithActivity:self.view];
        [activity start];
        
        
        
        httpRequest *http = [[httpRequest alloc] init];
        http.httpDelegate = self;

        [http httpRequestSend:[NSString stringWithFormat:@"%@user/SenderCode",SERVICE_ADD] parameter:[NSString stringWithFormat:@"TelPhoneNum=%@&CodeType=%@",_numberTF.text,@"1"] backBlock:(^(NSDictionary * dic) {
         
            [activity stop];

            if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
            {
                FindNextViewController *changeVC=[[FindNextViewController alloc] initWithPhoneNumber:_numberTF.text];
                changeVC.authReturnData1 = dic;
                [self.navigationController pushViewController:changeVC animated:YES];
                
            }
            else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"1"])
            {
                UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
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
