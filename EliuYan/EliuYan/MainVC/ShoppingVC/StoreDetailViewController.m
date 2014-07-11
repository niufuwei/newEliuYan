//
//  StoreDetailViewController.m
//  ELiuYan
//
//  Created by shanchen on 14-4-24.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "StoreDetailViewController.h"
#import "MemberCenterViewController.h"
#import "AppDelegate.h"


@interface StoreDetailViewController ()

@end

@implementation StoreDetailViewController

@synthesize nav;


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

    [self setLeftItem];

    self.view.backgroundColor=eliuyan_color(0xf5f5f5);

}

-(void)createUI
{
    
    //asas
    nav=[[NavCustom alloc] init];
    [nav setNav:@"店铺详情" mySelf:self];
   
    
    //店铺logo
    UIImageView *logoImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 60, 60)];

    //关闭按钮
    closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame=CGRectMake(320-60+3, 10, 45, 25);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"关闭.png"] forState:UIControlStateNormal];
    [closeBtn setBackgroundColor:[UIColor blackColor]];
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:closeBtn];

    
    [logoImageView setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"LogUrl"]] placeholderImage:[UIImage imageNamed:@"暂无.png"]];

    [self.view addSubview:logoImageView];
    
    UILabel *storeName=[[UILabel alloc] initWithFrame:CGRectMake(logoImageView.frame.origin.x+logoImageView.frame.size.width+10, 10, 220, 20)];
    storeName.backgroundColor=[UIColor clearColor];
    storeName.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"StoreName"];
    storeName.font = [UIFont  systemFontOfSize:17];
    storeName.textColor = eliuyan_color(0x404040);
    [self.view addSubview:storeName];
    //店铺位置
    UILabel *storeLocation=[[UILabel alloc] initWithFrame:CGRectMake(logoImageView.frame.origin.x+logoImageView.frame.size.width+10, storeName.frame.size.height+storeName.frame.origin.y, 220, 20)];
    storeLocation.backgroundColor=[UIColor clearColor];
    storeLocation.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"Address"];
    storeLocation.font = [UIFont systemFontOfSize:14];
    storeLocation.textColor = eliuyan_color(0x404040);
    [self.view addSubview:storeLocation];
    //店铺距离
    UILabel *storeDitance=[[UILabel alloc] initWithFrame:CGRectMake(logoImageView.frame.origin.x+logoImageView.frame.size.width+10, storeLocation.frame.size.height+storeLocation.frame.origin.y, 200, 20)];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Delivery"]floatValue ]>=1.0) {
        storeDitance.text=[NSString stringWithFormat:@"%.1f千米",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Delivery"]floatValue ]];
    }
    else
    {
        storeDitance.text=[NSString stringWithFormat:@"%.0f米",[[[NSUserDefaults standardUserDefaults] objectForKey:@"Delivery"]floatValue ]*1000];
    }
    

    storeDitance.font = [UIFont systemFontOfSize:14];
    storeDitance.textColor=eliuyan_color(0xff5d51);
    storeDitance.backgroundColor = [UIColor clearColor];
    [self.view addSubview:storeDitance];
    
    UIImageView * imageHeng = [[UIImageView alloc] initWithFrame:CGRectMake(10, logoImageView.frame.size.height+logoImageView.frame.origin.y+5, 300,1)];
    [imageHeng setBackgroundColor:[UIColor colorWithRed:218.0/255.0 green:217.0/255.0 blue:205.0/255.0 alpha:1]];
    [self.view addSubview:imageHeng];
    
    //初始化详细信息
    //初始化联系号码
    UILabel * phoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(10, imageHeng.frame.size.height+imageHeng.frame.origin.y+5,90, 20)];
    phoneNumber.text = @"联系号码";
    phoneNumber.backgroundColor=[UIColor clearColor];
    phoneNumber.textColor = eliuyan_color(0xababaa);
    phoneNumber.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:phoneNumber];
    
    UILabel * phoneNumberRight = [[UILabel alloc] initWithFrame:CGRectMake(phoneNumber.frame.size.width+phoneNumber.frame.origin.x+2, imageHeng.frame.size.height+imageHeng.frame.origin.y+5,90, 20)];
    phoneNumberRight.backgroundColor=[UIColor clearColor];
    phoneNumberRight.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"TelPhone"];
    phoneNumberRight.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:phoneNumberRight];
    
    //初始化起送金额
    UILabel * money = [[UILabel alloc] initWithFrame:CGRectMake(10, phoneNumber.frame.size.height+phoneNumber.frame.origin.y+2, 90, 20)];
    money.text = @"起送金额";
    money.backgroundColor=[UIColor clearColor];
    money.textColor =eliuyan_color(0xababaa);
    money.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:money];
    
    UILabel * moneyRight = [[UILabel alloc] initWithFrame:CGRectMake(money.frame.size.width+money.frame.origin.x+2, phoneNumber.frame.size.height+phoneNumber.frame.origin.y+5,90, 20)];
    moneyRight.backgroundColor=[UIColor clearColor];
    if([_type isEqualToString:@"水果店"])
    {
        moneyRight.text =@"--";

    }
    else
    {
        moneyRight.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"MinBuy"];

    }
    moneyRight.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:moneyRight];
    
    
    //初始化配送时间
    UILabel * time = [[UILabel alloc] initWithFrame:CGRectMake(10, money.frame.size.height+money.frame.origin.y+2, 90, 20)];
    time.text = @"配送时间";
    time.backgroundColor=[UIColor clearColor];
    time.textColor = eliuyan_color(0xababaa);
    time.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:time];
    
    UILabel * timeRight = [[UILabel alloc] initWithFrame:CGRectMake(time.frame.size.width+time.frame.origin.x+2, money.frame.size.height+money.frame.origin.y+5,90, 20)];
    timeRight.backgroundColor=[UIColor clearColor];
    timeRight.text =[NSString stringWithFormat:@"%@-%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"StartTime"] substringWithRange:NSMakeRange(11, 5)],[[[NSUserDefaults standardUserDefaults] objectForKey:@"EndTime"] substringWithRange:NSMakeRange(11, 5)]] ;
    timeRight.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:timeRight];
    
    
    //初始化联系卖家
    UIButton * contact=[UIButton buttonWithType:UIButtonTypeCustom];
    contact.frame = CGRectMake(timeRight.frame.origin.x+timeRight.frame.size.width+20,imageHeng.frame.size.height+imageHeng.frame.origin.y+5, 90, 33);
    [contact setBackgroundImage:[UIImage imageNamed:@"contact_shop.png"] forState:UIControlStateNormal];
    [contact setBackgroundImage:[UIImage imageNamed:@"contact_shop_selected.png"] forState:UIControlStateHighlighted];
    [contact setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [contact setBackgroundColor:[UIColor redColor]];
    contact.tag = 102;
    [contact addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:contact];
    
    
    
    UIImageView * imageHeng2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, time.frame.size.height+time.frame.origin.y+5, 300,1)];
    [imageHeng2 setBackgroundColor:[UIColor colorWithRed:218.0/255.0 green:217.0/255.0 blue:205.0/255.0 alpha:1]];
    [self.view addSubview:imageHeng2];
    
    
    //投诉或意见
    UILabel * opinionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, imageHeng2.frame.size.height+imageHeng2.frame.origin.y+10,150, 20)];
    opinionLabel.text = @"投诉或意见";
    opinionLabel.backgroundColor=[UIColor clearColor];
    opinionLabel.font = [UIFont systemFontOfSize:17];
    opinionLabel.textColor = eliuyan_color(0x404040);
    [self.view addSubview:opinionLabel];
    
    opinionText = [[UITextView alloc] initWithFrame:CGRectMake(20, opinionLabel.frame.size.height+opinionLabel.frame.origin.y+5, 280, 100)];
    opinionText.delegate = self;
    opinionText.backgroundColor = [UIColor clearColor];
    opinionText.font = [UIFont systemFontOfSize:15];
    opinionText.textColor = eliuyan_color(0x404040);
    [self.view addSubview:opinionText];
    
    UIImageView * imageHeng3 = [[UIImageView alloc] initWithFrame:CGRectMake(20, opinionText.frame.size.height+opinionText.frame.origin.y, 280,1)];
    [imageHeng3 setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:imageHeng3];
    
    
    //提交意见
    UIButton * confirmBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(50, imageHeng3.frame.size.height+imageHeng3.frame.origin.y+28, 220, 40);
    [confirmBtn setTitle:@"提交意见" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:[UIColor redColor]];
    [confirmBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.tag = 103;
    [self.view addSubview:confirmBtn];
    
    
}
-(void)closeBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    closeBtn.hidden=YES;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    closeBtn.hidden=NO;
    [appDelegate hidenTabbar];

}


//提交意见处理方法
-(IBAction)onClick:(id)sender
{
    UIButton * btn = (UIButton*)sender;
    switch (btn.tag) {
        case 101:
        {
//            [self dismissModalViewControllerAnimated:YES];
        }
            break;
        case 102:
        {
            UIWebView*callWebview =[[UIWebView alloc] init];
            
            NSString *telUrl = [NSString stringWithFormat:@"tel:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"TelPhone"]];
            
            NSURL *telURL =[NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
            
            [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
            
            //记得添加到view上
            
            [self.view addSubview:callWebview];
            
        }
            break;
        case 103:
        {
           
            if([opinionText.text length]==0)
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入建议" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogIn"] isEqualToString:@"1"])
                {

                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您还没有登录，赶快去登录吧" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                    alert.tag=222;
                    alert.delegate=self;
                    [alert show];

                }
                else
                {
                    ac = [[Activity alloc] initWithActivity:self.view];
                    [ac start];
                    //服务器请求
                    httpRequest * http = [[httpRequest alloc] init];
                    
                    http.httpDelegate=self;
                    
                    [http httpRequestSend:[NSString stringWithFormat:@"%@user/CreateSuggest",SERVICE_ADD] parameter:[NSString stringWithFormat:@"UserId=%@&StoreId=%@&Content=%@&Token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"],[[NSUserDefaults standardUserDefaults]  objectForKey:@"storeId"],opinionText.text,[[NSUserDefaults standardUserDefaults]  objectForKey:@"Token"]] backBlock:(^(NSDictionary *dic){
                        
                        if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
                        {
                            [ac stop];
                            __block UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"提交成功!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            alert.tag = 111;
                            [alert show];
                        }
                        else if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"88"])
                        {
                            [ac stop];

                            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"警告" message:@"您的账号在别处登录,请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                            alertView.delegate=self;
                            alertView.tag=222;
                            //登录状态 token 值
                            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hasLogIn"];
                            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Token"];
                            [alertView show];
                            
                        }
                        
                        else
                        {
                            [ac stop];
                            __block UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"提交失败!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            alert.tag =333;
                            [alert show];
                        }
                        
                        
                    })];

                }
            }
          
        }
            break;
        default:
            break;
    }
}

-(void)httpRequestError:(NSString *)str
{
    [ac  stop];
}
#pragma mark - 
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 111:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 222:
        {
            if(buttonIndex==0)
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isBack"];
                //跳转到登录界面
                MemberCenterViewController *memberVC=[[MemberCenterViewController alloc] init];
                [self presentViewController:memberVC animated:YES completion:^{
                    
                }];
            }
        }
            break;
        case 333:
            break;
    }
}
#pragma mark -
#pragma mark - UITextFieldDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    //开始动画
    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:0.5];
    //动画的内容
    CGRect yy = self.view.frame;
    yy.origin.y = -216+75+50;
    self.view.frame = yy;
    //动画结束
    [UIView commitAnimations];
   
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    //开始动画
    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:0.3];
    //动画的内容
    CGRect yy = self.view.frame;
    if (IOS_VERSION>=7.0) {
        yy.origin.y = 66;
    }
    else
    {
        yy.origin.y = 0;
    }
    
    self.view.frame = yy;
    //动画结束
    [UIView commitAnimations];

}

-(void ) setLeftItem{
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *image = [UIImage imageNamed:no_select_backImageName];
//    
//    backButton.backgroundColor=[UIColor clearColor];
//    backButton.frame = CGRectMake(-20, 0, 40, 30);
//    [backButton setBackgroundImage:image forState:UIControlStateNormal];
//    [backButton setBackgroundImage: [UIImage imageNamed:@""] forState:UIControlStateHighlighted];
//    
//    [backButton addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    if([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
    {
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
