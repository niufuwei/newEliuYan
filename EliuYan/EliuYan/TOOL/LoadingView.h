//
//  LoadingView.h
//  ELiuYan
//
//  Created by shanchen on 14-5-2.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView


-(void)changeLabel:(NSString *)str;

- (id)initWithFrame:(CGRect)frame image:(NSString*)image;
@end
