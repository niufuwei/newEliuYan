//
//  MyOrderDetailViewController.m
//  ELiuYan
//
//  Created by eliuyan_mac on 14-4-28.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "MyOrderDetailViewController.h"
#import "httpRequest.h"
#import "AppDelegate.h"
#import "DefineModel.h"
#import "OrderDetalCell.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "MemberCenterViewController.h"
#import "LoadingView.h"
#import "NavViewController.h"
static NSString *no_select_backImageName = @"back_no_select.png";
static NSString *selected_backImageName = @"back_selected.png";

@interface MyOrderDetailViewController ()<ASIHTTPRequestDelegate>
{

    ASINetworkQueue *_downLoadQueue;
}
@end

@implementation MyOrderDetailViewController

-(id)initWithOrderId:(NSString *)orderId
{
    self = [super init];
    if (self) {
        self.orderId = orderId;
    }
    
    return self;


}

-(void)getBackOrder:(void (^)(NSString *))backOrder{
    if(self)
    {
        _backOrder = backOrder;
    }
}
-(void)setRightItem
{

    //店铺详情
    Confirm=[UIButton buttonWithType:UIButtonTypeCustom];
    Confirm.frame=CGRectMake(320-80+3, 10, 60, 22);
    [Confirm setBackgroundImage:[UIImage imageNamed:@"确认收货.png"] forState:UIControlStateNormal];
    [Confirm setBackgroundColor:[UIColor blackColor]];
    [Confirm addTarget:self action:@selector(confirmationGoods:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:Confirm];
    Confirm.hidden = NO;

}
-(void) setLeftItem{
    
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
    
    [Confirm removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _myOrderDic = [[NSDictionary alloc] init];
    [self.orderView removeFromSuperview];
    NavCustom *nav=[[NavCustom alloc] init];
    [nav setNav:@"订单详情" mySelf:self];
    [self setLeftItem];
    
    self.detailsList = [[NSMutableArray alloc] initWithCapacity:1];
    
    aView=[[UIView alloc] initWithFrame:CGRectMake(0,0, 320, 269)];
    aView.backgroundColor=[UIColor clearColor];
    aView.userInteractionEnabled = YES;
    
    //初始化订单状态背景图
    UIImageView * backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)] ;
    backImage.image=[UIImage imageNamed:@"等待送货 下单完成背景.png"];
    [aView addSubview:backImage];

    
    //订单状态
    _label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 15)];
    _label2.font = [UIFont systemFontOfSize:15];
    _label2.backgroundColor=[UIColor clearColor];
    _label2.textColor = [UIColor whiteColor];
    [backImage addSubview:_label2];
    
    
    
    _label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, _label2.frame.origin.y +_label2.frame.size.height+10, 240, 15)];
    _label1.text = @"您可以直接通过电话给商户取消订单";
    _label1.textColor=[UIColor whiteColor];
    _label1.backgroundColor = [UIColor clearColor];
    //        alarmLabel.textAlignment = NSTextAlignmentCenter;
    _label1.font = [UIFont systemFontOfSize:13];
    [backImage addSubview:_label1];

    
    
//    _lineImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"线5.png"]];
//    _lineImageView.frame=CGRectMake(0, _label1.frame.origin.y + _label1.frame.size.height + 5, 320, 1);
//    [self.view addSubview:_lineImageView];
    
    //店铺名字
    _label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, 300, 15)];
    _label3.font = [UIFont systemFontOfSize:15];
    _label3.backgroundColor = [UIColor clearColor];
    //        ShopName.textColor = eliuyan_color(0x404040);
    [aView addSubview:_label3];
    
    
    //店铺描述
    descriptionShop = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 320, 15)];
    descriptionShop.font=[UIFont systemFontOfSize:13];
    descriptionShop.backgroundColor = [UIColor clearColor];
    [aView addSubview:descriptionShop];
    
    
    
    //电话
    _label4 = [[UILabel alloc ]initWithFrame:CGRectMake(10, _label3.frame.origin.y+_label3.frame.size.height+5+20, 100, 15)] ;
    _label4.font = [UIFont systemFontOfSize:13];
    _label4.backgroundColor =[UIColor clearColor];
    _label4.textColor = [UIColor grayColor];
    [aView addSubview:_label4];
    
    
    //电话拨号
        UIButton * callBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
        callBtn.frame  = CGRectMake(110, _label4.frame.origin.y-2, 80, 20);
        [callBtn setBackgroundImage:[UIImage imageNamed:@"电话拨号.png"] forState:UIControlStateNormal];
    //    //        [Contact setBackgroundImage:[UIImage imageNamed:@"电话拨号-按住.png"] forState:UIControlStateHighlighted];
    //    //        [Contact setTitleColor:eliuyan_color(0xff7e64) forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(callSeller:) forControlEvents:UIControlEventTouchUpInside];
        [aView addSubview:callBtn];

    
    //订单金额
    _label6= [[UILabel alloc ]initWithFrame:CGRectMake(10, _label4.frame.origin.y+_label4.frame.size.height+5, 300, 15)];
    _label6.font = [UIFont systemFontOfSize:13];
    _label6.backgroundColor = [UIColor clearColor];
    [aView addSubview:_label6];
    
    
    //订单时间
    _label7 = [[UILabel alloc ]initWithFrame:CGRectMake(10, _label6.frame.origin.y+_label6.frame.size.height+5, 300, 15)] ;
    _label7.font = [UIFont systemFontOfSize:13];
    _label7.backgroundColor = [UIColor clearColor];
    [aView addSubview:_label7];
    
    
    
    
    //付款方式
    _label8 = [[UILabel alloc ]initWithFrame:CGRectMake(10, _label7.frame.origin.y+_label7.frame.size.height+5, 300, 15)];
    _label8.text = @"付款方式 货到付款";
    _label8.font = [UIFont systemFontOfSize:13];
    _label8.backgroundColor = [UIColor clearColor];
    [aView addSubview:_label8];

    //订单编号
    _label5 = [[UILabel alloc ]initWithFrame:CGRectMake(10, _label8.frame.origin.y+_label8.frame.size.height+5, 300, 15)];
    _label5.font = [UIFont systemFontOfSize:13];
    _label5.backgroundColor = [UIColor clearColor];
    [aView addSubview:_label5];

    
//    _lineImageView1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"线5.png"]];
//    _lineImageView1.frame=CGRectMake(0, _label8.frame.origin.y + _label8.frame.size.height + 5, 320, 1);
//    [self.view addSubview:_lineImageView1];
    //添加背景图片
    UIImageView *aBackImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, _label5.frame.origin.y+_label5.frame.size.height+5, 320, 60)];
    aBackImage.image=[UIImage imageNamed:@"订单详情、最近订单-备注信息背景.png"];
    [aView addSubview:aBackImage];

    //备注信息
    _descriptionLabel = [[UILabel alloc ]initWithFrame:CGRectMake(10, _label5.frame.origin.y+_label5.frame.size.height-5,300, 60)] ;
    _descriptionLabel.font = [UIFont systemFontOfSize:13];
    [_descriptionLabel setNumberOfLines:0];
    _descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _descriptionLabel.text = @"备注信息 ";
    _descriptionLabel.backgroundColor = [UIColor clearColor];
    _descriptionLabel.userInteractionEnabled = YES;
    [aView addSubview:_descriptionLabel];

     [self.view addSubview:aView];
    
//    UIImageView * _lineImageView2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"线5.png"]];
//    _lineImageView2.frame=CGRectMake(0, _descriptionLabel.frame.origin.y + _descriptionLabel.frame.size.height + 5, 320, 1);
//    [self.view addSubview:_lineImageView2];

    
    
    _label9 = [[UILabel alloc] initWithFrame:CGRectMake(10, _descriptionLabel.frame.origin.y + _descriptionLabel.frame.size.height + 10, 80, 20)];
    _label9.text = @"购买商品";
    _label9.font = [UIFont systemFontOfSize:14.0];
    _label9.backgroundColor = [UIColor clearColor];

    [self.view addSubview:_label9];
    
    
    UIImageView * lineImageView1=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"线4.png"]];
    lineImageView1.frame=CGRectMake(0, _label9.frame.origin.y + _label9.frame.size.height + 5, 320, 1);
    [self.view addSubview:lineImageView1];
    
    _label10 = [[UILabel alloc] initWithFrame:CGRectMake(260, _descriptionLabel.frame.origin.y + _descriptionLabel.frame.size.height + 10, 80, 20)];
    _label10.text = @"共  件";
    _label10.textColor = [UIColor grayColor];
    _label10.font = [UIFont systemFontOfSize:15.0];
    _label10.backgroundColor = [UIColor clearColor];

    [self.view addSubview:_label10];
    
    {
        
        if (IOS_VERSION < 7.0) {
            _goodsListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, lineImageView1.frame.origin.y + lineImageView1.frame.size.height + 5, 320, self.view.frame.size.height - (lineImageView1.frame.origin.y + lineImageView1.frame.size.height + 5) - 44)];
            
        }
        else
        {
            
            _goodsListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, lineImageView1.frame.origin.y + lineImageView1.frame.size.height + 5, 320, self.view.frame.size.height - (lineImageView1.frame.origin.y + lineImageView1.frame.size.height + 5) - 64)];
            
            
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            _goodsListTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }

        _goodsListTableView.delegate = self;
        _goodsListTableView.dataSource = self;
        _goodsListTableView.allowsSelection = NO;
        _goodsListTableView.backgroundColor=eliuyan_color(0xf5f5f5);
        [self.view addSubview:_goodsListTableView];
 
    }
   

    
//    //添加下面的结账View
//    UIView *buttomView = [[UIView alloc] init];
//    if (IOS_VERSION < 7.0)
//    {
//        [buttomView setFrame:CGRectMake(0, self.view.frame.size.height - 49 - 44, 320, 49)];
//
//    }
//    else
//    {
//        [buttomView setFrame:CGRectMake(0, self.view.frame.size.height - 49 - 64, 320, 49)];
//
//
//    }
//    NSLog(@"buttom view is %f",self.view.frame.size.height);
//    
//    
//    
//    //分割线
//    UIImageView *lineImageView3=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"线4.png"]];
//    lineImageView3.frame=CGRectMake(0,0, 320, 1);
//    NSLog(@"lineimageView is %@",lineImageView3);
//    [buttomView addSubview:lineImageView3];
//    
//
//    //15, 0, 40, 38
//    UIButton *callSeller = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 40, 38)];
//    [callSeller setBackgroundImage:[UIImage imageNamed:@"Contact_no_select.png"] forState:UIControlStateNormal];
//    [callSeller addTarget:self action:@selector(callSeller:) forControlEvents:UIControlEventTouchUpInside];
//    [buttomView addSubview:callSeller];
//    
//    
//    _label11 = [[UILabel alloc] initWithFrame:CGRectMake(130, 10, 100, 30)];
//    _label11.text = @"   元";
//    _label11.textColor = [UIColor redColor];
//    _label11.backgroundColor = [UIColor clearColor];
//
//    [buttomView addSubview:_label11];
//    
//    
//    UIButton *confirmationBtn = [[UIButton alloc] initWithFrame:CGRectMake(240, 7.5, 70, 35)];
//    confirmationBtn.tag = 2500;
//    [confirmationBtn setTitle:@"确认收货"  forState:UIControlStateNormal];
//    [confirmationBtn setBackgroundColor:[UIColor redColor]];
//    confirmationBtn.hidden = NO;
//    confirmationBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
//    [confirmationBtn addTarget:self action:@selector(confirmationGoods:) forControlEvents:UIControlEventTouchUpInside];
//    [buttomView addSubview:confirmationBtn];
//    
//    
//    [self.view addSubview:buttomView];


    
    _activity = [[Activity alloc] initWithActivity:self.view];
    [self loadUI];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogIn"] isEqualToString:@""])
    {
        [Confirm removeFromSuperview];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(void)loadUI
{

    [_activity start];
    
    
    self.view.userInteractionEnabled = NO;
//    NSLog(@">>>>>%@",self.orderId);
    
    httpRequest *http = [[httpRequest alloc] init];
    [http httpRequestSend:[NSString stringWithFormat:@"%@order/MyOdersDetails",SERVICE_ADD] parameter:[NSString stringWithFormat:@"OrderId=%@&Token=%@",self.orderId,[appDelegate.appDefault objectForKey:@"Token"]] backBlock:^(NSDictionary * dic) {
        
        
        if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
        {
            
//            NSLog(@">>>>%@",dic);
            self.myOrderDic = [dic objectForKey:@"List"] ;
            NSLog(@"订单详情是%@",self.myOrderDic);
            
            self.storeName = [self.myOrderDic objectForKey:@"StoreName"];
            
            descriptionShop.text = [NSString stringWithFormat:@"(%@)",[self.myOrderDic objectForKey:@"StoreDescripton"]];
            
            self.telNumber = [self.myOrderDic objectForKey:@"TelNumber"];
            self.storeId = [self.myOrderDic objectForKey:@"Id"];
            self.status = [NSString stringWithFormat:@"%@",[self.myOrderDic objectForKey:@"Status"]];
            self.orderNumber = [self.myOrderDic objectForKey:@"OrderNumber"];
            self.orderPrice = [self.myOrderDic objectForKey:@"OrderPrice"];
            self.createTime = [self.myOrderDic objectForKey:@"CreateTime"];
            self.descriptionType = [NSString stringWithFormat:@"%@",[self.myOrderDic objectForKey:@"DescriptonType"]];
            self.description =[self.myOrderDic objectForKey:@"Descripton"];
            self.detailsList = [self.myOrderDic objectForKey:@"DetailsList"];
              [self changeValue];
            
            if ([self.detailsList count] == 0) {
                [self.goodsListTableView removeFromSuperview];
            }
            else
            {
              
                [self.goodsListTableView reloadData];
                
            }
            
            
            [_activity stop];
            self.view.userInteractionEnabled = YES;

            
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"99"])
        {
            [_activity stop];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"系统异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            self.view.userInteractionEnabled = YES;

        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"88"])
        {
            [_activity stop];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您的账号在别处登录,请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
            alert.tag = 2;
            alert.delegate = self;
            [alert show];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hasLogIn"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Token"];
            self.view.userInteractionEnabled = YES;

        }
    }];
    


}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 2 || alertView.tag == 3)
    {
        if (buttonIndex == 0)
        {
            MemberCenterViewController *memCenter = [[MemberCenterViewController alloc] init];
            UINavigationController *nav = [[NavViewController alloc] initWithRootViewController:memCenter];
            [self presentViewController:nav animated:YES completion:^{
                
            }];
        }
        else
        {
            [Confirm removeFromSuperview];
            [self.navigationController popToRootViewControllerAnimated:YES];
        
        }
    }
    else if(alertView.tag == 333)
    
    {
        if(buttonIndex==0)
        {
            
            [self configure];

        }
        
    }
    
    
}
-(void)changeValue
{
    
    if ([self.status isEqualToString:@"1"])
    {
        _label2.text = @"等待送货";
        _label1.text = @"如需取消，请联系卖家";
//        [_lineImageView setImage:[UIImage imageNamed:@"线4.png"]];
        [self.view viewWithTag:2500].hidden = YES;

    }
    else if([self.status isEqualToString:@"2"])
    {
    
        _label2.text = @"送货中...";
        _label1.text = @"送货中,请耐心等待";
//        [_lineImageView setImage:[UIImage imageNamed:@"线4.png"]];
        
        [self setRightItem];
    
    }
    else if([self.status isEqualToString:@"3"])
    {
    
    
        _label2.text = @"送货中";
        _label1.text = @"送货中,请耐心等待";

//        [_lineImageView setImage:[UIImage imageNamed:@"线4.png"]];
        
        [self setRightItem];
    }
    else if([self.status isEqualToString:@"4"])
    {

        
        _label2.text = @"订单完成";
        _label2.textColor = [UIColor grayColor];
        _label1.textColor = [UIColor grayColor];
        _label1.text = @"订单已完成";
//        [_lineImageView setImage:[UIImage imageNamed:@"线5.png"]];
        [self.view viewWithTag:2500].hidden = YES;

        

    }
    else if([self.status isEqualToString:@"5"])
    {
        _label2.text = @"订单取消";
        _label1.text = [NSString stringWithFormat:@"%@",[self.myOrderDic objectForKey:@"OrderReason"]];
        _label2.textColor = [UIColor grayColor];
        _label1.textColor = [UIColor grayColor];
        [_lineImageView setImage:[UIImage imageNamed:@"线5.png"]];
        [self.view viewWithTag:2500].hidden = YES;
        
    }
    

    _label3.text = [NSString stringWithFormat:@"%@",self.storeName];
    _label4.text = [NSString stringWithFormat:@"%@",self.telNumber];
    _label5.text = [NSString stringWithFormat:@"订单编号  %@",self.orderNumber];
    _label6.text = [NSString stringWithFormat:@"订单金额  %@元",self.orderPrice];
    _label11.text =[NSString stringWithFormat:@"共%@元",_orderPrice];
    _label7.text = [NSString stringWithFormat:@"下单时间  %@", [self.createTime stringByReplacingOccurrencesOfString:@"T" withString:@" "]];
    //这里还有备注信息
   
    
    if ([self.detailsList count] > 0)
    {
        
        for (int i = 0; i < [self.detailsList count]; i++)
        {
            _totalGoods += [[[self.detailsList objectAtIndex:i] objectForKey:@"GoodsCount"] intValue];
        }
        _label10.text = [NSString stringWithFormat:@"共%d件",_totalGoods];
    }
    else
    {
    
        _label10.text = @"共0件";
        
        LoadingView *loadView;
        if (IOS_VERSION>=7.0)
        {
            loadView=[[LoadingView alloc] initWithFrame:CGRectMake(0,170, 320, self.view.frame.size.height-49-180-44)];
        }
        else
        {
            loadView=[[LoadingView alloc] initWithFrame:CGRectMake(0,170, 320, self.view.frame.size.height-49-180-44+20)];
        }
        [loadView changeLabel:@"您的商品已被商家删除"];
        [self.view addSubview:loadView];
    
    
    }
    
    
    
    
    
    if ([self.descriptionType isEqualToString:@"1"])
    {
        //[_descriptionLabel setFrame:CGRectMake(10, 133, 300, 13)];
        if ([self.description length] == 0)
        {
            _descriptionLabel.text = [NSString stringWithFormat:@"备注信息   无"];
        } else {
            _descriptionLabel.numberOfLines = 3;
            _descriptionLabel.text = [NSString stringWithFormat:@"备注信息   %@",self.description ];
        }
        
        NSLog(@"%@",self.description);
    }
    else if([self.descriptionType isEqualToString:@"2"])
    {
         //语音播放按钮
        UIButton *voiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(90, _label5.frame.origin.y+_label5.frame.size.height+15, 50, 20)];
        
        [voiceBtn setBackgroundImage:[UIImage imageNamed:@"留言.png"] forState:UIControlStateNormal];
        [voiceBtn addTarget:self action:@selector(playVoice:) forControlEvents:UIControlEventTouchUpInside];
        [aView addSubview:voiceBtn];
        
       
        
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 9, 30, 15)];
        timeLabel.text = @"1'";
        timeLabel.tag = 11;
        timeLabel.textColor = [UIColor redColor];
        timeLabel.backgroundColor = [UIColor clearColor];
        [voiceBtn addSubview:timeLabel];
        timeLabel.hidden = YES;
    
        
        NSLog(@"description is %@",self.description);
        
        [self downLoadVoice];
    }
    
//    if ([[[[self.detailsList objectAtIndex:0] objectForKey:@"BuyType"] stringValue] isEqualToString:@"0"])
//    {
//       
//    }
//    else
//    {
//       
//    }

    
}
#pragma mark -- 下载音频文件
-(void)downLoadVoice
{
    [_activity start];
    
    
    
    
    //初始化Documents路径
    NSString *path =[ NSSearchPathForDirectoriesInDomains ( NSDocumentDirectory , NSUserDomainMask , YES ) objectAtIndex:0];
    
 
    
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断temp文件夹是否存在
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    if (!fileExists)
    {//如果不存在说创建,因为下载时,不会自动创建文件夹
        [fileManager createDirectoryAtPath:path
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    

    NSString *filePath =[NSString stringWithFormat:@"%@%@",DOWNLOAD_FILE,self.description] ;
    //初始化下载路径
    NSURL *url = [NSURL URLWithString:filePath];
    //设置下载路径
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    //设置ASIHttpRequest代理
    request.delegate = self;
    //初始化保存文件的路径
    _savePath = [path stringByAppendingPathComponent:self.description];
    if (![fileManager fileExistsAtPath:_savePath])
    {
        
        [fileManager createDirectoryAtPath:_savePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //设置文件保存路径
    [request setDownloadDestinationPath:_savePath];
    
        
    [request startSynchronous];
    
    

}
#pragma mark 下载音频
#pragma mark -- download delegate

- (void)requestFailed:(ASIHTTPRequest *)request
{

    NSLog(@"request did failed");



}

- (void)requestStarted:(ASIHTTPRequest *)request
{


    NSLog(@"requset did started");



}
-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{

    NSLog(@"asihttprequest did recive response");


}
-(void)requestFinished:(ASIHTTPRequest *)request
{

    
    [_activity stop];
    
    
    
    
    
    
    
    NSURL *fileUrl = [NSURL URLWithString:_savePath];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
    [self.player prepareToPlay];
    [self.player setDelegate:self];
    //self.player.numberOfLoops = 1;
    
    

}
//播放音频
-(void)playVoice:(UIButton *)btn
{
    
    
    if([self.player isPlaying])
    {
        [self.player pause];
        
    }
    else
    {
        
        [self.player play];
        

    }
    
    
}


#pragma mark --播放音频代理

//程序中断时，暂停播放

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    
    [player pause];
    
}

//程序中断结束返回程序时，继续播放

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    
    [player play];
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{

    //[_minTimer invalidate];
    [(UILabel*)[self.view viewWithTag:11] setText:@"1'"];
    ((UILabel*)[self.view viewWithTag:11]).hidden = YES;


}
//打电话
-(void)callSeller:(UIButton *)btn
{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.telNumber]]];

    NSLog(@"打电话");
    UIWebView *callWebView = [[UIWebView alloc] init];
    NSURL *telUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.telNumber]];
    [callWebView loadRequest:[NSURLRequest requestWithURL:telUrl]];
    [self.view addSubview:callWebView];


}

-(void)configure
{

    
    [_activity start];
    
    self.view.userInteractionEnabled = NO;

    
    
    
    httpRequest *http = [[httpRequest alloc] init];
    http.httpDelegate = self;
    [http httpRequestSend:[NSString stringWithFormat:@"%@order/GainGoods",SERVICE_ADD] parameter:[NSString stringWithFormat:@"Id=%@&Token=%@",self.orderId,[appDelegate.appDefault objectForKey:@"Token"]] backBlock:^(NSDictionary * dic) {
        
        
        if ([[dic objectForKey:@"ReturnValues"] isEqualToString:@"0"])
        {
            NSLog(@"修改成功");
            [_activity stop];
            
            _backOrder(@"1");
            
            {
            
                _label1.text = @"订单已完成";
                _label1.textColor = [UIColor grayColor];
                _label2.textColor = [UIColor grayColor];
                _label2.text = @"订单完成";
                _lineImageView.image = [UIImage imageNamed:@"线5.png"];
                [self.view viewWithTag:2500].hidden = YES;
                self.view.userInteractionEnabled = YES;
                [Confirm removeFromSuperview];

            
            }
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"99"])
        {
            
            [_activity stop];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"系统异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            self.view.userInteractionEnabled = YES;

            
        }
        else if([[dic objectForKey:@"ReturnValues"] isEqualToString:@"88"])
        {
            [_activity stop];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您的账号在别处登录,请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.tag = 3;
            alert.delegate = self;
            [alert show];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"hasLogIn"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Token"];
            self.view.userInteractionEnabled = YES;

        }
    }];
}

-(void)httpRequestError:(NSString *)str
{
    self.view.userInteractionEnabled = YES;
    [_activity stop];
    
}

//确认订单
-(void)confirmationGoods:(UIButton *)btn
{
    
    
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"要确认订单吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert1.tag = 333;
    [alert1 show];
    
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSLog(@"tableviewcell de fang fa diao yong1");

    
    return [self.detailsList count];
    

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 65.0;


}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"tableviewcell de fang fa diao yong");

    
    
    static NSString *identifier = @"identifier";
    OrderDetalCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[OrderDetalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = eliuyan_color(0xf5f5f5);

    }
    
    
    
    
    if ([self.detailsList count] == 0)
    {
        
    }
    else
    {
    
    [cell.goodsImage setImageWithURL:[NSURL URLWithString:[[self.detailsList objectAtIndex:indexPath.row] objectForKey:@"Image"]] placeholderImage:[UIImage imageNamed:@"暂无.png"]];
    
  
    
    cell.description.text = [[self.detailsList objectAtIndex:indexPath.row] objectForKey:@"GoodsName"];
    

    
    cell.moneyLabel.text =[NSString stringWithFormat:@"￥:%@",[[self.detailsList objectAtIndex:indexPath.row] objectForKey:@"Price"]];
    
    
    if ([[[self.detailsList objectAtIndex:indexPath.row] objectForKey:@"BuyType"] intValue] == 0)
    {
         cell.countLabel.text =[NSString stringWithFormat:@"%@ 件",[[self.detailsList objectAtIndex:indexPath.row] objectForKey:@"GoodsCount"] ];
    }
    else if([[[self.detailsList objectAtIndex:indexPath.row] objectForKey:@"BuyType"] intValue] == 1)
    {
         cell.countLabel.text =[NSString stringWithFormat:@"%@ 斤",[[self.detailsList objectAtIndex:indexPath.row] objectForKey:@"GoodsCount"] ];
    }
    else
    {
    cell.countLabel.text =[NSString stringWithFormat:@"%@ 个",[[self.detailsList objectAtIndex:indexPath.row] objectForKey:@"GoodsCount"] ];
    
    }
   
        
    }
    return cell;


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
