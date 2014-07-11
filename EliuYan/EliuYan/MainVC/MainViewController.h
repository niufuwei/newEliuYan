//
//  MainViewController.h
//  ELiuYan
//
//  Created by shanchen on 14-4-21.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCTopic.h"


@interface MainViewController : UIViewController
<UIAlertViewDelegate,UIScrollViewDelegate,JCTopicDelegate,ASIHTTPRequestDelegate>
{
     NSString *_trackURL;
    NSString *_activityID;
    NSString *_activityUrl;
    Activity *myActivity;
    NSString *_titleName;
    
    NSMutableArray *_urlArray;
    NSMutableArray *_activityIdArray;
    NSMutableArray *_titleArray;
    
}
@property (nonatomic,strong) JCTopic * Topic;
@end
