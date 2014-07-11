//
//  PropertyCostViewController.m
//  EliuYan
//
//  Created by laoniu on 14-7-3.
//  Copyright (c) 2014年 eliuyan.com. All rights reserved.
//

#import "PropertyCostViewController.h"
#import "PayCostInforViewController.h"
#import "NavCustom.h"

@interface PropertyCostViewController ()
{
    NavCustom * myNavCustom;
}
@end

@implementation PropertyCostViewController

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
    [appDelegate hidenTabbar];

    //初始化导航条
    myNavCustom = [[NavCustom alloc] init];
    [myNavCustom setNav:@"物业费" mySelf:self];
    
    //加载视图
    [self initView];
    // Do any additional setup after loading the view.
}

-(void)initView
{
    //缴费单位
    UIView * unit = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    [unit setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"缴费 物业费背景.png"]]];
    [self.view addSubview:unit];
    
    UILabel * unitName = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 20)];
    unitName.backgroundColor = [UIColor clearColor];
    unitName.text = @"所在小区";
    unitName.font = [UIFont systemFontOfSize:15];
    unitName.textColor = [UIColor whiteColor];
    [self.view addSubview:unitName];
    
    //单位名字
    UILabel * unitName2 = [[UILabel alloc] initWithFrame:CGRectMake(10, unitName.frame.size.height+unitName.frame.origin.y, self.view.frame.size.width-20, 35)];
    unitName2.backgroundColor = [UIColor clearColor];
    unitName2.text = _CommunityName;
    unitName2.textAlignment = NSTextAlignmentLeft;
    unitName2.font = [UIFont systemFontOfSize:17];
    unitName2.textColor = [UIColor whiteColor];
    [self.view addSubview:unitName2];
    
//    UIImageView * imageHeng = [[UIImageView alloc] initWithFrame:CGRectMake(0, unit.frame.size.height+unit.frame.origin.y, self.view.frame.size.width, 1)];
//    [imageHeng setBackgroundColor:[UIColor blackColor]];
//    [self.view addSubview:imageHeng];
    
    
    //日期
    UIView * date = [[UIView alloc] initWithFrame:CGRectMake(0, unitName2.frame.size.height+unitName2.frame.origin.y, self.view.frame.size.width, 40)];
    [date setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"缴费 物业费背景.png"]]];
    [self.view addSubview:date];

    //何年何月的物业费
    UILabel * PayCostDate = [[UILabel alloc] initWithFrame:CGRectMake(0, unit.frame.size.height+unit.frame.origin.y, self.view.frame.size.width, 40)];
    PayCostDate.backgroundColor = [UIColor clearColor];
    PayCostDate.text = @"2014年1月-6月物业费";
    PayCostDate.textColor =[UIColor whiteColor];
    PayCostDate.textAlignment = NSTextAlignmentCenter;
    PayCostDate.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:PayCostDate];
    
//    UIImageView * imageHeng2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, date.frame.size.height+date.frame.origin.y+1, self.view.frame.size.width, 1)];
//    [imageHeng2 setBackgroundColor:[UIColor blackColor]];
//    [self.view addSubview:imageHeng2];
    
//    UIImageView * imageHeng0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageHeng2.frame.size.height+imageHeng2.frame.origin.y+15-1, self.view.frame.size.width, 1)];
//    [imageHeng0 setBackgroundColor:[UIColor blackColor]];
//    [self.view addSubview:imageHeng0];

    
    //内容
    UIView * infor = [[UIView alloc] initWithFrame:CGRectMake(0, PayCostDate.frame.size.height+PayCostDate.frame.origin.y+15, self.view.frame.size.width, 81)];
    [infor setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:infor];
    
    //户主姓名
    UILabel * username = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 40)];
    username.backgroundColor = [UIColor clearColor];
    username.text = @"户主姓名";
    username.font = [UIFont systemFontOfSize:13];
    [infor addSubview:username];
    
    _userName = [[UITextField alloc] initWithFrame:CGRectMake(username.frame.size.width+username.frame.origin.x+5, 5, 180, 30)];
    _userName.backgroundColor = [UIColor clearColor];
    _userName.placeholder = @"填写户主姓名";
    _userName.font = [UIFont systemFontOfSize:14];
    [infor addSubview:_userName];
    
    UIImageView * imageHeng3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, username.frame.size.height+username.frame.origin.y, self.view.frame.size.width-20, 1)];
    [imageHeng3 setBackgroundColor:[UIColor colorWithRed:219.0/255.0 green:216/255.0 blue:205/255.0 alpha:1]];
    [infor addSubview:imageHeng3];
    
    //证件尾号
    UILabel * number = [[UILabel alloc] initWithFrame:CGRectMake(10, 41, 80, 40)];
    number.backgroundColor = [UIColor clearColor];
    number.text = @"证件尾号";
    number.font = [UIFont systemFontOfSize:13];
    [infor addSubview:number];

    _userNumber = [[UITextField alloc] initWithFrame:CGRectMake(number.frame.size.width+number.frame.origin.x+5, imageHeng3.frame.size.height+imageHeng3.frame.origin.y+5, 180, 30)];
    _userNumber.backgroundColor = [UIColor clearColor];
    _userNumber.placeholder = @"填写户主身份证号码后六位";
    _userNumber.font = [UIFont systemFontOfSize:14];
    [infor addSubview:_userNumber];
    
    UIImageView * imageHeng4 = [[UIImageView alloc] initWithFrame:CGRectMake(10, infor.frame.size.height+infor.frame.origin.y, self.view.frame.size.width-20, 1)];
    [imageHeng4 setBackgroundColor:[UIColor colorWithRed:219.0/255.0 green:216.0/255.0 blue:205.0/255.0 alpha:1]];
    [self.view addSubview:imageHeng4];
    
    UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    nextButton.layer.borderColor = [UIColor grayColor].CGColor;
//    nextButton.layer.borderWidth = 1;
//    [nextButton setBackgroundColor:[UIColor whiteColor]];
    [nextButton.layer setCornerRadius:5];
    nextButton.frame = CGRectMake(30, imageHeng4.frame.size.height+imageHeng4.frame.origin.y+15, self.view.frame.size.width-60, 40);
//    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
//    [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"下一步-未按.png"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"下一步-按住.png"] forState:(UIControlStateHighlighted|UIControlStateSelected)];
    nextButton.adjustsImageWhenHighlighted = NO;
    [nextButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)onClick:(id)sender
{
    PayCostInforViewController * pay = [[PayCostInforViewController alloc] init];
    [self.navigationController pushViewController:pay animated:YES];
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
