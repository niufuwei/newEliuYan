//
//  PayCostInforViewController.m
//  EliuYan
//
//  Created by laoniu on 14-7-4.
//  Copyright (c) 2014年 eliuyan.com. All rights reserved.
//

#import "PayCostInforViewController.h"
#import "NavCustom.h"

@interface PayCostInforViewController ()
{
    NavCustom * myNavCustom;
}

@end

@implementation PayCostInforViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=eliuyan_color(0xf5f5f5);
    //初始化导航条
    myNavCustom = [[NavCustom alloc] init];
    [myNavCustom setNav:@"物业费" mySelf:self];
    
    _dataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"张三",@"户主姓名",@"1321192138",@"户主编号",@"风景蝶院",@"缴费单位",@"1幢2单元",@"单位楼层",@"90平方米",@"单位面积", nil];
    
    [self initHeadView];

    // Do any additional setup after loading the view.
}

-(void)initHeadView
{
    
    UIView * backView = [[UIView alloc] init];
    [backView setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"缴费 物业费背景.png"]]];
    NSInteger yy=0;
    
    for (int i=0l; i< [[_dataDictionary allKeys] count];i++)
    {
        UILabel * left = [[UILabel alloc] initWithFrame:CGRectMake(5, yy+5, 80, 20)];
        left.backgroundColor = [UIColor clearColor];
        left.font = [UIFont systemFontOfSize:14];
        left.textColor =[UIColor whiteColor];
        left.text = [[_dataDictionary allKeys] objectAtIndex:i];
        [backView addSubview:left];
        
        UILabel * right = [[UILabel alloc] initWithFrame:CGRectMake(left.frame.size.width+left.frame.origin.x+5, yy+5, 180, 20)];
        right.backgroundColor = [UIColor clearColor];
        right.font = [UIFont systemFontOfSize:14];
        right.textColor =[UIColor whiteColor];
        right.text =[_dataDictionary objectForKey:[[_dataDictionary allKeys] objectAtIndex:i]];
        [backView addSubview:right];
        
        yy = left.frame.size.height+left.frame.origin.y;
    }
    
    UIImageView  * imageHeng = [[UIImageView alloc] initWithFrame:CGRectMake(0, yy+5, self.view.frame.size.width, 1)];
    [imageHeng setBackgroundColor:[UIColor clearColor]];
    [backView addSubview:imageHeng];
    
    UILabel * money = [[UILabel alloc] initWithFrame:CGRectMake(5, imageHeng.frame.size.height+imageHeng.frame.origin.y+10, self.view.frame.size.width, 20)];
    money.backgroundColor = [UIColor clearColor];
    money.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:17];
    money.textColor =[UIColor whiteColor];
    money.text = @"应缴费:";
    [backView addSubview:money];
    
    UILabel * money2 = [[UILabel alloc] initWithFrame:CGRectMake(90, imageHeng.frame.size.height+imageHeng.frame.origin.y, 130, 40)];
    money2.backgroundColor = [UIColor clearColor];
    money2.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:18];
    money2.textColor =[UIColor whiteColor];
    money.textAlignment = NSTextAlignmentLeft;
    money2.text = @"736.00";
    [backView addSubview:money2];
   
    UIImageView  * imageHeng2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageHeng.frame.size.height+imageHeng.frame.origin.y+40,self.view.frame.size.width, 1)];
    [imageHeng2 setBackgroundColor:[UIColor clearColor]];
    [backView addSubview:imageHeng2];

    backView.frame =CGRectMake(0, 0, self.view.frame.size.width, imageHeng2.frame.size.height+imageHeng2.frame.origin.y);

    [self.view addSubview:backView];
    
    //立即缴费
    UIButton * PayCost = [UIButton buttonWithType:UIButtonTypeCustom];
//    PayCost.layer.borderColor = [UIColor grayColor].CGColor;
//    PayCost.layer.borderWidth = 1;
//    [PayCost setBackgroundColor:[UIColor whiteColor]];
//    [PayCost.layer setCornerRadius:5];
    PayCost.frame = CGRectMake(30, backView.frame.size.height+backView.frame.origin.y+20, self.view.frame.size.width-60, 40);
    [PayCost setBackgroundImage:[UIImage imageNamed:@"立即缴费-未按.png"] forState:UIControlStateNormal];
    [PayCost setBackgroundImage:[UIImage imageNamed:@"立即缴费-按住.png"] forState:(UIControlStateHighlighted|UIControlStateSelected)];
    PayCost.adjustsImageWhenHighlighted = NO;
//    [PayCost setTitle:@"立即缴费" forState:UIControlStateNormal];
//    [PayCost setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [PayCost addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:PayCost];
}

-(void)onClick:(id)sender
{
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
