//
//  checkViewController.m
//  EliuYan
//
//  Created by laoniu on 14-7-7.
//  Copyright (c) 2014年 eliuyan.com. All rights reserved.
//

#import "checkViewController.h"
#import "ContentCell.h"
#import "DeliveryInformationViewController.h"

@interface checkViewController ()
{
    NSString * strDescriptonType ;      //type=1 文字  2 语音
    BOOL _isTouch;
}
@end

@implementation checkViewController
@synthesize myTable;
#define WAVE_UPDATE_FREQUENCY   0.05

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
    if([_Message.text length]==0)
    {
        [disTextPlaceHolder setHidden:NO];
    }
    [_conFirm setEnabled:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=eliuyan_color(0xf5f5f5);
    
    
    //初始化实用变量
    strDescriptonType = @"1";
    _isTouch = FALSE;
    isMinReload=  FALSE;
    _dataMutableArray = [[NSMutableArray alloc] initWithArray:[_contentDictionary objectForKey:@"data"]];
    mCountService = [[_contentDictionary objectForKey:@"service"] floatValue];
    
    NavCustom *nav=[[NavCustom alloc] init];
    [nav setNav:@"收银台" mySelf:self];
    
    myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-20-98)];
    myTable.delegate = self;
    myTable.dataSource =self;
    [self setExtraCellLineHidden:myTable];
    [self.view addSubview:myTable];
    
    //默认文字输入
    _isVideo = TRUE;
    
    //初始化底部视图
    [self initButtomView];
    
    //默认为未录音状态
    _recording = FALSE;
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/downloadFile.caf"];
    _tmpFile = [[NSURL alloc] initFileURLWithPath:path];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataMutableArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strID = @"cell";
    ContentCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if(cell==nil)
    {
        cell = [[ContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
    }
    
    cell.title.frame= CGRectMake(cell.logoImage.frame.size.width+cell.logoImage.frame.origin.x+5, 15, 180, 40);
    cell.selectButton.frame = CGRectMake(self.view.frame.size.width -50, 30, 30, 30);
    
    [cell.logoImage setImageWithURL:[NSURL URLWithString:[[_dataMutableArray objectAtIndex:indexPath.row] objectForKey:@"Image"]] placeholderImage:[UIImage imageNamed:@"无图.png"]];
    cell.title.text = [[_dataMutableArray objectAtIndex:indexPath.row] objectForKey:@"GoodsName"];
    cell.money.text = [[_dataMutableArray objectAtIndex:indexPath.row] objectForKey:@"Price"];
    cell.selectButton.tag = indexPath.row+1;
    [cell.selectButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
  
    [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"多选-选择.png"] forState:UIControlStateNormal];
 
  
    return cell;
}

#pragma mark -- 
#pragma mark uialertview的协议方法

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag ==101)
    {
        if(buttonIndex == 0){
            
            mCountService --;
            if(mCountService<=0)
            {
                Price.text = @"";
                numberPrice.hidden = YES;
                numberService.hidden = YES;
                numberService.text = [NSString stringWithFormat:@"%d项服务",mCountService];
                mCountService =0;
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else
            {
                Price.text = [NSString stringWithFormat:@"%.2f",[Price.text floatValue] -[[[_dataMutableArray objectAtIndex:currentRow] objectForKey:@"Price"] floatValue]];
                numberPrice.hidden = NO;
                numberService.hidden = NO;
                numberService.text = [NSString stringWithFormat:@"%d项服务",mCountService];
                
                [_dataMutableArray removeObjectAtIndex:currentRow];
                [myTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:currentRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                [myTable reloadData];
            }

        }
    }
}

//单元格返回的编辑风格，包括删除 添加 和 默认  和不可编辑三种风格
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentRow = indexPath.row;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"您确定要删除这一项服务吗?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"点错了", nil];
    alert.tag = 101;
    [alert show];
}


#pragma mark --
#pragma mark 选择按钮
-(void)selectButton:(id)sender
{
    UIButton * btn = (UIButton*)sender;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"您确定要删除这一项服务吗?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"点错了", nil];
    alert.tag = 101;
    [alert show];
    currentRow = btn.tag -1;
}

//秒数计算
-(void)timerFired
{
    addCount++;
}

#pragma mark --
#pragma mark 初始化底部视图
-(void)initButtomView
{
    
    //加载底部视图
    if (IOS_VERSION>=7.0) {
        _ButtomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-98-self.navigationController.navigationBar.frame.size.height-20, 320, 98)];
    }
    else
    {
        _ButtomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-98-self.navigationController.navigationBar.frame.size.height , 320, 98)];
    }
    
    _ButtomView.backgroundColor=eliuyan_color(0xf5f5f5);
    [self.view addSubview:_ButtomView];
    
    
    UIImageView * imageHeng = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    [imageHeng setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:184.0/255.0 blue:176.0/255.0 alpha:1]];
    [_ButtomView addSubview:imageHeng];
    
    //初始化录音和输入文字切换按钮
    _Video_OR_input_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    _Video_OR_input_Button.frame = CGRectMake(10, 7, 40, 35);
    [_Video_OR_input_Button setBackgroundImage:[UIImage imageNamed:@"收银台_语音键-未按.png"] forState:UIControlStateNormal];
    [_Video_OR_input_Button setBackgroundImage:[UIImage imageNamed:@"收银台_语音键-按住.png"]  forState:UIControlStateHighlighted];
    
    [_Video_OR_input_Button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    _Video_OR_input_Button.tag = 101;
    [_ButtomView addSubview:_Video_OR_input_Button];
    
    UIImageView * imageHeng2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, 320, 1)];
    [imageHeng2 setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:184.0/255.0 blue:176.0/255.0 alpha:1]];
    [_ButtomView addSubview:imageHeng2];
    
    
    //初始化文字输入框
    _Message = [[UITextView alloc] initWithFrame:CGRectMake(_Video_OR_input_Button.frame.size.width+_Video_OR_input_Button.frame.origin.x+10, 1, 320-_Video_OR_input_Button.frame.origin.x-_Video_OR_input_Button.frame.size.width-20, 48)];
    _Message.font = [UIFont systemFontOfSize:14];
    _Message.textColor =eliuyan_color(0x404040);
    _Message.backgroundColor = [UIColor clearColor];
    _Message.delegate = self;
    _Message.returnKeyType = UIReturnKeyDone;
    [_ButtomView addSubview:_Message];
    
    disTextPlaceHolder = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, _Message.frame.size.width, 15)];
    disTextPlaceHolder.textAlignment = NSTextAlignmentCenter;
    disTextPlaceHolder.text = @"捎些话(100个字以内)";
    disTextPlaceHolder.backgroundColor = [UIColor clearColor];
    disTextPlaceHolder.textColor = [UIColor grayColor];
    [_Message addSubview:disTextPlaceHolder];
    
    UIImageView * lableHeng = [[UIImageView alloc] initWithFrame:CGRectMake(45, disTextPlaceHolder.frame.size.height, disTextPlaceHolder.frame.size.width-90, 1)];
    [lableHeng setBackgroundColor: [UIColor grayColor]];
    [disTextPlaceHolder addSubview:lableHeng];
    
    //初始化语音按钮
    _VideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _VideoButton.frame = CGRectMake(_Video_OR_input_Button.frame.size.width+_Video_OR_input_Button.frame.origin.x+10, 7, 320-_Video_OR_input_Button.frame.origin.x-_Video_OR_input_Button.frame.size.width-20, 35);
    [_VideoButton setBackgroundImage:[UIImage imageNamed:@"收银台_语音-未按.png"] forState:UIControlStateNormal];
    [_VideoButton setBackgroundImage:[UIImage imageNamed:@"收银台_语音-按住.png"] forState:UIControlStateHighlighted];
    [_VideoButton setHidden:YES];
    [_VideoButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchDown];
    [_VideoButton addTarget:self action:@selector(onClickRepeat:) forControlEvents:UIControlEventTouchUpInside];
    _VideoButton.tag = 102;
    [_ButtomView addSubview:_VideoButton];
    
   
    
    //购买的服务个数
    numberService = [[UILabel alloc] initWithFrame:CGRectMake(10, 54, 90, 40)];
    numberService.backgroundColor = [UIColor clearColor];
    numberService.textAlignment = NSTextAlignmentCenter;
    numberService.textAlignment = NSTextAlignmentLeft;
    numberService.text = [NSString stringWithFormat:@"%@项服务",[_contentDictionary objectForKey:@"service"]];
    numberService.textColor =[UIColor colorWithRed:233.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1];
    [_ButtomView addSubview:numberService];
    
    //购买的价格
    numberPrice = [[UILabel alloc] initWithFrame:CGRectMake(numberService.frame.size.width+numberService.frame.origin.x+5, 54, 150, 40)];
    numberPrice.backgroundColor = [UIColor clearColor];
    numberPrice.textAlignment = NSTextAlignmentCenter;
    numberPrice.textAlignment = NSTextAlignmentLeft;
    numberPrice.text = @"共                 元";
    numberPrice.textColor = [UIColor colorWithRed:233.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1];
    [_ButtomView addSubview:numberPrice];
    
    //购买的价格2222
    Price = [[UILabel alloc] initWithFrame:CGRectMake(numberService.frame.size.width+numberService.frame.origin.x+40, 54, 110, 40)];
    Price.backgroundColor = [UIColor clearColor];
    Price.textAlignment = NSTextAlignmentCenter;
    Price.textAlignment = NSTextAlignmentLeft;
    Price.text =  [_contentDictionary objectForKey:@"price"];
    Price.textColor =[UIColor colorWithRed:233.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1];
    [_ButtomView addSubview:Price];
    
    
    //初始化确认下单按钮
    _conFirm = [UIButton buttonWithType:UIButtonTypeCustom];
    _conFirm.frame = CGRectMake(320-100+10+10, 10+49, 70, 30);
    [_conFirm setBackgroundColor:[UIColor colorWithRed:233.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1]];
    _conFirm.titleLabel.font=[UIFont systemFontOfSize:15];
    [_conFirm setTitle:@"下一步" forState:UIControlStateNormal];
    [_conFirm setTintColor:[UIColor whiteColor]];
    _conFirm.tag=104;
    [_conFirm addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_ButtomView addSubview:_conFirm];
    
    //初始化语音按钮
    _VideoButtonPlayed = [UIButton buttonWithType:UIButtonTypeCustom];
    _VideoButtonPlayed.frame = CGRectMake(_Video_OR_input_Button.frame.size.width+_Video_OR_input_Button.frame.origin.x+10, 7, 320-_Video_OR_input_Button.frame.origin.x-_Video_OR_input_Button.frame.size.width-20, 35);
    _VideoButtonPlayed.layer.borderColor = [UIColor colorWithRed:248.0/255.0 green:145.0/255.0 blue:148.0/255.0 alpha:1].CGColor;
    _VideoButtonPlayed.layer.borderWidth =1;
    [_VideoButtonPlayed setHidden:YES];
    [_VideoButtonPlayed addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_VideoButtonPlayed setBackgroundColor:[UIColor clearColor]];
    
    _VideoButtonPlayed.tag = 103;
    
    UILongPressGestureRecognizer *longGnizer=nil;
    longGnizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self
                                                            action:@selector(longPressToDo:)];
    longGnizer.minimumPressDuration = 2.0;
    [_VideoButtonPlayed addGestureRecognizer:longGnizer];
    
    [_ButtomView addSubview:_VideoButtonPlayed];
    
    //初始化一次
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        [_VideoButtonPlayed setHidden:YES];
        [_VideoButton setHidden:NO];
        [_VideoButton setImage:[UIImage imageNamed:@"收银台_语音-按住.png"] forState:UIControlStateNormal];
        [self startRecord];
        
        
    }
    if(gesture.state == UIGestureRecognizerStateEnded)
    {
        //录音结束
        [_VideoButton setImage:[UIImage imageNamed:@"tm.png"] forState:UIControlStateNormal];
        [self onClickRepeat:nil];
        
    }
}

-(IBAction)onClick:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    switch (btn.tag) {
        case 101:
        {
            if(_isVideo)
            {
                [_Video_OR_input_Button setBackgroundImage:[UIImage imageNamed:@"收银台_键盘键-未按.png"] forState:UIControlStateNormal];
                [_Video_OR_input_Button setBackgroundImage:[UIImage imageNamed:@"收银台_键盘键-按住.png"] forState:UIControlStateHighlighted];
                [_VideoButton setHidden:NO];
                [_Message setHidden:YES];
                _isVideo = FALSE;
                [self.view endEditing:YES];
                strDescriptonType= @"2";
            }
            else
            {
                [_Video_OR_input_Button setBackgroundImage:[UIImage imageNamed:@"收银台_语音键-未按.png"] forState:UIControlStateNormal];
                [_Video_OR_input_Button setBackgroundImage:[UIImage imageNamed:@"收银台_语音键-按住.png"] forState:UIControlStateHighlighted];
                [_VideoButton setHidden:YES];
                [_VideoButtonPlayed setHidden:YES];
                [_Message setHidden:NO];
                _isVideo = TRUE;
                strDescriptonType = @"1";
                if([_Message.text length]==0)
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
            if([_audioPlayer isPlaying])
            {
                
            }
            else
            {
                [_audioPlayer play];
                self.minCount = 1;
                
                minTimer =[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(minmCount)userInfo:nil repeats:YES];
                [minTimer fire];
            }
        }
            break;
        case 104://确认下单
            
            //判断
            
        {
            
            [_conFirm setEnabled:NO];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
            
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",mCountService] forKey:@"GoodsCount"];
            
            [[NSUserDefaults standardUserDefaults] setObject:Price.text forKey:@"OrderPrice"];
            
            [[NSUserDefaults standardUserDefaults] setObject:strDescriptonType forKey:@"DescriptonType"];
            
            //打包
            
            NSMutableArray * allarr =[[NSMutableArray alloc] init];
            
            for(int i=0 ;i<[_dataMutableArray count];i++)
            {
                NSMutableDictionary *  dic = [[NSMutableDictionary alloc] initWithDictionary:[_dataMutableArray objectAtIndex:i]];
                NSMutableDictionary * allDic = [[NSMutableDictionary alloc] init];
                
            
                
                
                [allDic setObject:[dic objectForKey:@"Id"] forKey:@"GoodId"];
                [allDic setObject:[dic objectForKey:@"GoodsName"] forKey:@"GoodsName"];
                
                
                [allDic setObject:[dic objectForKey:@"Price"] forKey:@"Price"];
                
                
                /////////////
                
                //截取字符串
                NSRange range = [[dic objectForKey:@"Image"] rangeOfString:@"/"];
                NSString *image = [[dic objectForKey:@"Image"] substringFromIndex:range.location + range.length];//开始截取
                
                NSRange range1 = [image rangeOfString:@"/"];
                NSString *image1 = [image substringFromIndex:range1.location + range1.length];//开始截取
                
                NSRange range2 = [image1 rangeOfString:@"/"];
                NSString *image2 = [image1 substringFromIndex:range2.location + range2.length];//开始截取
                
                
                NSString *image3=[NSString stringWithFormat:@"/%@",image2];
                
                
                ///////////////////
                
                
                [allDic setObject:[dic objectForKey:@"Price"] forKey:@"Price"];
                [allDic setObject:image3 forKey:@"Image"];
                
                
                
                [allDic setObject:@"1" forKey:@"GoodsCount"];
                
                [allarr addObject:allDic];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:allarr forKey:@"GoodsList"];
            
            if([strDescriptonType isEqualToString:@"1"])
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"DescriptonType"];
                [[NSUserDefaults standardUserDefaults] setObject:_Message.text forKey:@"Descripton"];
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
    
    _audioSession = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [_audioSession setCategory:AVAudioSessionCategoryRecord error:&sessionError];
    if(_audioSession ==nil)
    {
        NSLog(@"Error:%@",sessionError);
    }
    else
    {
        [_audioSession setActive:YES error:nil];
        
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
    
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:_tmpFile settings:settings error:nil];
    _recorder.delegate = self;
    [_recorder prepareToRecord];
    _recorder.meteringEnabled = YES;
    [_recorder record];
    
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
        
        if (_recorder) {
            [_recorder updateMeters];
        }
        
        float peakPower = [_recorder averagePowerForChannel:0];
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
    
    [_conFirm setEnabled:YES];
    
    [ac stop];
    [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"DescriptonType"];
    [[NSUserDefaults standardUserDefaults] setObject:request.responseString forKey:@"Descripton"];
    //进入下单界面
    DeliveryInformationViewController *delivery=[[DeliveryInformationViewController alloc] init];
    [self.navigationController pushViewController:delivery animated:YES];
    
    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    [ac stop];
    [_conFirm setEnabled:YES];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"语音上传失败，请重新上传" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
}


-(void)minmCount
{
    if(self.minCount < addCount || self.minCount == addCount)
    {
        [_VideoButtonPlayed setTitle:[NSString stringWithFormat:@"播放 %d'",self.minCount] forState:UIControlStateNormal];
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
    
    [_VideoButtonPlayed setHidden:NO];
    [_VideoButton setHidden:YES];
    _recording = NO;
    [_audioSession setActive:NO error:nil];
    [_recorder stop];
    [self audio_PCMtoMP3];
    if(_recorder)
    {
        _recorder = nil;
    }
    
    [_VideoButtonPlayed setTitle:[NSString stringWithFormat:@"播放 %d'",addCount] forState:UIControlStateNormal];
    [_VideoButtonPlayed setTitleColor:[UIColor colorWithRed:245.0/255.0 green:45.0/255.0 blue:56.0/255.0 alpha:1] forState:UIControlStateNormal];
    
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
        _ButtomView.frame = CGRectMake(0, self.view.frame.size.height-98-216, 320, 98);
    } completion:^(BOOL finished) {
        
    }];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
        _ButtomView.frame = CGRectMake(0, self.view.frame.size.height-98, 320, 98);
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
        _ButtomView.frame = CGRectMake(0, self.view.frame.size.height-98, 320, 98);
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
        _ButtomView.frame = CGRectMake(0, self.view.frame.size.height-98-keyboardSize.height, 320, 98);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];

    CGRect hh = myTable.frame;
    hh.size.height = self.view.frame.size.height-98;
    myTable.frame = hh;
    
    if(isMinReload)
    {
        [myTable setContentOffset:CGPointMake(0,tableYY.origin.y+110) animated:NO];
        
    }
    [_Message resignFirstResponder];

    isMinReload = FALSE;
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
