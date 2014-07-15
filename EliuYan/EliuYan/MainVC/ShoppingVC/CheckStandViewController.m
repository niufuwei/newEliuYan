//
//  CheckStandViewController.m
//  ELiuYan
//
//  Created by laoniu on 14-4-30.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "CheckStandViewController.h"
#import "lame.h"
#import "DeliveryInformationViewController.h"
#import "GoodsTableViewCell.h"
#import "LCVoiceHud.h"
#import "AppDelegate.h"

#pragma mark - <DEFINES>

#define WAVE_UPDATE_FREQUENCY   0.05

#pragma mark - <CLASS> LCVoice
@interface CheckStandViewController ()
{
    NSMutableDictionary * countDic;     //用来加、减商品的个数
    NSInteger jianshu;                  //用来记录递增的购买件数
    float jiage;                        //用来记录递增的购买价格
    BOOL isFirst;                       //用来判断是不是第一次登录
    NSString *mp3FilePath;              //录音转换成MP3个时候的保存地址
    BOOL isTouch;                       //判断进入当前页面是否有操作
    BOOL isJinGeTouch;                  //是否点击了斤或者个的按钮
    NSMutableDictionary * okDic;        //记录加载的cell，保证只加载一次，价格递增，件数递增
    NSMutableDictionary * jingeDic;     //保存斤或者个的选择
    NSString * strDescriptonType ;      //type=1 文字  2 语音
    Activity * ac;                      //菊花
    LCVoiceHud * voiceHud_;
     NSTimer * timer_;
    UIButton * conFirm;

}
//@property (nonatomic,strong) AVAudioRecorder
@end

@implementation CheckStandViewController
@synthesize ButtomView;
@synthesize Video_OR_input_Button;
@synthesize VideoButton;
@synthesize isVideo;
@synthesize Message;
@synthesize recorder;
@synthesize recording;
@synthesize audioPlayer;
@synthesize tmpFile;
@synthesize audioSession;
@synthesize VideoButtonPlayed;
@synthesize dataMutableArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}


-(void)viewDidAppear:(BOOL)animated
{
//    CGRect hh = _tableView.frame;
//    hh.size.height = self.view.frame.size.height-98;
//    _tableView.frame = hh;
    if([Message.text length]==0)
    {
        [disTextPlaceHolder setHidden:NO];
    }
    [conFirm setEnabled:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor=eliuyan_color(0xf5f5f5);

    strDescriptonType = @"1";
    isJinGeTouch = FALSE;
    isFirst = TRUE;
    isTouch = FALSE;
    isMinReload=  FALSE;
    
    jingeDic = [[NSMutableDictionary alloc ] init];
    
    NavCustom *nav=[[NavCustom alloc] init];
    [nav setNav:@"订单确认" mySelf:self];

    
    okDic= [[NSMutableDictionary alloc] init];
    countDic = [[NSMutableDictionary alloc] init];
    //取出商品类型
    self.storeType=[[NSUserDefaults standardUserDefaults] objectForKey:@"storeTypeName"];
    
//  dataMutableArray = [[NSMutableArray alloc] init];
    
    //创建表
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320,100000)];
//    _tableView.backgroundColor=eliuyan_color(0xf6f4ef);
    _tableView.delegate=self;
     _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    //默认文字输入
    isVideo = TRUE;

    //初始化底部视图
    [self initButtomView];
    
    //默认为未录音状态
    recording = FALSE;
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/downloadFile.caf"];
    tmpFile = [[NSURL alloc] initFileURLWithPath:path];
    
    [self setLeftItem];
    
    // Do any additional setup after loading the view.
}

//秒数计算
-(void)timerFired
{
    addCount++;
}

-(void)initButtomView
{
    
    //加载底部视图
    if (IOS_VERSION>=7.0) {
        ButtomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-98-self.navigationController.navigationBar.frame.size.height-20, 320, 98)];
    }
    else
    {
        ButtomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-98-self.navigationController.navigationBar.frame.size.height , 320, 98)];
    }

    ButtomView.backgroundColor=eliuyan_color(0xf5f5f5);
    [self.view addSubview:ButtomView];
    
    
    UIImageView * imageHeng = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    [imageHeng setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:184.0/255.0 blue:176.0/255.0 alpha:1]];
    [ButtomView addSubview:imageHeng];
    
    //初始化录音和输入文字切换按钮
    Video_OR_input_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    Video_OR_input_Button.frame = CGRectMake(10, 7, 40, 35);
    [Video_OR_input_Button setBackgroundImage:[UIImage imageNamed:@"收银台_语音键-未按.png"] forState:UIControlStateNormal];
    
    [Video_OR_input_Button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    Video_OR_input_Button.tag = 101;
    [ButtomView addSubview:Video_OR_input_Button];
    
    UIImageView * imageHeng2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, 320, 1)];
    [imageHeng2 setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:184.0/255.0 blue:176.0/255.0 alpha:1]];
    [ButtomView addSubview:imageHeng2];
    
    
    //初始化文字输入框
    Message = [[UITextView alloc] initWithFrame:CGRectMake(Video_OR_input_Button.frame.size.width+Video_OR_input_Button.frame.origin.x+10, 1, 320-Video_OR_input_Button.frame.origin.x-Video_OR_input_Button.frame.size.width-20, 48)];
    Message.font = [UIFont systemFontOfSize:14];
    Message.textColor =eliuyan_color(0x404040);
    Message.backgroundColor = [UIColor clearColor];
    Message.delegate = self;
    Message.returnKeyType = UIReturnKeyGo;
    [ButtomView addSubview:Message];
    
    disTextPlaceHolder = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, Message.frame.size.width, 15)];
    disTextPlaceHolder.textAlignment = NSTextAlignmentCenter;
    disTextPlaceHolder.text = @"捎些话(100个字以内)";
    disTextPlaceHolder.backgroundColor = [UIColor clearColor];
    disTextPlaceHolder.textColor = [UIColor grayColor];
    [Message addSubview:disTextPlaceHolder];
    
    UIImageView * lableHeng = [[UIImageView alloc] initWithFrame:CGRectMake(45, disTextPlaceHolder.frame.size.height, disTextPlaceHolder.frame.size.width-90, 1)];
    [lableHeng setBackgroundColor: [UIColor grayColor]];
    [disTextPlaceHolder addSubview:lableHeng];
    
    //初始化语音按钮
    VideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    VideoButton.frame = CGRectMake(Video_OR_input_Button.frame.size.width+Video_OR_input_Button.frame.origin.x+10, 7, 320-Video_OR_input_Button.frame.origin.x-Video_OR_input_Button.frame.size.width-20, 35);
    [VideoButton setBackgroundImage:[UIImage imageNamed:@"收银台_语音-未按.png"] forState:UIControlStateNormal];
    [VideoButton setHidden:YES];
    [VideoButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchDown];
    [VideoButton addTarget:self action:@selector(onClickRepeat:) forControlEvents:UIControlEventTouchUpInside];
    VideoButton.tag = 102;
    [ButtomView addSubview:VideoButton];
    
    
    //初始化件数和金额
    statistical = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 220, 48)];
    statistical.backgroundColor=[UIColor clearColor];
    statistical.textColor = [UIColor redColor];
//    statistical.font = [UIFont systemFontOfSize:16];

    [ButtomView addSubview:statistical];
    
    //初始化确认下单按钮
    conFirm = [UIButton buttonWithType:UIButtonTypeCustom];
    conFirm.frame = CGRectMake(320-100+10+10, 10+49, 70, 30);
//    [conFirm setBackgroundColor:[UIColor redColor]];
    conFirm.titleLabel.font=[UIFont systemFontOfSize:15];
    [conFirm setTitle:@"确认下单" forState:UIControlStateNormal];
//    [conFirm setTintColor:[UIColor whiteColor]];
    [conFirm setBackgroundColor:eliuyan_color(0xe94f4f)];
    //[conFirm setBackgroundImage:[UIImage imageNamed:@"确认收货-按下.png"] forState:UIControlStateHighlighted];
    conFirm.tag=104;
    [conFirm addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [ButtomView addSubview:conFirm];
    
    //初始化语音按钮
    VideoButtonPlayed = [UIButton buttonWithType:UIButtonTypeCustom];
    VideoButtonPlayed.frame = CGRectMake(Video_OR_input_Button.frame.size.width+Video_OR_input_Button.frame.origin.x+10, 7, 320-Video_OR_input_Button.frame.origin.x-Video_OR_input_Button.frame.size.width-20, 35);
    VideoButtonPlayed.layer.borderColor = [UIColor colorWithRed:248.0/255.0 green:145.0/255.0 blue:148.0/255.0 alpha:1].CGColor;
    VideoButtonPlayed.layer.borderWidth =1;
    [VideoButtonPlayed setHidden:YES];
    [VideoButtonPlayed addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [VideoButtonPlayed setBackgroundColor:[UIColor clearColor]];

    VideoButtonPlayed.tag = 103;
    
    UILongPressGestureRecognizer *longGnizer=nil;
    longGnizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self
                                                            action:@selector(longPressToDo:)];
    longGnizer.minimumPressDuration = 2.0;
    [VideoButtonPlayed addGestureRecognizer:longGnizer];

    [ButtomView addSubview:VideoButtonPlayed];

    //初始化一次
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        [VideoButtonPlayed setHidden:YES];
        [VideoButton setHidden:NO];
        [VideoButton setImage:[UIImage imageNamed:@"收银台_语音-按住.png"] forState:UIControlStateNormal];
        [self startRecord];

        
        
    }
    if(gesture.state == UIGestureRecognizerStateEnded)
    {
        //录音结束
        [VideoButton setImage:[UIImage imageNamed:@"tm.png"] forState:UIControlStateNormal];

        [self onClickRepeat:nil];

    }
}

-(IBAction)onClick:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    switch (btn.tag) {
        case 101:
        {
             if(isVideo)
             {
                 [Video_OR_input_Button setBackgroundImage:[UIImage imageNamed:@"收银台_键盘键-未按.png"] forState:UIControlStateNormal];
                 [VideoButton setHidden:NO];
                 [Message setHidden:YES];
                 isVideo = FALSE;
                 [self.view endEditing:YES];
                 strDescriptonType= @"2";
             }
             else
             {
                 [Video_OR_input_Button setBackgroundImage:[UIImage imageNamed:@"收银台_语音键-未按.png"] forState:UIControlStateNormal];
                 [VideoButton setHidden:YES];
                 [VideoButtonPlayed setHidden:YES];
                 [Message setHidden:NO];
                 isVideo = TRUE;
                 strDescriptonType = @"1";
                if([Message.text length]==0)
                {
                    [disTextPlaceHolder setHidden:NO];
                }
             }
        }
            break;
        case 102:
        {
            //开始录音
            [self startRecord];
        }
            break;
        case 103:
        {
           if([audioPlayer isPlaying])
           {
               
           }
            else
            {
                [audioPlayer play];
                self.minCount = 1;

                minTimer =[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(minmCount)userInfo:nil repeats:YES];
                [minTimer fire];
            }
        }
            break;
            case 104://确认下单
            
            //判断
            
        {
            
             if ([self.storeType isEqualToString:@"水果店"])
             {
                 [conFirm setEnabled:NO];

                 [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
                 
                 
                 [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",jianshu] forKey:@"GoodsCount"];
                 
                 [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.2f",jiage] forKey:@"OrderPrice"];
                 
                 [[NSUserDefaults standardUserDefaults] setObject:strDescriptonType forKey:@"DescriptonType"];
                 
                 //打包
                 
                 NSMutableArray * allarr =[[NSMutableArray alloc] init];
                 
                 for(int i=0 ;i<[dataMutableArray count];i++)
                 {
                     NSArray * arr = [dataMutableArray objectAtIndex:i];
                     NSMutableDictionary *  dic = [[NSMutableDictionary alloc] init];
                     NSMutableDictionary * allDic = [[NSMutableDictionary alloc] init];
                     
                     if ([self.storeType isEqualToString:@"水果店"])
                     {
                         dic= [arr objectAtIndex:2];
                         [allDic setObject:[jingeDic objectForKey:[NSString stringWithFormat:@"%d",((i+1)*1000)/2*3+1]] forKey:@"BuyType"];
                     }
                     
                     else
                     {
                         dic= [arr objectAtIndex:1];
                     }
                     
                     
                     [allDic setObject:[dic objectForKey:@"Id"] forKey:@"GoodId"];
                     [allDic setObject:[dic objectForKey:@"GoodsName"] forKey:@"GoodsName"];
                     
                     
                     [allDic setObject:[dic objectForKey:@"Price"] forKey:@"Price"];
                     
                     
                     /////////////
                     
                     //截取字符串
                     
                     NSArray * imageArr=[[dic objectForKey:@"Image"] componentsSeparatedByString:@"/"];
                     NSLog(@"<<<<%@",imageArr);
                     if ([imageArr count] ==1) {
                         NSString *image3=@"";
                         [allDic setObject:image3 forKey:@"Image"];
                     }
                     else
                     {
                         //截取字符串
                         NSRange range = [[dic objectForKey:@"Image"] rangeOfString:@"/"];
                         NSString *image = [[dic objectForKey:@"Image"] substringFromIndex:range.location + range.length];//开始截取
                         
                         NSRange range1 = [image rangeOfString:@"/"];
                         NSString *image1 = [image substringFromIndex:range1.location + range1.length];//开始截取
                         
                         NSRange range2 = [image1 rangeOfString:@"/"];
                         NSString *image2 = [image1 substringFromIndex:range2.location + range2.length];//开始截取
                         
                         
                         NSString *image3=[NSString stringWithFormat:@"/%@",image2];
                         NSLog(@"llllll=%@",image3);                         [allDic setObject:image3 forKey:@"Image"];
                     }
                     
                     
                     ///////////////////
                     
                     
                     [allDic setObject:[dic objectForKey:@"Price"] forKey:@"Price"];
                     
                     
                     [allDic setObject:[countDic objectForKey:[NSString stringWithFormat:@"%d",i+1]] forKey:@"GoodsCount"];
                     
                     [allarr addObject:allDic];
                 }
                 
                 [[NSUserDefaults standardUserDefaults] setObject:allarr forKey:@"GoodsList"];
                 
                 if([strDescriptonType isEqualToString:@"1"])
                 {
                     [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"DescriptonType"];
                     [[NSUserDefaults standardUserDefaults] setObject:Message.text forKey:@"Descripton"];
                     //进入下单界面
                     DeliveryInformationViewController *delivery=[[DeliveryInformationViewController alloc] init];
                     [self.navigationController pushViewController:delivery animated:YES];
                 }
                 else
                 {
                     //传语音
                     ac = [[Activity alloc] initWithActivity:self.view];
                     [ac start];
                     ASIFormDataRequest *httpRequest = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:UPLOAD_FILE]];
                     [httpRequest setDelegate:self];
                     [httpRequest addData:mp3FilePath withFileName:@"downloadFile.mp3" andContentType:@"audio/mpeg" forKey:@"voice"];
                     httpRequest.timeOutSeconds=60;
                     [httpRequest startAsynchronous];
                     
                 }

             }
            else
            {
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"MinBuy"] floatValue] > jiage)
                {
                    UIAlertView * alert =[[UIAlertView alloc] initWithTitle:nil message:@"您选择的东西低于起送价格" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else
                {
                    [conFirm setEnabled:NO];

                    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
                    
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",jianshu] forKey:@"GoodsCount"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.2f",jiage] forKey:@"OrderPrice"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:strDescriptonType forKey:@"DescriptonType"];
                    
                    //打包
                    
                    NSMutableArray * allarr =[[NSMutableArray alloc] init];
                    
                    for(int i=0 ;i<[dataMutableArray count];i++)
                    {
                        NSArray * arr = [dataMutableArray objectAtIndex:i];
                        NSMutableDictionary *  dic = [[NSMutableDictionary alloc] init];
                        NSMutableDictionary * allDic = [[NSMutableDictionary alloc] init];
                        
                        if ([self.storeType isEqualToString:@"水果店"])
                        {
                            dic= [arr objectAtIndex:2];
                            [allDic setObject:[jingeDic objectForKey:[NSString stringWithFormat:@"%d",((i+1)*1000)/2*3+1]] forKey:@"BuyType"];
                        }
                        
                        else
                        {
                            dic= [arr objectAtIndex:1];
                        }
                        
                        
                        [allDic setObject:[dic objectForKey:@"Id"] forKey:@"GoodId"];
                        [allDic setObject:[dic objectForKey:@"GoodsName"] forKey:@"GoodsName"];
                        
                        
                        [allDic setObject:[dic objectForKey:@"Price"] forKey:@"Price"];
                        
                        
                        /////////////
                        
                        //截取字符串
                        
                        NSArray * imageArr=[[dic objectForKey:@"Image"] componentsSeparatedByString:@"/"];
                        NSLog(@"<<<<%@",imageArr);
                        if ([imageArr count] ==3) {
                            NSString *image3=@"";
                             [allDic setObject:image3 forKey:@"Image"];
                        }
                        else
                        {
                            //截取字符串
                            NSRange range = [[dic objectForKey:@"Image"] rangeOfString:@"/"];
                            NSString *image = [[dic objectForKey:@"Image"] substringFromIndex:range.location + range.length];//开始截取
                            
                            NSRange range1 = [image rangeOfString:@"/"];
                            NSString *image1 = [image substringFromIndex:range1.location + range1.length];//开始截取
                            
                            NSRange range2 = [image1 rangeOfString:@"/"];
                            NSString *image2 = [image1 substringFromIndex:range2.location + range2.length];//开始截取
                            
                            
                            NSString *image3=[NSString stringWithFormat:@"/%@",image2];
                            NSLog(@"llllll=%@",image3);                             [allDic setObject:image3 forKey:@"Image"];
                        }
    
    
                        ///////////////////
                        
                       
                        [allDic setObject:[dic objectForKey:@"Price"] forKey:@"Price"];
                        
//                        
//                        NSLog(@".....%@",countDic);
//                        NSLog(@">>>>>%@",allDic);
//                        NSLog(@"``````````%d",i);
                        
                        [allDic setObject:[countDic objectForKey:[NSString stringWithFormat:@"%d",i+1]] forKey:@"GoodsCount"];
                        
                        [allarr addObject:allDic];
                    }
                    
                    [[NSUserDefaults standardUserDefaults] setObject:allarr forKey:@"GoodsList"];
                    
                    if([strDescriptonType isEqualToString:@"1"])
                    {
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"DescriptonType"];
                        [[NSUserDefaults standardUserDefaults] setObject:Message.text forKey:@"Descripton"];
                        //进入下单界面
                        DeliveryInformationViewController *delivery=[[DeliveryInformationViewController alloc] init];
                        [self.navigationController pushViewController:delivery animated:YES];
                    }
                    else
                    {
                        //传语音
                        ac = [[Activity alloc] initWithActivity:self.view];
                        [ac start];
                        ASIFormDataRequest *httpRequest = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:UPLOAD_FILE]];
                        [httpRequest setDelegate:self];
                        [httpRequest addData:mp3FilePath withFileName:@"downloadFile.mp3" andContentType:@"audio/mpeg" forKey:@"voice"];
                        httpRequest.timeOutSeconds=60;
                        [httpRequest startAsynchronous];
                        
                    }
                    
                }

            }
            
            
        }
            break;
        default:
            break;
    }
}

-(void)startRecord
{
    NSLog(@"开始录音");
    
    timer_ = [NSTimer scheduledTimerWithTimeInterval:WAVE_UPDATE_FREQUENCY target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
    [self showVoiceHudOrHide:YES];
    
    addTimer =[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired)userInfo:nil repeats:YES];
    //秒数开始增加
    addCount = 0;
    [addTimer fire];
    
    audioSession = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&sessionError];
    if(audioSession ==nil)
    {
        NSLog(@"Error:%@",sessionError);
    }
    else
    {
        [audioSession setActive:YES error:nil];
        
    }
    
    //录音设置
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [settings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    //采样率
    [settings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];//44100.0
    //通道数
    [settings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    //线性采样位数
    //[recordSettings setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
    //音频质量,采样质量
    [settings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    
    
    recorder = [[AVAudioRecorder alloc] initWithURL:tmpFile settings:settings error:nil];
    recorder.delegate = self;
    [recorder prepareToRecord];
    recorder.meteringEnabled = YES;
    [recorder record];

}
#pragma mark - Timer Update

- (void)updateMeters {
    
    self.recordTime += WAVE_UPDATE_FREQUENCY;
    
    if (voiceHud_)
    {
        /*  发送updateMeters消息来刷新平均和峰值功率。
         *  此计数是以对数刻度计量的，-160表示完全安静，
         *  0表示最大输入值
         */
        
        if (recorder) {
            [recorder updateMeters];
        }
        
        float peakPower = [recorder averagePowerForChannel:0];
        double ALPHA = 0.05;
        double peakPowerForChannel = pow(10, (ALPHA * peakPower));
        
        [voiceHud_ setProgress:peakPowerForChannel];
    }
}

#pragma mark - Helper Function

-(void) showVoiceHudOrHide:(BOOL)yesOrNo{
    
    if (voiceHud_) {
        [voiceHud_ hide];
        voiceHud_ = nil;
    }
    
    if (yesOrNo) {
        
        voiceHud_ = [[LCVoiceHud alloc] init];
        [voiceHud_ show];
        
    }else{
        
    }
}

#pragma mark - LCVoiceHud Delegate

-(void) LCVoiceHudCancelAction
{
    [self cancelled];
}

- (void)cancelled {
    
    [self showVoiceHudOrHide:NO];
    [self resetTimer];
    [self cancelRecording];
}
-(void) resetTimer
{
    if (timer_) {
        [timer_ invalidate];
        timer_ = nil;
    }
}

-(void) cancelRecording
{
    if (self.recorder.isRecording) {
        [self.recorder stop];
    }
    
    self.recorder = nil;
}

#pragma mark - 
#pragma mark - ASIHttpDelegate
-(void)requestFinished:(ASIHTTPRequest *)request
{

    [conFirm setEnabled:YES];

    [ac stop];
    NSLog(@"asi得到的数据＝%@",request.responseString);
    [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"DescriptonType"];
    [[NSUserDefaults standardUserDefaults] setObject:request.responseString forKey:@"Descripton"];
    //进入下单界面
    DeliveryInformationViewController *delivery=[[DeliveryInformationViewController alloc] init];
    [self.navigationController pushViewController:delivery animated:YES];

    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    [ac stop];
    NSLog(@"请求错误＝＝＝＝＝＝》》》》%@",request.error);
    [conFirm setEnabled:YES];

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"语音上传失败，请重新上传" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
}


-(void)minmCount
{
    if(self.minCount < addCount || self.minCount == addCount)
    {
        [VideoButtonPlayed setTitle:[NSString stringWithFormat:@"播放 %d'",self.minCount] forState:UIControlStateNormal];
        self.minCount++;
    }
    else
    {
        [minTimer setFireDate:[NSDate distantFuture]];
    }
}

//手指松开结束录音
-(IBAction)onClickRepeat:(id)sender
{
    NSLog(@"结束录音");
    //秒数计数停止
    [addTimer invalidate];
    [self showVoiceHudOrHide:NO];
    
    [VideoButtonPlayed setHidden:NO];
    [VideoButton setHidden:YES];
    recording = NO;
    [audioSession setActive:NO error:nil];
    [recorder stop];
    [self audio_PCMtoMP3];
    if(recorder)
    {
        recorder = nil;
    }
    
    [VideoButtonPlayed setTitle:[NSString stringWithFormat:@"播放 %d'",addCount] forState:UIControlStateNormal];
    [VideoButtonPlayed setTitleColor:[UIColor colorWithRed:245.0/255.0 green:45.0/255.0 blue:56.0/255.0 alpha:1] forState:UIControlStateNormal];

}

//语音转换
- (void)audio_PCMtoMP3
{
    NSString *cafFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/downloadFile.caf"];
    
    mp3FilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/downloadFile.mp3"];
    
    
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if([fileManager removeItemAtPath:mp3FilePath error:nil])
    {
        NSLog(@"删除");
    }
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {

        NSError *playerError;
        AVAudioPlayer *audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:mp3FilePath] error:&playerError];
        self.audioPlayer = audioPlayer2;
        self.audioPlayer.volume = 1.0f;
        if (self.audioPlayer == nil)
        {
            NSLog(@"ERror creating player: %@", [playerError description]);
        }
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
        self.audioPlayer.delegate = self;
    }
}
#pragma mark --
#pragma mark 对键盘的操作
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self registerForKeyboardNotifications];
    [disTextPlaceHolder setHidden:YES];

    [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
        ButtomView.frame = CGRectMake(0, self.view.frame.size.height-98-216, 320, 98);
    } completion:^(BOOL finished) {
        
    }];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
        ButtomView.frame = CGRectMake(0, self.view.frame.size.height-98, 320, 98);
    } completion:^(BOOL finished) {
        
    }];
}
//注册通知
- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardwasDown:) name:UIKeyboardDidHideNotification object:nil];
}

//键盘隐藏式触发
- (void) keyboardwasDown:(NSNotification *) notif
{
    [UIView animateWithDuration:0.1 delay:0 options:0 animations:^{
        ButtomView.frame = CGRectMake(0, self.view.frame.size.height-98, 320, 98);
    } completion:^(BOOL finished) {
        
    }];
}


//键盘弹出时触发

- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGSize keyboardSize = [value CGRectValue].size;
    
    [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
        ButtomView.frame = CGRectMake(0, self.view.frame.size.height-98-keyboardSize.height, 320, 98);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGRect hh = _tableView.frame;
    hh.size.height = self.view.frame.size.height-98;
    _tableView.frame = hh;
    
    if(isMinReload)
    {
        [_tableView setContentOffset:CGPointMake(0,tableYY.origin.y+110) animated:NO];

    }
    
    isMinReload = FALSE;
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [appDelegate hidenTabbar];

}

#pragma mark -
#pragma mark - UITableViewDelegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    return dataMutableArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isMinReload)
    {
        [_tableView setContentOffset:CGPointMake(0,tableYY.origin.y) animated:NO];
    }
    static NSString *cellIndentifer=@"Cell";
    GoodsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if (cell==nil) {
        NSArray *aCell=[[NSBundle mainBundle] loadNibNamed:@"GoodsTableViewCell" owner:nil options:nil];
        cell=[aCell objectAtIndex:1];
        
        [cell.plaseBtn setBackgroundImage:[UIImage imageNamed:@"联华超市_18.png"] forState:UIControlStateNormal];
        
    //改变坐标和大小
        cell.backgroundColor=eliuyan_color(0xf5f5f5);
        cell.contentView.frame=CGRectMake(0, 0, 320, 110 );
        cell.logoImage.frame=CGRectMake(10, 10, 90, 90);
        cell.contentLabel.frame=CGRectMake(110, 0, 320-110, 64);
        cell.contentLabel.lineBreakMode=0;
        
    
        cell.jinButton.frame=CGRectMake(110, 70, 30, 30);
        cell.geButton.frame=CGRectMake(110+30, 70, 30, 30);
        cell.minusBtn.frame=CGRectMake(110+30+50+30, 70, 30, 30);
        cell.countLabel.frame=CGRectMake(110+30+50+30+35, 70, 30, 30);
        cell.plaseBtn.frame=CGRectMake(110+30+100+50, 70, 30, 30);
        cell.priceLabel.frame=CGRectMake(110, 70, 70, 24);
       
        [cell.plaseBtn addTarget:self action:@selector(plaseClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.minusBtn addTarget:self action:@selector(minClick:) forControlEvents:UIControlEventTouchUpInside];

        
        [cell.jinButton addTarget:self action:@selector(jinClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.geButton addTarget:self action:@selector(geClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.jinButton.hidden=YES;
        cell.geButton.hidden=YES;
        
        if ([self.storeType isEqualToString:@"水果店"]){
            cell.jinButton.hidden=NO;
            cell.geButton.hidden=NO;
            cell.logoImage.frame=CGRectMake(10, 10, 70, 70);
            cell.priceLabel.frame=CGRectMake(10, 80, 70, 24);
            cell.priceLabel.textAlignment=YES;
        }

    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.plaseBtn.tag = indexPath.row+1;
    cell.minusBtn.tag = indexPath.row+1;
    
    cell.jinButton.tag =((indexPath.row+1)*1000)/2*3+1;
    cell.geButton.tag =((indexPath.row+1)*1000)/2*3+1;
    
    
    cell.countLabel.text=[countDic objectForKey:[NSString stringWithFormat:@"%d",cell.plaseBtn.tag]]?[countDic objectForKey:[NSString stringWithFormat:@"%d",cell.plaseBtn.tag]]:[[dataMutableArray objectAtIndex:indexPath.row] objectAtIndex:0];
    
    [countDic setObject:cell.countLabel.text forKey:[NSString stringWithFormat:@"%d",cell.plaseBtn.tag]];
    
    if ([self.storeType isEqualToString:@"水果店"])
    {
//        if(!isJinGeTouch)
//        {
//            if([[[dataMutableArray objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"jin"])
//            {
//                [jingeDic setObject:@"1" forKey:[NSString stringWithFormat:@"%d",cell.jinButton.tag]];
//                
//                [cell.jinButton setBackgroundImage:[UIImage imageNamed:@"水果店_切换按钮 (1).png"] forState:UIControlStateNormal];
//                [cell.geButton setBackgroundImage:[UIImage imageNamed:@"水果店_切换按钮 (2).png"] forState:UIControlStateNormal];
//            }
//            else
//            {
                [jingeDic setObject:@"2" forKey:[NSString stringWithFormat:@"%d",cell.jinButton.tag]];
                [cell.jinButton setBackgroundImage:[UIImage imageNamed:@"水果店_切换按钮 (6).png"] forState:UIControlStateNormal];
                [cell.geButton setBackgroundImage:[UIImage imageNamed:@"水果店_切换按钮 (5).png"] forState:UIControlStateNormal];
//            }

//        }
//        else
//        {
//            if([[jingeDic objectForKey:[NSString stringWithFormat:@"%d",cell.jinButton.tag]] isEqualToString:@"1"])
//            {
//                [cell.jinButton setBackgroundImage:[UIImage imageNamed:@"水果店_切换按钮 (1).png"] forState:UIControlStateNormal];
//                [cell.geButton setBackgroundImage:[UIImage imageNamed:@"水果店_切换按钮 (2).png"] forState:UIControlStateNormal];
//            }
//            else
//            {
//                [cell.jinButton setBackgroundImage:[UIImage imageNamed:@"水果店_切换按钮 (6).png"] forState:UIControlStateNormal];
//                [cell.geButton setBackgroundImage:[UIImage imageNamed:@"水果店_切换按钮 (5).png"] forState:UIControlStateNormal];
//            }
//        }
        
        
        NSDictionary *dic=[[dataMutableArray objectAtIndex:indexPath.row] objectAtIndex:2];
        
        cell.priceLabel.text=[NSString stringWithFormat:@"%@/斤",[dic objectForKey:@"Price"]];
//        cell.priceLabel.frame=CGRectMake(10, 65, 60, 30);
        cell.contentLabel.text=[dic objectForKey:@"GoodsName"];
        [cell.logoImage setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"Image"]] placeholderImage:[UIImage imageNamed:@"暂无.png"]];
        
    }
    else{//超市
        
        NSDictionary *dic=[[dataMutableArray objectAtIndex:indexPath.row] objectAtIndex:1];
        cell.contentLabel.text=[dic objectForKey:@"GoodsName"];
        cell.priceLabel.text=[NSString stringWithFormat:@"￥:%@",[dic objectForKey:@"Price"]];
        
        [cell.logoImage setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"Image"]] placeholderImage:[UIImage imageNamed:@"暂无.png"]];
        
        
    }
//
    if(![[okDic objectForKey:[NSString stringWithFormat:@"%d",(indexPath.row+1)*200]] isEqualToString:@"ok"])
    {
        if ([self.storeType isEqualToString:@"水果店"])
        {
            jiage += [cell.countLabel.text intValue]* [cell.priceLabel.text floatValue];
        }
        else
        {
            NSString *str=[cell.priceLabel.text substringFromIndex:2];
            jiage += [cell.countLabel.text intValue]* [str floatValue];
        }
        jianshu += [cell.countLabel.text intValue];
        
        //判断是否是水果店 水果店不用显示
        if ([self.storeType isEqualToString:@"水果店"])
        {
            statistical.text = [NSString stringWithFormat:@"共%d件",jianshu];
        }
        else
        {
            statistical.text = [NSString stringWithFormat:@"共%d件                 %.2f元",jianshu,jiage];
        }

        
        
        [okDic setObject:@"ok" forKey:[NSString stringWithFormat:@"%d",200*(indexPath.row+1)]];
    }
    tableView.backgroundColor=eliuyan_color(0xf5f5f5);
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

#pragma mark --
#pragma mark 加号方法



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    tableYY.origin.y=scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    tableYY.origin.y=scrollView.contentOffset.y;
}
-(IBAction)plaseClick:(id)sender
{
    CGRect hh = _tableView.frame;
    hh.size.height = 100000;
    _tableView.frame = hh;
    
    
    UIButton * btn =(UIButton*)sender;

    
    [_tableView setContentOffset:CGPointMake(0,tableYY.origin.y) animated:NO];

    
    GoodsTableViewCell *cell;
    if (IOS_VERSION >= 7.0) {
        cell=(GoodsTableViewCell *)[[[btn superview] superview]superview];
    }
    else
    {
        cell=(GoodsTableViewCell *)[[btn superview]superview];
    }

    
    cell.countLabel.text = [NSString stringWithFormat:@"%d",[cell.countLabel.text intValue]+1];
    
    [countDic setObject:cell.countLabel.text forKey:[NSString stringWithFormat:@"%d",btn.tag]];
    
    jianshu ++;
    if ([self.storeType isEqualToString:@"水果店"])
    {
        jiage += [cell.priceLabel.text floatValue];

        statistical.text = [NSString stringWithFormat:@"共%d件                    ",jianshu];

    }
    else
    {
        

        NSString *str=[cell.priceLabel.text substringFromIndex:2];
        jiage += [str floatValue];
        statistical.text = [NSString stringWithFormat:@"共%d件                    %.2f元",jianshu,jiage];

    }
    
    isTouch = TRUE;
    
}

#pragma mark --
#pragma mark 减号方法
-(IBAction)minClick:(id)sender
{
    CGRect hh = _tableView.frame;
    hh.size.height = 100000;
    _tableView.frame = hh;
    isTouch = TRUE;
    
    UIButton * btn =(UIButton*)sender;

    GoodsTableViewCell *cell;
    if (IOS_VERSION >= 7.0) {
        cell=(GoodsTableViewCell *)[[[btn superview] superview]superview];
    }
    else
    {
        cell=(GoodsTableViewCell *)[[btn superview]superview];
    }
    
    cell.countLabel.text = [NSString stringWithFormat:@"%d",[cell.countLabel.text intValue]-1];
    
    if([cell.countLabel.text intValue] == 0)
    {
        //删除
        NSIndexPath * index = [NSIndexPath indexPathForRow:btn.tag-1 inSection:0];
        
        [dataMutableArray removeObjectAtIndex:btn.tag-1];//移除数据源的数据
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
   
        NSInteger temp_tag = btn.tag;
        for(int i=0;i<[[countDic allKeys] count]; i++)
        {
            if([[[countDic allKeys] objectAtIndex:i] intValue] > btn.tag && i<[[countDic allKeys] count]-1)
            {
                [countDic setObject:[countDic objectForKey:[NSString stringWithFormat:@"%d",temp_tag+1]]
                             forKey:[NSString stringWithFormat:@"%d",temp_tag]];
                temp_tag++;
                
            }
            else
            if(i==[[countDic allKeys] count]-1 && [[[countDic allKeys] objectAtIndex:i] intValue] > btn.tag)
            {
                [countDic setObject:[countDic objectForKey:[NSString stringWithFormat:@"%d",temp_tag+1]]
                             forKey:[NSString stringWithFormat:@"%d",temp_tag]];
                [countDic removeObjectForKey:[NSString stringWithFormat:@"%d",temp_tag+1]];
            }
            
        }
        
        jianshu=0;
        jiage = 0;
        isJinGeTouch = FALSE;
//        [jingeDic removeAllObjects];
//        [countDic removeAllObjects];
        if([dataMutableArray count] ==0)
        {
            statistical.text = [NSString stringWithFormat:@"共%d件                    %.2f元",jianshu,jiage];
            [self.navigationController popViewControllerAnimated:YES];
        }
        isMinReload = TRUE;
        [okDic removeAllObjects];
        [_tableView reloadData];
    }
    else
    {
        jianshu--;

        [countDic setObject:cell.countLabel.text forKey:[NSString stringWithFormat:@"%d",btn.tag]];
        
        if ([self.storeType isEqualToString:@"水果店"])
        {
            jiage -= [cell.priceLabel.text floatValue];
            statistical.text = [NSString stringWithFormat:@"共%d件                    ",jianshu];

            
        }
        else
        {
            
            NSString *str=[cell.priceLabel.text substringFromIndex:2];
            jiage -= [str floatValue];
            statistical.text = [NSString stringWithFormat:@"共%d件                    %.2f元",jianshu,jiage];
            
        }

        [_tableView setContentOffset:CGPointMake(0,tableYY.origin.y) animated:NO];

    }
   
    
}

//斤按钮
-(void)jinClick:(id)sender
{
    CGRect hh = _tableView.frame;
    hh.size.height = 100000;
    _tableView.frame = hh;
    
    UIButton *btn=(UIButton *)sender;
   
    GoodsTableViewCell *cell;
    if (IOS_VERSION >=7.0) {
        cell=(GoodsTableViewCell *)[[[btn superview] superview]superview];
    }
    else
    {
        cell=(GoodsTableViewCell *)[[btn superview]superview];
    }
   
    [_tableView setContentOffset:CGPointMake(0,tableYY.origin.y) animated:NO];
    
    [cell.jinButton setBackgroundImage:[UIImage imageNamed:@"水果店_切换按钮 (1).png"] forState:UIControlStateNormal];
    [cell.geButton setBackgroundImage:[UIImage imageNamed:@"水果店_切换按钮 (2).png"] forState:UIControlStateNormal];
    
    [jingeDic setObject:@"1" forKey:[NSString stringWithFormat:@"%d",btn.tag]];
    
    isJinGeTouch = TRUE;
    isTouch = TRUE;
    
}
//个按钮
-(void)geClick:(id)sender
{
    CGRect hh = _tableView.frame;
    hh.size.height = 100000;
    _tableView.frame = hh;
    UIButton *btn=(UIButton *)sender;
    GoodsTableViewCell *cell;
    if (IOS_VERSION >= 7.0) {
        cell=(GoodsTableViewCell *)[[[btn superview] superview]superview];
    }
    else
    {
        cell=(GoodsTableViewCell *)[[btn superview]superview];
    }

  
    [_tableView setContentOffset:CGPointMake(0,tableYY.origin.y) animated:NO];
    
    [cell.jinButton setBackgroundImage:[UIImage imageNamed:@"水果店_切换按钮 (6).png"] forState:UIControlStateNormal];
    [cell.geButton setBackgroundImage:[UIImage imageNamed:@"水果店_切换按钮 (5).png"] forState:UIControlStateNormal];
    
    [jingeDic setObject:@"2" forKey:[NSString stringWithFormat:@"%d",btn.tag]];
    isJinGeTouch = TRUE;
    isTouch = TRUE;
}

-(void ) setLeftItem{
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"返回.png"];
    
    backButton.backgroundColor=[UIColor clearColor];
    backButton.frame = CGRectMake(-20, 0, 12, 20);
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton setBackgroundImage: [UIImage imageNamed:@"返回.png"] forState:UIControlStateHighlighted];
    
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
    if (isTouch) {
        UIAlertView *alerty=[[UIAlertView alloc] initWithTitle:nil message:@"离开本页将会取消本页所有操作" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alerty.delegate=self;
        [alerty show];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark -
#pragma  mark - 
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
//对键盘的操作**********************************

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
