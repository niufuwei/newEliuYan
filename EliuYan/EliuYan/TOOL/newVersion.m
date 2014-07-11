//
//  newVersion.m
//  KBwap
//
//  Created by niufuwei on 14-1-16.
//  Copyright (c) 2014年 niufuwei. All rights reserved.
//

#import "newVersion.h"
#import "AppDelegate.h"

@implementation newVersion
{
    //跳转地址
    NSString * trackViewURL;
    
    NSMutableData * buffer;
    NSString * new;
    NSString * oldVersion;
    BOOL  boolNoVewsion;
    AppDelegate * app;
}

-(void)begin:(NSString *)urlStr boolBegin:(BOOL)NoVersion
{
    boolNoVewsion = NoVersion;
    [self httpPostAsynchronousRequest:urlStr];
    
}
-(void)httpPostAsynchronousRequest:(NSString *)urlStr
{
	//异步的POST请求
	//1.创建url
	//2.创建request 用NSMutableURLRequest
	//3.追加数据 setHTTPBody
	//4.设置http方法为POST setHTTPMethod
	//5.创建一个连接initWithRequest  connectionWithRequest delegate传self
	//6.发起异步请求[conn start];
	
	NSURL *url = [NSURL URLWithString:urlStr];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
	//POST 请求必须指定	HTTPMethod 为POST 而且POST要大写
	[request setHTTPMethod:@"POST"];
	
	//NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	NSURLConnection *conn=[NSURLConnection connectionWithRequest:request delegate:self];
	
	[conn start];
	
}

#pragma mark -
#pragma mark http异步请求协议方法 GET/POST处理方式一样

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //    NSHTTPURLResponse *res=(NSHTTPURLResponse *)response;
    //
    //     NSLog(@"接收dddddd到响应->%@",res);
	
	buffer = [[NSMutableData alloc] init];
    
	
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	
	[buffer appendData:data];
	
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
	NSString *info = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
    NSData * data = [info dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError * error;
    NSDictionary * wearthDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error ];
 
    NSArray* infoArray = [wearthDic objectForKey:@"results"];
    if (infoArray.count>0) {
        NSDictionary* releaseInfo =[infoArray objectAtIndex:0];
        new = [releaseInfo objectForKey:@"version"];
        [[NSUserDefaults standardUserDefaults] setObject:new forKey:@"newVersion"];
      
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        oldVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        [[NSUserDefaults standardUserDefaults] setObject:oldVersion forKey:@"oldVersion"];
        
        if(!boolNoVewsion)
        {
            if (![new  isEqualToString:oldVersion])
            {
                trackViewURL = [[NSString alloc] initWithString:[releaseInfo objectForKey:@"trackViewUrl"]];
                [[NSUserDefaults standardUserDefaults] setObject:trackViewURL forKey:@"ConnectUrl"];
                
                NSString* msg =[releaseInfo objectForKey:@"releaseNotes"];

                UIAlertView* alertview =[[UIAlertView alloc] initWithTitle:@"版本升级" message:[NSString stringWithFormat:@"%@%@%@", @"新版本特性:\n",msg, @"\n是否升级？"] delegate:self cancelButtonTitle:@"稍后升级" otherButtonTitles:@"马上升级", nil];
                [alertview show];
            }
            else
            {
                NSLog(@"没有新版本!");
                
            }
        }
        else
        {
            if (![new  isEqualToString:oldVersion])
            {
                trackViewURL = [[NSString alloc] initWithString:[releaseInfo objectForKey:@"trackViewUrl"]];
                [[NSUserDefaults standardUserDefaults] setObject:trackViewURL forKey:@"ConnectUrl"];
                NSString* msg =[releaseInfo objectForKey:@"releaseNotes"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@%@", @"新版本特性:\n",msg] forKey:@"msg"];
                
            }
            else
            {
                trackViewURL = [[NSString alloc] initWithString:[releaseInfo objectForKey:@"trackViewUrl"]];
                [[NSUserDefaults standardUserDefaults] setObject:trackViewURL forKey:@"ConnectUrl"];
                NSString* msg =[releaseInfo objectForKey:@"releaseNotes"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@%@", @"当前版本特性:\n",msg] forKey:@"msg"];
            }
        }
        
        
    }
    
}
-(NSString *)oldVersion
{
    return oldVersion;
}

-(NSString*)new
{
    return new;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:[NSURL URLWithString:trackViewURL]];
    }
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"请求超时。");
    
}
@end
