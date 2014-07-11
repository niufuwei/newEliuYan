//
//  FindPswViewController.h
//  ELiuYan
//
//  Created by shanchen on 14-4-23.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "RegistViewController.h"
#import "httpRequest.h"

@interface FindPswViewController : TopViewViewController<UITextFieldDelegate,httpRequestDelegate>
{

    UILabel *_headerLabel;
    UITextField *_numberTF;
    UIImageView *_lineImageView;
    UIButton *_nextBtn;

}
@end
