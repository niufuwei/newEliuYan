//
//  ChangeAppelViewController.m
//  ELiuYan
//
//  Created by eliuyan_mac on 14-4-28.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "ChangeAppelViewController.h"
#import "httpRequest.h"
#import "AppDelegate.h"
#import "MemberCenterViewController.h"
#import "NavViewController.h"
@interface ChangeAppelViewController ()

@end

@implementation ChangeAppelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)getBackName:(void (^)(NSString *))backName
{
    if(self)
    {
        _backName = backName;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.nameLabel.text=@"修改称呼";
    [self.orderView removeFromSuperview];
//    self.navigationItem.title = @"修改称呼";
    NavCustom *nav=[[NavCustom alloc] init];
    [nav setNav:@"修改称呼" mySelf:self];
//    [nav setNavRightBtnTitle:@"保存" mySelf:self width:30 height:20];
    [appDelegate hidenTabbar];

    //请填写手机号码
    UILabel * headerLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 260, 44)];
    headerLabel.text=@"为了与商家沟通,请填写您的称呼";
    headerLabel.textColor=[UIColor grayColor];
    headerLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerLabel];
    
    _numberTF=[[UITextField alloc] initWithFrame:CGRectMake(20, 50, 200, 44)];
    _numberTF.delegate=self;
    if (IOS_VERSION < 7.0)
    {
        [_numberTF setFrame:CGRectMake(20, 60, 200, 44)];
    }
    
    [_numberTF becomeFirstResponder];
    _numberTF.placeholder = @"请填写您的称呼";
    [self.view addSubview:_numberTF];
    
    _lineImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"线5.png"]];
    _lineImageView.frame=CGRectMake(10, 50+34, 300, 1);
    [self.view addSubview:_lineImageView];
    
    
    activity = [[Activity alloc] initWithActivity:self.view];

    
    //保存按钮
    UIButton *saveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame=CGRectMake(320-60+3, 12, 40, 20);
    saveBtn.tag = 2048;
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:saveBtn];
}
#pragma mark -
#pragma mark - UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if ([textField.text isEqual:@""]) {
        self.lineImageView.image=[UIImage imageNamed:@"线5.png"];
    }
    else
    {
        self.lineImageView.image=[UIImage imageNamed:@"线4.png"];
    }
    
}


-(void)saveBtnClick:(UIButton *)btn
{
    
    UIButton *btn1 = (UIButton *)btn;
//    [btn1 setImage:[UIImage imageNamed:@"保存-按住.png"] forState:UIControlStateNormal];
    btn1.userInteractionEnabled = NO;
    
    [activity start];
    
    
    httpRequest *http = [[httpRequest alloc] init];
    http.httpDelegate = self;
    [http httpRequestSend:[NSString stringWithFormat:@"%@user/UpdateReallyName",SERVICE_ADD] parameter:[NSString stringWithFormat:@"Id=%@&ReallyName=%@&Token=%@",[appDelegate.appDefault objectForKey:@"UserId"],_numberTF.text,[appDelegate.appDefault objectForKey:@"Token"]] backBlock:^(NSDictionary * dic) {
        
        if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
        {
            [activity stop];
            
            _backName(_numberTF.text);
            [appDelegate.appDefault setObject:_numberTF.text forKey:@"ReallyName"];
            btn1.userInteractionEnabled = YES;
            
            [[self.navigationController.navigationBar viewWithTag:2048] removeFromSuperview];

            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"99"])
        {
            [activity stop];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"系统异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            btn1.userInteractionEnabled = YES;

        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"88"])
        {
            [activity stop];
           
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您的账号在别处登录,请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.delegate = self;
            [alert show];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LoginName"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ReallyName"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hasLogIn"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Token"];
            btn1.userInteractionEnabled = YES;

        }
        
    }];
    



}
-(void)httpRequestError:(NSString *)str
{
    [self.view viewWithTag:2048].userInteractionEnabled = YES;
    [activity stop];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        MemberCenterViewController *memCenter = [[MemberCenterViewController alloc] init];
        UINavigationController * nav = [[NavViewController alloc] initWithRootViewController:memCenter];
         _isLoginViewShow = YES;
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }
    else
    {
    
        [self.navigationController popViewControllerAnimated:YES];
    
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogIn"] isEqualToString:@""])
    {
        [[self.navigationController.navigationBar viewWithTag:2048] removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }


}
-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:YES];
    
    if (!_isLoginViewShow)
    {
        [[self.navigationController.navigationBar viewWithTag:2048] removeFromSuperview];
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
