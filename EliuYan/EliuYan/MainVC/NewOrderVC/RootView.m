//
//  RootView.m
//  ELiuYan
//
//  Created by apple on 14-4-27.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "RootView.h"
#import "httpRequest.h"
#import "BuyGoods.h"
#import "MainViewController.h"
#import "LoadingView.h"



@implementation RootView
{
    NSString * avadioURL;
    Activity * activity;
    NSString * _savePath;
     UIView *bottomView;
}
@synthesize table;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        ///////////////////////////////   //上面的界面////////////////////////////
        //默认没有播放音频
        //        isPlay = false;
        
        
        self.userInteractionEnabled = YES;
        
        UIView *aView=[[UIView alloc] initWithFrame:CGRectMake(0,0, 320, 269)];
        aView.backgroundColor=[UIColor clearColor];
        aView.userInteractionEnabled = YES;
        
        
        
        
//        //初始化分割线
//        UIImageView * Cut_Off_Line = [[UIImageView alloc] initWithFrame:CGRectMake(0, prompt.frame.origin.y+prompt.frame.size.height+5, 320, 1)] ;
//        [Cut_Off_Line setBackgroundColor:eliuyan_color(0xff7e64)];
//        [aView addSubview:Cut_Off_Line];
        //初始化订单状态背景图
        UIImageView * backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)] ;
        backImage.image=[UIImage imageNamed:@"等待送货 下单完成背景.png"];
        [aView addSubview:backImage];
        
        
        //提示文字的初始化
        prompt = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 15)] ;
        prompt.font=[UIFont systemFontOfSize:13];
        prompt.backgroundColor = [UIColor clearColor];
        [backImage addSubview:prompt];
        
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 15)];
        _statusLabel.font = [UIFont systemFontOfSize:15];
        _statusLabel.backgroundColor=[UIColor clearColor];
        _statusLabel.textColor = [UIColor whiteColor];
        [backImage addSubview:_statusLabel];
        
        alarmLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _statusLabel.frame.origin.y +_statusLabel.frame.size.height+10, 240, 15)];
        alarmLabel.text = @"您可以直接通过电话给商户取消订单";
        alarmLabel.textColor=[UIColor whiteColor];
        alarmLabel.backgroundColor = [UIColor clearColor];
//        alarmLabel.textAlignment = NSTextAlignmentCenter;
        alarmLabel.font = [UIFont systemFontOfSize:13];
        [backImage addSubview:alarmLabel];
        
        
//        //初始化分割线
//        UIImageView * Cut_Off_Line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, alarmLabel.frame.origin.y+alarmLabel.frame.size.height+5, 320, 1)] ;
//        [Cut_Off_Line1 setBackgroundColor:eliuyan_color(0xff7e64)];
//        [aView addSubview:Cut_Off_Line1];
        
        
        //店铺名字
        ShopName = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 300, 15)];
        ShopName.font = [UIFont systemFontOfSize:15];
        ShopName.backgroundColor = [UIColor clearColor];
//        ShopName.textColor = eliuyan_color(0x404040);
        [aView addSubview:ShopName];
        
        //店铺描述
        descriptionShop = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 320, 15)];
        descriptionShop.font=[UIFont systemFontOfSize:13];
        descriptionShop.backgroundColor = [UIColor clearColor];
        [aView addSubview:descriptionShop];
        
        
        
        
        //电话
        phoneNumber = [[UILabel alloc ]initWithFrame:CGRectMake(10, ShopName.frame.origin.y+ShopName.frame.size.height+5+20, 100, 15)] ;
        phoneNumber.font = [UIFont systemFontOfSize:13];
        phoneNumber.backgroundColor =[UIColor clearColor];
        phoneNumber.textColor = [UIColor grayColor];
        [aView addSubview:phoneNumber];
        
        
        UIButton * Contact = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
        Contact.frame  = CGRectMake(110, phoneNumber.frame.origin.y-2, 80, 20);
        [Contact setBackgroundImage:[UIImage imageNamed:@"电话拨号.png"] forState:UIControlStateNormal];
        //        [Contact setBackgroundImage:[UIImage imageNamed:@"电话拨号-按住.png"] forState:UIControlStateHighlighted];
        //        [Contact setTitleColor:eliuyan_color(0xff7e64) forState:UIControlStateNormal];
        [Contact addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
        [aView addSubview:Contact];
        
        //订单金额
        OrderMoney = [[UILabel alloc ]initWithFrame:CGRectMake(10, phoneNumber.frame.origin.y+phoneNumber.frame.size.height+5, 300, 15)];
        OrderMoney.font = [UIFont systemFontOfSize:13];
        OrderMoney.backgroundColor = [UIColor clearColor];
        [aView addSubview:OrderMoney];
        
        
        //订单时间
        OrderTime = [[UILabel alloc ]initWithFrame:CGRectMake(10, OrderMoney.frame.origin.y+OrderMoney.frame.size.height+5, 300, 15)] ;
        OrderTime.font = [UIFont systemFontOfSize:13];
        OrderTime.backgroundColor = [UIColor clearColor];
        [aView addSubview:OrderTime];
        
        
        
        //付款方式
        payWay = [[UILabel alloc ]initWithFrame:CGRectMake(10, OrderTime.frame.origin.y+OrderTime.frame.size.height+5, 300, 15)];
        payWay.font = [UIFont systemFontOfSize:13];
        payWay.backgroundColor = [UIColor clearColor];
        [aView addSubview:payWay];
        
        
        //订单编号
        OrderNumber = [[UILabel alloc ]initWithFrame:CGRectMake(10, payWay.frame.origin.y+payWay.frame.size.height+5, 300, 15)];
        OrderNumber.font = [UIFont systemFontOfSize:13];
        OrderNumber.backgroundColor = [UIColor clearColor];
        [aView addSubview:OrderNumber];
        
        
        
//        //初始化分割线
//        UIImageView * Cut_Off_Line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, OrderNumber.frame.origin.y+OrderNumber.frame.size.height+5, 320, 1)] ;
//        Cut_Off_Line2.userInteractionEnabled = YES;
//        [Cut_Off_Line2 setBackgroundColor:eliuyan_color(0xff7e64)];
//        [aView addSubview:Cut_Off_Line2];
        //添加背景图片
        UIImageView *aBackImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, OrderNumber.frame.origin.y+OrderNumber.frame.size.height+5, 320, 60)];
        aBackImage.image=[UIImage imageNamed:@"订单详情、最近订单-备注信息背景.png"];
        [aView addSubview:aBackImage];
        
        
        //备注信息
        Remarks = [[UILabel alloc ]initWithFrame:CGRectMake(10, OrderNumber.frame.origin.y+OrderNumber.frame.size.height-5,300, 60)] ;
        Remarks.font = [UIFont systemFontOfSize:13];
        [Remarks setNumberOfLines:0];
        Remarks.lineBreakMode = NSLineBreakByWordWrapping;

        Remarks.backgroundColor = [UIColor clearColor];
        Remarks.userInteractionEnabled = YES;
        [aView addSubview:Remarks];
        
        
//        //初始化分割线
//        UIImageView * Cut_Off_Line3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, Remarks.frame.origin.y+Remarks.frame.size.height+5, 320, 1)] ;
//        Cut_Off_Line3.userInteractionEnabled = YES;
//        [Cut_Off_Line3 setBackgroundColor:eliuyan_color(0xff7e64)];
//        [aView addSubview:Cut_Off_Line3];
        
        
        //语音播放按钮
        _VoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        _VoiceBtn.frame = CGRectMake(90, OrderNumber.frame.origin.y+OrderNumber.frame.size.height+15, 50, 20);
        [_VoiceBtn setBackgroundImage:[UIImage imageNamed:@"留言.png"] forState:UIControlStateNormal];
        [_VoiceBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
        [_VoiceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [aView addSubview:_VoiceBtn];
        [_VoiceBtn setHidden:YES];
        [self addSubview:aView];
        
        

        
        ///////////////////////////////   //添加表////////////////////////////
        
        if (IOS_VERSION>=7.0)
        {
             _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,255, 320, self.frame.size.height-255 ) style:UITableViewStylePlain];
        }
        else
        {
            
            NSLog(@"self view is %f",self.frame.size.height);
             _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,255, 320, self.frame.size.height-255) style:UITableViewStylePlain];
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
    }
    
    for (UIView *view in self.subviews)
    {
        NSLog(@"view is %@",view);
        view.userInteractionEnabled = YES;
    }

    return self;
}
- (void)addFooter
{
    __unsafe_unretained RootView *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = table;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        pageIndex++;
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:0.0];
        
    };
    _footer = footer;
    
}
- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [table reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

- (void) sendRequest:(NSDictionary *) allDic orderIdArray:(NSArray *)array{
    
//    if(![currentPage isEqualToString:@"0"])
//    {
//        
//        
//        CGRect hh = _tableView.frame;
//        hh.size.height =self.frame.size.height-255 - 64;
//        _tableView.frame = hh;
//        
//
//    }
    
    //初始化数组
    _goodsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSLog(@"=======>%@",allDic);
    NSLog(@"++++++%@",array);
    
    //        //解析数据
    NSMutableDictionary *arrayDetail=[allDic objectForKey:@"List"];
    totalPage=[allDic objectForKey:@"TotalPage"];

    NSLog(@">>>>>%@",arrayDetail);
    
    if (arrayDetail==nil) {
        [_tableView removeFromSuperview];
        
        LoadingView *loadView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height)];
        [loadView changeLabel:@"此订单已被商家处理，请到我的订单中查看"];
        [self addSubview:loadView];
    }
    else
    {
            //外面的字段
            
            NSString *storeName=[arrayDetail objectForKey:@"StoreName"];
            ShopName.text=[NSString stringWithFormat:@"%@",storeName];
        
            descriptionShop.text = [NSString stringWithFormat:@"(%@)",[arrayDetail objectForKey:@"StoreDescripton"]];
        
            telNum=[arrayDetail objectForKey:@"TelNumber"];
            phoneNumber.text = [NSString stringWithFormat:@"%@",telNum];
            
            NSString *orderList=[arrayDetail objectForKey:@"OrderNumber"];
             OrderNumber.text = [NSString stringWithFormat:@"订单编号  %@",orderList];
            
            orderPrice=[arrayDetail objectForKey:@"OrderPrice"];
            OrderMoney.text = [NSString stringWithFormat:@"订单金额  %@元",orderPrice];
            //底部的总价格
            MoneyLabel.text=[NSString stringWithFormat:@"%@元",orderPrice];
            
            
            payWay.text = [NSString stringWithFormat:@"付款方式  货到付款"];
            NSString *orderId=[arrayDetail objectForKey:@"Id"];
            self.oredrId=orderId;
            NSLog(@"++++++%@",self.oredrId);
            
            NSString *Time=[arrayDetail objectForKey:@"CreateTime"];
            
            Time =[Time stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            OrderTime.text = [NSString stringWithFormat:@"下单时间  %@",Time];
            
//            NSString *oredrReason=[arrayDetail objectForKey:@"OrderReason"];
        
            int status=[[arrayDetail objectForKey:@"Status" ] intValue];
            
//            prompt.textColor = eliuyan_color(0xff5d51);
//            prompt.text = [NSString stringWithFormat:@"未完结订单 %d/%@ (滑动切换订单)",[currentPage intValue] + 1,totalPage];
        
            if (status ==1)
            {//等待送货
                
                _statusLabel.text = @"等待送货";
//                statusLabel.textColor = eliuyan_color(0xff5d51);
                //确认收货按钮隐藏
                Confirm.hidden=YES;
                
            }
            else if (status==2||status==3)
            {
                
                _statusLabel.text = @"送货中";
//                statusLabel.textColor = eliuyan_color(0xff5d51);
                Confirm=[UIButton buttonWithType:UIButtonTypeCustom];
                Confirm.frame=CGRectMake(320-80+3, 10, 60, 22);
                [Confirm setBackgroundImage:[UIImage imageNamed:@"确认收货.png"] forState:UIControlStateNormal];
                //确认收货按钮可以点击
//                [Confirm setTitle:@"确认收货" forState:UIControlStateNormal];
//                Confirm .titleLabel.font=[UIFont systemFontOfSize:15];
//                [Confirm setBackgroundColor:[UIColor redColor]];
                [Confirm addTarget:self action:@selector(sureCount:) forControlEvents:UIControlEventTouchUpInside];
                Confirm.hidden=NO;
            }
            else
            {
                _statusLabel.text = @"订单取消";
//                statusLabel.textColor = eliuyan_color(0xff5d51);
                
                
               
            }
            
            int descriptonType=[[arrayDetail objectForKey:@"DescriptonType" ] intValue];
            NSString *descripton=[arrayDetail objectForKey:@"Descripton"];
            NSLog(@",,,,,,,,,,,,,,,%@",descripton);
            if (descriptonType==1)
            {   //文字信息
                _VoiceBtn.hidden=YES;//隐藏语音按钮
                Remarks.text = [NSString stringWithFormat:@"备注信息   %@",descripton];
                Remarks.numberOfLines = 3;
                CGRect mywidth = Remarks.frame;
                mywidth.size.width = 300;
                Remarks.frame = mywidth;
                
            }
            else
            {   //语音
                Remarks.text = @"备注信息   ";
                _VoiceBtn.hidden = NO;
                avadioURL = descripton;
                
                //去下载音频
                [self downLoadVoice];
                
            }
            //里面的字段
            NSArray *detailArray=[arrayDetail objectForKey:@"DetailsList"];
            if (detailArray.count==0) {
                [_tableView removeFromSuperview];
                LoadingView *loadView;
                if (IOS_VERSION>=7.0) {
                    loadView=[[LoadingView alloc] initWithFrame:CGRectMake(0,170, 320, self.frame.size.height-49-180-44)];
                }
                else
                {
                    loadView=[[LoadingView alloc] initWithFrame:CGRectMake(0,170, 320, self.frame.size.height-49-180-44+20)];
                }
                [loadView changeLabel:@"您的商品已被商家删除"];
                [self addSubview:loadView];
            }
            else
            {
                for (int i=0; i<detailArray.count; i++) {
                    NSDictionary *detailDict=[detailArray objectAtIndex:i];
                    BuyGoods *buyGood=[[BuyGoods alloc] init];
                    buyGood.goodsCount=[NSString stringWithFormat:@"%@",[detailDict objectForKey:@"GoodsCount"]];
                    buyGood.goodsName=[detailDict objectForKey:@"GoodsName"];
                    buyGood.goodsId=[detailDict objectForKey:@"Id"];
                    buyGood.goodsImage=[detailDict objectForKey:@"Image"];
                    buyGood.goodsPrice=[detailDict objectForKey:@"Price"];
                    buyGood.buyType=[detailDict objectForKey:@"BuyType"];
                    
                    if ([buyGood.buyType intValue]==0) {
                        OrderMoney.text = [NSString stringWithFormat:@"订单金额  %@元",orderPrice];
                        //底部的总价格
                        MoneyLabel.text=[NSString stringWithFormat:@"%@元",orderPrice];
                    }
                    else
                    {
                        OrderMoney.text = @"订单金额   ——";
                        //底部的总价格
                        MoneyLabel.text=@"——";
                    }
                    
                    [_goodsArray addObject:buyGood];
                    
                    totalCount=totalCount+[buyGood.goodsCount intValue];
                }
                //刷新表
                [_tableView reloadData];
                
            }
        

    }
    
    
    
    
}


#pragma mark --
#pragma tabledelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"............%d",_goodsArray.count);
    if (_goodsArray.count==0) {
        return 10;
    }
    else
    {
        return _goodsArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strID = @"cellID";
    NewListCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if(cell == nil)
    {
        cell = [[NewListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
        
    }
    cell.backgroundColor=eliuyan_color(0xf5f5f5);
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (_goodsArray==nil) {
        return cell;
    }
    else
    {
        BuyGoods *buyGoods=[_goodsArray objectAtIndex:indexPath.row];
        cell.title.text=buyGoods.goodsName;
        if ([buyGoods.buyType intValue]==0 ) {
            cell.num.text=[NSString stringWithFormat:@"%@件",buyGoods.goodsCount];
        }
        else if ([buyGoods.buyType intValue]==1)
        {
            cell.num.text=[NSString stringWithFormat:@"%@斤",buyGoods.goodsCount];
        }
        else
        {
            cell.num.text=[NSString stringWithFormat:@"%@个",buyGoods.goodsCount];
        }
        
        [cell.ICON setImageWithURL:[NSURL URLWithString:buyGoods.goodsImage] placeholderImage:[UIImage imageNamed:@"暂无图片90px.png"]];
        cell.money.text=[NSString stringWithFormat:@"￥:%@",buyGoods.goodsPrice];
        tableView.showsVerticalScrollIndicator=NO;
        tableView.backgroundColor=eliuyan_color(0xf5f5f5);
        return cell;
    }
   

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 29;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 0;


}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView = [[UIView alloc] init];
    [headView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel * tishi = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 310, 20)];
    tishi.backgroundColor = [UIColor clearColor];
    tishi.text = [NSString stringWithFormat:@"购买商品"];
    tishi.font = [UIFont systemFontOfSize:15];
    tishi.textColor = eliuyan_color(0x404040);
    [headView addSubview:tishi];
    
    UILabel * buyContent = [[UILabel alloc] initWithFrame:CGRectMake(320-55, 3, 60, 20)];
    buyContent.backgroundColor = [UIColor clearColor];
    buyContent.text = [NSString stringWithFormat:@"共%d件",totalCount];
    buyContent.font = [UIFont systemFontOfSize:15];
    buyContent.textColor = eliuyan_color(0xababaa);
    [headView addSubview:buyContent];
    
    
    //分割线
    UIImageView *lineImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"线4.png"]];
    lineImageView.frame=CGRectMake(0,28, 320, 1);
    [headView addSubview:lineImageView];
    
    return headView;
}
#pragma mark -
#pragma  mark - ButtonClick
//打电话
-(void)callPhone:(id)sender
{
    
    NSLog(@"telNumber is %@",telNum);
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",telNum]];
    if ( !callWebview ) {
        callWebview = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [callWebview loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self addSubview:callWebview];
}
//确认收货
-(void)sureCount:(id)sender
{
    //判断是否有订单
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"亲，是否确认收货" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alert.delegate=self;
        alert.tag=10086;
        [alert show];
}


-(void)call_Back:(void (^)(NSString *))call
{
    if(self)
    {
        _Back = call;
    }
}
#pragma mark -
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==10086)
        {
            _Back(@"确认订单");
            if (buttonIndex==0) {
            NSLog(@"确定");
            //调用接口9
            NSLog(@">>>>>>>%@",self.oredrId);
            //隐藏btn
            Confirm.hidden=YES;
            //标题改变
            _statusLabel.textColor =[UIColor grayColor];
            _statusLabel.text = @"订单已完成                                               订单完成";
//            statusLabel.textAlignment=NSTextAlignmentLeft;

            httpRequest * http = [[httpRequest alloc] init];
            [http httpRequestSend:[NSString stringWithFormat:@"%@order/GainGoods",SERVICE_ADD] parameter:[NSString stringWithFormat:@"Id=%@&Token=%@",_oredrId,[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"]] backBlock:(^(NSDictionary * dic){
                NSLog(@"===>%@",dic);
                
                self.values=[dic objectForKey:@"ReturnValues"];
                NSLog(@"values=%@",self.values);
                
            })];
                
        }
        else
        {
            NSLog(@"取消");
        }
        
    }
    
}


#pragma mark --
#pragma mark 关于音频下载和播放

#pragma mark -- 下载音频文件
-(void)downLoadVoice
{
    activity = [[Activity alloc] initWithActivity:self];
    [activity start];
    
    
    
    //初始化Documents路径
    NSString *path =[ NSSearchPathForDirectoriesInDomains ( NSDocumentDirectory , NSUserDomainMask , YES ) objectAtIndex:0];
    
    //初始化临时文件路径
    // NSString *folderPath = [path stringByAppendingPathComponent:@"temp"];
    
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
    
    NSLog(@"%@",avadioURL);
    NSString *filePath =[NSString stringWithFormat:@"%@%@",DOWNLOAD_FILE,avadioURL] ;
    //初始化下载路径
    NSURL *url = [NSURL URLWithString:filePath];
    //设置下载路径
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    //设置ASIHttpRequest代理
    request.delegate = self;
    //初始化保存文件的路径
    _savePath = [path stringByAppendingPathComponent:avadioURL];
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
    [activity stop];
    
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    
    
    NSLog(@"requset did started");
    
    
    
}
-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    
    NSLog(@"asihttprequest did recive response");
    [activity stop];
    
    
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    
    
    [activity stop];
    
    NSURL *fileUrl = [NSURL URLWithString:_savePath];
    NSLog(@"path is %@",fileUrl);
    self.Player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
    [self.Player prepareToPlay];
    [self.Player setDelegate:self];
    //self.player.numberOfLoops = 1;
    
    
    
}
//播放音频
-(void)play:(UIButton *)sender
{
    
    if([self.Player isPlaying])
    {
        [self.Player pause];
        
    }
    else
    {
        
        [self.Player play];
        
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
    
    //音频播放完成之后
}


- (void)didReceiveMemoryWarning
{
    [self didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
