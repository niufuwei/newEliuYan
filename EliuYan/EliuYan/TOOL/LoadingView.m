//
//  LoadingView.m
//  ELiuYan
//
//  Created by shanchen on 14-5-2.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame image:(NSString*)image
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=eliuyan_color(0xf5f5f5);
        UIImageView *imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
        imageView.frame=CGRectMake(self.frame.size.width/2-40, 60, 80, 80);
        [self addSubview:imageView];
        
    }
    return self;
}


-(void)changeLabel:(NSString *)str
{
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-100, 120, 200, 100)];
    label.textAlignment=NSTextAlignmentCenter;
    //自动折行设置
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 2;
    label.text=str;
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
