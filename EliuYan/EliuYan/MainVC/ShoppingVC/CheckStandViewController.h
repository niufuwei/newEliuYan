//
//  CheckStandViewController.h
//  ELiuYan
//
//  Created by laoniu on 14-4-30.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "ASIFormDataRequest.h"

@interface CheckStandViewController : UIViewController<UITextViewDelegate,AVAudioPlayerDelegate,AVAudioSessionDelegate,AVAudioRecorderDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,ASIHTTPRequestDelegate>
{
    NSInteger addCount;     //用来记录录音时间
    NSTimer * addTimer;     //录音时间定时器
    NSTimer * minTimer;     //播放录音定时器
    
    UITableView *_tableView;    //table
    UILabel * statistical;      //价格和件数，底部视图
    UILabel * disTextPlaceHolder;//文字备忘录
    CGRect tableYY;
    
    BOOL isMinReload;
    
    
}

@property(nonatomic) float recordTime;
@property (nonatomic,strong) UIButton * VideoButton;
@property (nonatomic,strong) UIButton * VideoButtonPlayed;
@property (nonatomic,strong) UIButton * Video_OR_input_Button;
@property (nonatomic,assign) BOOL isVideo;
@property (nonatomic,strong) UITextView * Message;
@property (nonatomic,strong) UIView * ButtomView;
@property (nonatomic,strong) AVAudioRecorder * recorder;
@property (nonatomic,strong) AVAudioPlayer * audioPlayer;
@property (nonatomic) BOOL recording;
@property (nonatomic,strong) NSURL * tmpFile;
@property (nonatomic,strong)AVAudioSession * audioSession;
@property (nonatomic) NSInteger minCount;

@property (nonatomic,strong) NSMutableArray * dataMutableArray;
@property(nonatomic,copy)NSString *storeType;

@end
