//
//  MyAcountViewController.m
//  EliuYan
//
//  Created by eliuyan_mac on 14-7-3.
//  Copyright (c) 2014年 eliuyan.com. All rights reserved.
//

#import "MyAcountViewController.h"
#import "Activity.h"
#import "AppDelegate.h"

@interface MyAcountViewController ()
{

    Activity *activity;

}
@end

@implementation MyAcountViewController

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
    // Do any additional setup after loading the view.
    NavCustom *nav=[[NavCustom alloc] init];
    [nav setNav:@"我的账号" mySelf:self];
    [appDelegate hidenTabbar];
    [self.orderView removeFromSuperview];
    
    
    activity = [[Activity alloc] initWithActivity:self.view];
    
    
    UILabel *acountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 80, 30)];
    acountLabel.text = @"我的账号";
    acountLabel.backgroundColor = [UIColor clearColor];
    acountLabel.font = [UIFont systemFontOfSize:17.0];
    [self.view addSubview:acountLabel];
    
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 20, 110, 30)];
    phoneLabel.font = [UIFont systemFontOfSize:17.0];
    phoneLabel.textAlignment = NSTextAlignmentRight;
    phoneLabel.backgroundColor = [UIColor clearColor];

    phoneLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginName"];
    [self.view addSubview:phoneLabel];
    
    
    
    UIImageView * _lineImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"线5.png"]];
    _lineImageView.frame=CGRectMake(10, 70, 300, 1);
    [self.view addSubview:_lineImageView];
    
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:eliuyan_color(0xe94f4f)];
    button.frame = CGRectMake(30, 120, self.view.frame.size.width-60, 40);
    [button addTarget:self action:@selector(doLogout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}
-(void)doLogout:(id)sender
{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"退出后您将无法下单确定退出吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = 11;
    [alert show];


}
-(void)httpRequestError:(NSString *)str
{
    self.view.userInteractionEnabled = YES;
    [self.view viewWithTag:60].userInteractionEnabled = YES;
    [activity stop];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11)
    {
        if (buttonIndex == 0)
        {
            [activity start];
            
            
            
            [self.view viewWithTag:60].userInteractionEnabled = NO;
            
            httpRequest *http = [[httpRequest alloc] init];
            http.httpDelegate = self;
            [http httpRequestSend:[NSString stringWithFormat:@"%@user/UserLogout",SERVICE_ADD ] parameter:[NSString stringWithFormat:@"LoginName=%@&SystemType=%@",[appDelegate.appDefault objectForKey:@"LoginName"],@"ios"] backBlock:^(NSDictionary * dic) {
              
                
                if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
                {
                                        
                    [appDelegate.appDefault setObject:@"" forKey:@"Token"];
                    [appDelegate.appDefault setObject:@"" forKey:@"LoginName"];
                    [appDelegate.appDefault setObject:@"" forKey:@"hasLogIn"];
                    [appDelegate.appDefault setObject:@"" forKey:@"UserId"];
                    [appDelegate.appDefault setObject:@"" forKey:@"ReallyName"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideCount" object:nil];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    
                    
                    
                    
                }
                
                else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"99"])
                {
                    
                    [activity stop];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                    [self.view viewWithTag:60].userInteractionEnabled = YES;
                    
                }
                
            }];
            
            
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
