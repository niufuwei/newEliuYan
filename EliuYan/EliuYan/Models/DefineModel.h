//
//  DefineModel.h
//  ELiuYan
//
//  Created by shanchen on 14-4-22.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#ifndef ELiuYan_DefineModel_h
#define ELiuYan_DefineModel_h

//导航条背景色
#define eliuyan_header_background_color [UIColor colorWithRed:35/255.0 green:35/255.0 blue:35/255.0 alpha:1.0]
//导航条高度
#define eliuyan_header_height 76
//方正黑体简体字体定义
#define eliuyan_text_font(f) [UIFont fontWithName:@"FZHTJW--GB1-0" size:f]
//需要转换的颜色
#define eliuyan_color(rgbValue)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
/////第一次请求最近订单的orderId
#define OrderID @"00000000-0000-0000-0000-000000000000"


///////////////////////////////////
//正式服务器
#define SERVICE_ADD @"http://www.chaoyongwenhua.com:8081/eliuyanserviceNew/ely/"
#define aboutUsHtml @"http://www.chaoyongwenhua.com:9999/Protocol/eliuyanProtocol.html"
#define UPLOAD_FILE  @"http://www.chaoyongwenhua.com:9999/UploadAudio.ashx"
#define DOWNLOAD_FILE @"http://www.chaoyongwenhua.com:9999"


//测试服务器
//#define SERVICE_ADD @"http://192.168.18.159:8081/eliuyanservice/ely/"
//#define aboutUsHtml @"http://192.168.18.159:9999/Protocol/eliuyanProtocol.html"
//#define UPLOAD_FILE  @"http://192.168.18.159:9999/UploadAudio.ashx"
//#define DOWNLOAD_FILE @"http://192.168.18.159:9999"


///////////////////////////////////
#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#endif
