//
//  httpRequest.h
//  ELiuYan
//
//  Created by apple on 14-4-27.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^backBlock)(NSDictionary *);

@protocol httpRequestDelegate <NSObject>

-(void)httpRequestError:(NSString *)str;

@end

@interface httpRequest : NSObject
<UIAlertViewDelegate,NSURLConnectionDelegate,NSURLConnectionDelegate>


{
    NSMutableData * buffer;
    id<httpRequestDelegate>httDelegate;
    
}

@property (nonatomic,strong)backBlock myBackBlock;
@property (nonatomic,strong)id<httpRequestDelegate>httpDelegate;

-(void)httpRequestSend:(NSString *)url parameter:(NSString *)parameter backBlock:(void(^)(NSDictionary*))backBlock;
@end
