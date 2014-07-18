//
//  DeliveryInformationViewController.m
//  ELiuYan
//
//  Created by laoniu on 14-5-1.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "DeliveryInformationViewController.h"
#import "OrderSuccessfulViewController.h"
#import "OldAddressViewController.h"
#import "httpRequest.h"
#import "JSON.h"
#import "MemberCenterViewController.h"
#import "AppDelegate.h"
#import "NavViewController.h"
@interface DeliveryInformationViewController ()
{
     Activity * ac;
}

@end

@implementation DeliveryInformationViewController
@synthesize phoneField;
@synthesize nameField;
@synthesize addressText;


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
    
 
    NavCustom *nav=[[NavCustom alloc] init];
    [nav setNav:@"送货信息" mySelf:self];
    
    
    self.view.backgroundColor=eliuyan_color(0xf5f5f5);
    
    //请求曾用地址数据
    
    
    ac = [[Activity alloc] initWithActivity:self.view];
    [ac start];
    NSString *strUrl=[NSString stringWithFormat:@"%@user/GetAddressText",SERVICE_ADD];
    
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    
    [request addPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] forKey:@"UserId"];
    [request addPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"lat"] forKey:@"Lat"];
    [request addPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"lng"] forKey:@"Lng"];
    [request addPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] forKey:@"Token"];
    request.delegate=self;
    request.tag=10010;
    request.timeOutSeconds=60;
    [request startAsynchronous];
    
    
    //初始化提示信息
    UILabel * infor = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 20)];
    infor.text = @"为了方便用户能尽快收到货物，请填写以下信息";
    infor.textColor = eliuyan_color(0xababaa);
    infor.font = [UIFont systemFontOfSize:13];
    infor.backgroundColor =[UIColor clearColor];
    [self.view addSubview:infor];
    
    //初始化基本信息
    UILabel * basicInfor = [[UILabel alloc] initWithFrame:CGRectMake(20, 54, 280, 20)];
    basicInfor.backgroundColor = [UIColor clearColor];
    basicInfor.textColor = [UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:85.0/255.0 alpha:1];
    basicInfor.text = @"基本信息";
    basicInfor.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:basicInfor];
    
    //初始化手机号码
    UILabel * phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 110, 80, 20)];
    phoneLabel.textColor = eliuyan_color(0xff3333);
    phoneLabel.text= @"手机号码";
    phoneLabel.font = [UIFont systemFontOfSize:15];
    phoneLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:phoneLabel];
    
    //初始化手机号码输入框
    phoneField = [[UITextField alloc] initWithFrame:CGRectMake(110, 110, 200, 20)];
    phoneField.clearButtonMode = UITextFieldViewModeAlways;
    phoneField.keyboardType = UIKeyboardTypePhonePad;
    phoneField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginName"];
    [self.view addSubview:phoneField];
    
    UIImageView * imageHeng = [[UIImageView alloc] initWithFrame:CGRectMake(30, phoneLabel.frame.size.height+phoneLabel.frame.origin.y, 270, 1)];
    [imageHeng setBackgroundColor:eliuyan_color(0xff3333)];
    [self.view addSubview:imageHeng];
    
    //初始化称呼
    UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, imageHeng.frame.size.height+imageHeng.frame.origin.y+10, 270, 20)];
    nameLabel.textColor = eliuyan_color(0xff3333);
    nameLabel.text= @"称呼";
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:nameLabel];
    
    //初始化称呼输入框
    nameField = [[UITextField alloc] initWithFrame:CGRectMake(110, imageHeng.frame.size.height+imageHeng.frame.origin.y+10, 200, 20)];
    nameField.clearButtonMode = UITextFieldViewModeAlways;
    nameField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"ReallyName"];
    [self.view addSubview:nameField];
    
    UIImageView * imageHeng2 = [[UIImageView alloc] initWithFrame:CGRectMake(30, nameLabel.frame.size.height+nameLabel.frame.origin.y, 270, 1)];
    [imageHeng2 setBackgroundColor:eliuyan_color(0xff3333)];
    [self.view addSubview:imageHeng2];
    
    
    //初始化送货地址
    
    UILabel * addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, imageHeng2.frame.size.height+imageHeng2.frame.origin.y+15, 100, 20)];
    addressLabel.text = @"送货地址";
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.textColor = [UIColor colorWithRed:87.0/255.0 green:87.0/255.0 blue:85.0/255.0 alpha:1];
    addressLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:addressLabel];
    
    //初始化送货地址输入框
    addressText = [[UITextView alloc] initWithFrame:CGRectMake(30, addressLabel.frame.size.height+addressLabel.frame.origin.y+5, 270, 50)];
    addressText.delegate  =self;
    addressText.backgroundColor = [UIColor clearColor];
    addressText.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:addressText];
    
    UIImageView * imageHeng3 = [[UIImageView alloc] initWithFrame:CGRectMake(30, addressText.frame.size.height+addressText.frame.origin.y, 270, 1)];
    [imageHeng3 setBackgroundColor:eliuyan_color(0xff3333)];
    [self.view addSubview:imageHeng3];
    
    //初始化提示
    
    UILabel * tishi = [[UILabel alloc] initWithFrame:CGRectMake(30, imageHeng3.frame.size.height+imageHeng3.frame.origin.y+5, 200, 20)];
    tishi.text = @"请填写您详细地址，方便送货上门";
    tishi.backgroundColor = [UIColor clearColor];
    tishi.textColor =eliuyan_color(0xababaa);
    tishi.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:tishi];
    
    //初始化曾用地址按钮
    UIButton * oldAddress = [UIButton buttonWithType:UIButtonTypeCustom];
    oldAddress.frame = CGRectMake(tishi.frame.size.width+tishi.frame.origin.x+5, imageHeng3.frame.size.height+imageHeng3.frame.origin.y+5, 80, 20);
    [oldAddress setTitle:@"曾用地址>" forState:UIControlStateNormal];
    [oldAddress setTitleColor:eliuyan_color(0xff3333) forState:UIControlStateNormal];
    [oldAddress setBackgroundColor:[UIColor clearColor]];
    oldAddress.titleLabel.font = [UIFont systemFontOfSize:15];
    oldAddress.tag = 101;
    [oldAddress addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:oldAddress];
    

    //付款方式
    UILabel * paymentMethod = [[UILabel alloc] initWithFrame:CGRectMake(30, tishi.frame.size.height+tishi.frame.origin.y+15, 300, 20)];
    paymentMethod.backgroundColor = [UIColor clearColor];
    paymentMethod.text = @"付款方式";
    [self.view addSubview:paymentMethod];
    
    //货到付款
    UIButton * delivery = [UIButton buttonWithType:UIButtonTypeCustom];
    delivery.frame =CGRectMake(30, paymentMethod.frame.size.height+paymentMethod.frame.origin.y+5, 62, 20);
    [delivery setImage:[UIImage imageNamed:@"货到付款.png"] forState:UIControlStateNormal];
//    delivery.backgroundColor = [UIColor colorWithRed:16.0/255.0 green:112.0/255.0 blue:1.0/255.0 alpha:1];
//    [delivery setTitle:@"货到付款" forState:UIControlStateNormal];
//    [delivery setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    delivery.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:delivery];
    
    
    //初始化提交按钮
    UIButton * confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    confirm.frame = CGRectMake(60, delivery.frame.size.height+delivery.frame.origin.y+25, 200, 40);
    [confirm setTitle:@"提交" forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirm setBackgroundColor:eliuyan_color(0xe94f4f)];
    confirm.tag = 102;
    [confirm addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirm];
    // Do any additional setup after loading the view.
}
#pragma mark -
#pragma  mark -ASIHttpRequestDlegate

-(void)requestFinished:(ASIHTTPRequest *)request
{
    self.view.userInteractionEnabled = NO;
    SBJSON *aJson=[[SBJSON alloc] init];
    NSDictionary *allDic=[aJson objectWithString:request.responseString error:nil];
    _returnValue = [allDic objectForKey:@"ReturnValues"];
    if ([_returnValue isEqualToString:@"0"])
    {
        self.view.userInteractionEnabled = YES;
        _adress = [allDic objectForKey:@"Address"];
        //判断返回的地址是不是空 如果是空就给默认的地址 如果不是就给现在的地址
        if ([_adress isEqualToString:@""]) {
            addressText.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchAddress"];
        }
        else
        {
            addressText.text = _adress;
        }
        

    }
    else if ([_returnValue isEqualToString:@"88"])
    {
        self.view.userInteractionEnabled = YES;
        addressText.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchAddress"];
        
        
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"警告" message:@"您的账号在别处登录,请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.delegate=self;
        alertView.tag=345;
        //登录状态 token 值
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hasLogIn"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Token"];
        [alertView show];
        
        
        
        
        
    
    
    }
    else
    {
    
        self.view.userInteractionEnabled = YES;
    
    }
     //菊花停止
    [ac stop];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"请求失败 原因%@",request.error);
    self.view.userInteractionEnabled = YES;
}

#pragma mark -
#pragma  mark -notication
-(void)receiveShopString
{
    
}
#pragma mark --
#pragma mark 对键盘的操作
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(!iPhone5)
    {
        [UIView animateWithDuration:0.2 delay:0 options:0 animations:^{
            self.view.frame = CGRectMake(0, -216+110, 320, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(!iPhone5)
    {
        if (IOS_VERSION>=7.0) {
            [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
                self.view.frame = CGRectMake(0, 44+20, 320, self.view.frame.size.height);
            } completion:^(BOOL finished) {
                
            }];
            
        }
        else
        {
            [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
                self.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
            } completion:^(BOOL finished) {
                
            }];

        }
        
    }
    
   
}

-(IBAction)onClick:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    switch (btn.tag) {
        case 101:
        {
            OldAddressViewController * old = [[OldAddressViewController alloc] init];
            [old getAddress:(^(NSString *address)
                            {
                                addressText.text = address;
                            })];
            [self.navigationController pushViewController:old animated:YES];
        }
            break;
        case 102:
        {

            if([self checkTel:phoneField.text])
            {
                if(nameField.text.length !=0)
                {
                    if(addressText.text.length !=0)
                    {
                        self.view.userInteractionEnabled = NO;
                        ac = [[Activity alloc] initWithActivity:self.view];
                        [ac start];
                        NSMutableDictionary * alldataDic = [[NSMutableDictionary alloc] init];
                        
                        //lng
                        [alldataDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"lng"] forKey:@"Lng"];
                        
                        //lat
                        [alldataDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"lat"] forKey:@"Lat"];
                        
                        //UserId
                        [alldataDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"] forKey:@"UserId"];

                        //StoreId
                        [alldataDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"storeId"] forKey:@"StoreId"];
                        
                        //Address
                        [alldataDic setObject:addressText.text forKey:@"Address"];
                        
                        //OrderPrice 总价格
                        [alldataDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"OrderPrice"] forKey:@"OrderPrice"];
                        
                        
                        //GoodsCount 总个数
                        [alldataDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"GoodsCount"] forKey:@"GoodsCount"];
                        
                        //DescriptonType  判断是音频还是文字
                        [alldataDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"DescriptonType"] forKey:@"DescriptonType"];
                        
                        
                        //Descripton 文字，或者是音频文件
                        [alldataDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"Descripton"] forKey:@"Descripton"];
                        
                        //TelPhone 手机号
                        [alldataDic setObject:phoneField.text forKey:@"TelPhone"];
                        
                        //Contact 联系人昵称
                        [alldataDic setObject:nameField.text forKey:@"Contact"];
                        
                        //GoodsList 购买的所有商品
                        [alldataDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"GoodsList"] forKey:@"GoodsList"];
                        
                      
                        httpRequest * http =[[httpRequest alloc] init];
                        http.httpDelegate = self;
                        [http httpRequestSend:[NSString stringWithFormat:@"%@order/CreareOrder",SERVICE_ADD] parameter:[NSString stringWithFormat:@"StrJson=%@&Token=%@",[self DICTOJSON:alldataDic],[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"]] backBlock:(^(NSDictionary * dic){
                            
                            [ac stop];
                            if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
                            {
                                
                                [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"TelPhone"] forKey:@"shopPhone"];
                                
                                 [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"OrderNumber"] forKey:@"OrderNumber"];
                                
                                NSString* date;
                                NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
                                [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
                                date = [formatter stringFromDate:[NSDate date]];
                                
                                [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"orderDate"];
                                
                                if (![[NSUserDefaults standardUserDefaults] objectForKey:@"ReallyName"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"ReallyName"] isEqualToString:@""])
                                {
                                    [self changeAppel];
                                }
                                
//                                int count = [[[NSUserDefaults standardUserDefaults] objectForKey:@"allCount"] intValue];
//                                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",count +1] forKey:@"allCount"];
//                                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAllCount" object:nil];
//                                
//                                int count1 = [[[NSUserDefaults standardUserDefaults] objectForKey:@"newOrders"] intValue];
//                                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",count1 +1] forKey:@"newOrders"];
//                                [[NSNotificationCenter defaultCenter] postNotificationName:@"newOrderChangeCount" object:nil];
//
                                
                                OrderSuccessfulViewController * order = [[OrderSuccessfulViewController alloc] init];
                                btn.userInteractionEnabled = YES;
                                [self.navigationController pushViewController:order animated:YES];
    

                            }
                            else if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"88"])
                            {
                               self.view.userInteractionEnabled = YES;

                                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"警告" message:@"您的账号在别处登录,请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                                alertView.delegate=self;
                                alertView.tag=222;
                                //登录状态 token 值
                               
                                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hasLogIn"];
                                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Token"];
                                [alertView show];
                            }
                            else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"99"])
                            {
                                self.view.userInteractionEnabled = YES;
                                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器异常，请重试" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                [alert show];
                            }
                            else
                            {
                            
                                self.view.userInteractionEnabled = YES;
                            
                            }
                            
                            })];
                        
                        }
                    else
                    {
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写您的具体地址，方便商家给您送货到家" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];

                    }
                    
                }
                else
                {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写昵称，方便商家与您联系" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
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
    self.view.userInteractionEnabled = YES;
    [ac stop];
}
-(void)changeAppel
{

    httpRequest *http = [[httpRequest alloc] init];
    http.httpDelegate = self;
    [ac start];
    [http httpRequestSend:[NSString stringWithFormat:@"%@user/UpdateReallyName",SERVICE_ADD] parameter:[ NSString stringWithFormat:@"Id=%@&ReallyName=%@&Token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"],self.nameField.text,[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"]] backBlock:^(NSDictionary * dic) {
        
    
        if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
        {
            [ac stop];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.nameField.text forKey:@"ReallyName"];
            
           
            
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"99"])
        {
            [ac stop];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"系统异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"88"])
        {
            [ac stop];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您的账号在别处登录,请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hasLogIn"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Token"];
            
        }
        
    }];
    


}

-(void)viewWillAppear:(BOOL)animated
{
    [appDelegate hidenTabbar];

}
#pragma mark -
#pragma mark -UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0)
    {
        //跳转到登录界面
        MemberCenterViewController *memberVC=[[MemberCenterViewController alloc] init];
        UINavigationController *nav = [[NavViewController alloc] initWithRootViewController:memberVC];
        [memberVC getBackBlock:^(NSString * str) {
            
            NSArray *arr = [str componentsSeparatedByString:@","];
            self.phoneField.text = [arr objectAtIndex:0];
            self.nameField.text = [arr objectAtIndex:1];
            
            
        }];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isBack"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isBackToDelivery"];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }
    
    else
        return;
}


-(NSString * )DICTOJSON:(NSMutableDictionary*)muTableDic
{
    
    NSError *error = nil;
    NSString *jsonString;
    //序列化数据成json的data。。。。。。。。。。。。。。。。。。。。。。。
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:muTableDic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    
      if ([jsonData length] > 0 && error == nil){
        NSLog(@"已把字典成功序列化.");
        //把json数据转化为String类型
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        json=[jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        json =[json stringByReplacingOccurrencesOfString:@"%" withString:@"%25"];
        json =[json stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        json =[json stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    }
    
    return json;
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
