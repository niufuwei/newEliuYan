//
//  DeliveryInformationViewController.h
//  ELiuYan
//
//  Created by laoniu on 14-5-1.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "httpRequest.h"

@interface DeliveryInformationViewController : UIViewController<UITextViewDelegate,httpRequestDelegate,ASIHTTPRequestDelegate>

{
    NSString *json;
    
    NSString *_returnValue;
    NSString *_adress;
    
}


@property (nonatomic,strong) UITextField *phoneField;
@property (nonatomic,strong) UITextField * nameField;
@property (nonatomic,strong) __block UITextView * addressText;

@end
