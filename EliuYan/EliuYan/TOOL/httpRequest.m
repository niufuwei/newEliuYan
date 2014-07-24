//
//  httpRequest.m
//  ELiuYan
//
//  Created by apple on 14-4-27.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "httpRequest.h"

@implementation httpRequest

//-(void)httpRequestSend:(NSString *)url parameter:(NSString *)parameter backBlock:(void (^)(NSDictionary *))backBlock
//{
//    if(self)
//    {
//        
//        //发送请求
//        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
//        request.delegate=self;
//        NSLog(@"parame===%@",parameter);
//        NSString * key = @"";
//        NSString * value = @"";
//        NSInteger i;
//        BOOL isKey = TRUE;
//        for(i=0;i<[parameter length];i++)
//        {
//            if(![[parameter substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"="] && ![[parameter substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"&"])
//            {
//                if(isKey)
//                {
//                    key = [key stringByAppendingString:[parameter substringWithRange:NSMakeRange(i, 1)]];
//                }
//                else
//                {
//                    value = [value stringByAppendingString:[parameter substringWithRange:NSMakeRange(i, 1)]];
//
//                }
//            }
//            if([[parameter substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"="])
//            {
//                isKey = FALSE;
//            }
//            if([[parameter substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"&"] || i == parameter.length-1)
//            {
//
//                [request addPostValue:value forKey:key];
//                key = @"";
//                value = @"";
//                isKey = TRUE;
//            }
//        }
//        
//        request.timeOutSeconds=60;
//        [request startAsynchronous];
//    }
//}

-(void)httpRequestSend:(NSString *)url parameter:(NSString *)parameter backBlock:(void (^)(NSDictionary *))backBlock{
    
    //异步的POST请求
    //1.创建url
    //2.创建request 用NSMutableURLRequest
    //3.追加数据 setHTTPBody
    //4.设置http方法为POST setHTTPMethod
    //5.创建一个连接initWithRequest  connectionWithRequest delegate传self
    //6.发起异步请求[conn start];
    _myBackBlock = backBlock;
    NSURL *URL = [NSURL URLWithString:url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    
    NSString *urlData =parameter;
    //把字符串转化成data  dataUsingEncoding 指定编码方式
    NSData *tempData = [urlData dataUsingEncoding:NSUTF8StringEncoding];
    
        
    [request setHTTPBody:tempData];
    //POST 请求必须指定    HTTPMethod 为POST 而且POST要大写
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
    //    NSLog(@"接收到响应->\n%@\n%d", [res allHeaderFields], [res statusCode]);
    //
    buffer = [[NSMutableData alloc] init];
    NSLog(@"didReceiveResponse");
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [buffer appendData:data];
    NSLog(@"didReceiveData");

    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error=nil;
    id result=[NSJSONSerialization JSONObjectWithData:buffer options:kNilOptions error:&error];
    NSDictionary *allDict= (NSDictionary *)result;
    _myBackBlock(allDict);
    NSLog(@"connectionDidFinishLoading");

}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"请求错误");
    
    [_httpDelegate httpRequestError:@"出错啦"];
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络断了，请重新连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}


//#pragma mark - 
//#pragma  mark - UIAlertViewDelegate
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex==0) {
//        //加载出错界面
//        
//    }
//}



@end
