//
//  OrderSuccessfulViewController.m
//  ELiuYan
//
//  Created by laoniu on 14-5-1.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "OrderSuccessfulViewController.h"
#import "AppDelegate.h"

@interface OrderSuccessfulViewController ()
{
    NavCustom * navC;
}
@end

@implementation OrderSuccessfulViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [appDelegate hidenTabbar];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=eliuyan_color(0xf5f5f5);

    
    //头部视图
    UIImageView * imageHead = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 83)] autorelease];
    imageHead.image = [UIImage imageNamed:@"等待送货 下单完成背景.png"];
    [self.view addSubview:imageHead];
    
    //对号 √
    UIImageView * OKImage = [[[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 43, 43)] autorelease];
    [OKImage setImage:[UIImage imageNamed:@"切图_116.png"]];
    [imageHead addSubview:OKImage];
    
    UILabel * headTitle = [[[UILabel alloc] initWithFrame:CGRectMake(OKImage.frame.size.width+OKImage.frame.origin.x+15, 10, 220, 25)] autorelease];
    headTitle.text = @"恭喜您下单成功!";
    headTitle.backgroundColor=[UIColor clearColor];
    headTitle.textColor = eliuyan_color(0xffffff);
    headTitle.font = [UIFont systemFontOfSize:19];
    [self.view addSubview:headTitle];
    
    UILabel * buttomTitle = [[[UILabel alloc] initWithFrame:CGRectMake(OKImage.frame.size.width+OKImage.frame.origin.x+15+5, headTitle.frame.size.height+headTitle.frame.origin.y, 200, 40)] autorelease];
    buttomTitle.text = @"若商家未对订单作响应，请及时与商家联系";
    buttomTitle.backgroundColor=[UIColor clearColor];
    buttomTitle.textColor = eliuyan_color(0xffffff);
    buttomTitle.numberOfLines = 2;

    buttomTitle.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:buttomTitle];
    
    
//    //初始化联系店铺
//    UILabel * Contact = [[[UILabel alloc] initWithFrame:CGRectMake(15, imageHead.frame.size.height+imageHead.frame.origin.y+19, 100, 20)]autorelease];
//    Contact.text = @"联系店铺";
//    Contact.textColor = eliuyan_color(0x404040);
//    Contact.font = [UIFont systemFontOfSize:17];
//    Contact.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:Contact];
//    
//    //初始化店铺名称
//    
//    UILabel * shopName = [[[UILabel alloc] initWithFrame:CGRectMake(15, Contact.frame.size.height+Contact.frame.origin.y+7, 80, 20)]autorelease];
//    shopName.text = @"店铺名称";
//    shopName.textColor = eliuyan_color(0xababaa);
//    shopName.font = [UIFont systemFontOfSize:14];
//    shopName.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:shopName];
    
    UILabel * shopNameInput = [[[UILabel alloc] initWithFrame:CGRectMake(15, imageHead.frame.size.height+imageHead.frame.origin.y+10, self.view.frame.size.width-20, 20)]autorelease];
    shopNameInput.text = [[NSUserDefaults standardUserDefaults ] objectForKey:@"StoreName"];
    shopNameInput.textColor = eliuyan_color(0x404040);
    shopNameInput.font = [UIFont systemFontOfSize:17];
    shopNameInput.backgroundColor = [UIColor clearColor];
    [self.view addSubview:shopNameInput];
    
    NSInteger yy =0;
    //初始化店铺描述
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"StoreDescription"] isEqualToString:@"--"])
    {
        UILabel * shopDescription = [[[UILabel alloc] initWithFrame:CGRectMake(15, shopNameInput.frame.size.height+shopNameInput.frame.origin.y + 5, 200, 20)]autorelease];
        shopDescription.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"StoreDescription"];
        shopDescription.textColor = eliuyan_color(0x404040);
        shopDescription.font = [UIFont systemFontOfSize:17];
        shopDescription.backgroundColor = [UIColor clearColor];
        [self.view addSubview:shopDescription];
        
        yy =shopDescription.frame.size.height+shopDescription.frame.origin.y + 10;
    }
    else
    {
        yy = shopNameInput.frame.size.height+shopNameInput.frame.origin.y + 10;

    }
    
    UILabel * shopNumberInput = [[[UILabel alloc] initWithFrame:CGRectMake(15, yy, 100, 20)]autorelease];
    shopNumberInput.text =[[NSUserDefaults standardUserDefaults ] objectForKey:@"shopPhone"];
    shopNumberInput.textColor = eliuyan_color(0x404040);
    shopNumberInput.font = [UIFont systemFontOfSize:15];
    shopNumberInput.backgroundColor = [UIColor clearColor];
    [self.view addSubview:shopNumberInput];
    
    UIButton * ContactShop = [UIButton buttonWithType:UIButtonTypeCustom];
    [ContactShop setBackgroundImage:[UIImage imageNamed:@"电话拨号.png"] forState:UIControlStateNormal];
    [ContactShop setBackgroundImage:[UIImage imageNamed:@"电话拨号-按住.png"] forState:UIControlStateHighlighted];
    ContactShop.frame = CGRectMake(120, shopNumberInput.frame.origin.y, 85 , 20);
    [ContactShop addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ContactShop];
    
    
    UIImageView * imageHeng2 = [[[UIImageView alloc] initWithFrame:CGRectMake(15, shopNumberInput.frame.size.height+shopNumberInput.frame.origin.y+ 10, 290, 1)]autorelease];
    [imageHeng2 setBackgroundColor:[UIColor colorWithRed:218.0/255.0 green:217.0/255.0 blue:205.0/255.0 alpha:1]];
    [self.view addSubview:imageHeng2];
    
    
    
    
    
    
//    //初始化订单信息
//    UILabel * orderInfor = [[[UILabel alloc] initWithFrame:CGRectMake(15, imageHeng2.frame.size.height+imageHeng2.frame.origin.y+13, 100, 20)] autorelease];
//    orderInfor.text = @"订单信息";
//    orderInfor.textColor = eliuyan_color(0x404040);
//    orderInfor.font = [UIFont systemFontOfSize:17];
//    orderInfor.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:orderInfor];
    
    //初始化订单编号
    UILabel * orderNumber = [[[UILabel alloc] initWithFrame:CGRectMake(15, imageHeng2.frame.size.height+imageHeng2.frame.origin.y+7, 80, 20)]autorelease];
    orderNumber.text = @"订单编号";
    orderNumber.textColor = eliuyan_color(0xababaa);
    orderNumber.font = [UIFont systemFontOfSize:14];
    orderNumber.backgroundColor = [UIColor clearColor];
    [self.view addSubview:orderNumber];

    UILabel * orderNumberInput = [[[UILabel alloc] initWithFrame:CGRectMake(orderNumber.frame.size.width+orderNumber.frame.origin.x+10, imageHeng2.frame.size.height+imageHeng2.frame.origin.y+7, 200, 20)]autorelease];
    orderNumberInput.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"OrderNumber"];
    orderNumberInput.textColor = eliuyan_color(0x404040);
    orderNumberInput.font = [UIFont systemFontOfSize:14];
    orderNumberInput.backgroundColor = [UIColor clearColor];
    [self.view addSubview:orderNumberInput];
    
    //初始化下单金额
    UILabel * orderMoney = [[[UILabel alloc] initWithFrame:CGRectMake(15, orderNumber.frame.size.height+orderNumber.frame.origin.y, 80, 20)]autorelease];
    orderMoney.text = @"订单信息";
    orderMoney.textColor = eliuyan_color(0xababaa);
    orderMoney.font = [UIFont systemFontOfSize:14];
    orderMoney.backgroundColor = [UIColor clearColor];
    [self.view addSubview:orderMoney];
    
    UILabel * orderMoneyInput = [[[UILabel alloc] initWithFrame:CGRectMake(orderMoney.frame.size.width+orderMoney.frame.origin.x+10, orderNumber.frame.size.height+orderNumber.frame.origin.y, 200, 20)]autorelease];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"storeTypeName"] isEqualToString:@"水果店"]) {
        orderMoneyInput.text = @"——";
    }
    else
    {
        orderMoneyInput.text = [NSString stringWithFormat:@"%@元",[[NSUserDefaults standardUserDefaults] objectForKey:@"OrderPrice"]];
    }
    orderMoneyInput.textColor = eliuyan_color(0x404040);
    orderMoneyInput.font = [UIFont systemFontOfSize:14];
    orderMoneyInput.backgroundColor = [UIColor clearColor];
    [self.view addSubview:orderMoneyInput];
    
    //初始化购买数量
    UILabel * num = [[[UILabel alloc] initWithFrame:CGRectMake(15, orderMoney.frame.size.height+orderMoney.frame.origin.y, 80, 20)]autorelease];
    num.text = @"购买数量";
    num.textColor = eliuyan_color(0xababaa);
    num.font = [UIFont systemFontOfSize:14];
    num.backgroundColor = [UIColor clearColor];
    [self.view addSubview:num];
    
    UILabel * numInput = [[[UILabel alloc] initWithFrame:CGRectMake(num.frame.size.width+num.frame.origin.x+10, orderMoney.frame.size.height+orderMoney.frame.origin.y, 200, 20)]autorelease];
    numInput.text =[NSString stringWithFormat:@"%@件",[[NSUserDefaults standardUserDefaults] objectForKey:@"GoodsCount"]];
    numInput.textColor = eliuyan_color(0x404040);
    numInput.font = [UIFont systemFontOfSize:14];
    numInput.backgroundColor = [UIColor clearColor];
    [self.view addSubview:numInput];
    
    
    
    //初始化送货方式
    UILabel * deliveryWay = [[[UILabel alloc] initWithFrame:CGRectMake(15, num.frame.size.height+num.frame.origin.y, 80, 20)]autorelease];
    deliveryWay.text = @"付款方式";
    deliveryWay.textColor = eliuyan_color(0xababaa);
    deliveryWay.font = [UIFont systemFontOfSize:14];
    deliveryWay.backgroundColor = [UIColor clearColor];
    [self.view addSubview:deliveryWay];
    
    UILabel * deliveryWayInput = [[[UILabel alloc] initWithFrame:CGRectMake(deliveryWay.frame.size.width+deliveryWay.frame.origin.x+10, numInput.frame.size.height+numInput.frame.origin.y, 200, 20)]autorelease];
    deliveryWayInput.text =@"货到付款";
    deliveryWayInput.textColor = eliuyan_color(0x404040);
    deliveryWayInput.font = [UIFont systemFontOfSize:14];
    deliveryWayInput.backgroundColor = [UIColor clearColor];
    [self.view addSubview:deliveryWayInput];
    
    
    
    
    //初始化下单时间
    UILabel * orderTimer = [[[UILabel alloc] initWithFrame:CGRectMake(15, deliveryWay.frame.size.height+deliveryWay.frame.origin.y, 80, 20)]autorelease];
    orderTimer.text = @"下单时间";
    orderTimer.textColor = eliuyan_color(0xababaa);
    orderTimer.font = [UIFont systemFontOfSize:14];
    orderTimer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:orderTimer];
    
    UILabel * orderTimerInput = [[[UILabel alloc] initWithFrame:CGRectMake(orderTimer.frame.size.width+orderTimer.frame.origin.x+10, deliveryWay.frame.size.height+deliveryWay.frame.origin.y, 200, 20)]autorelease];
    orderTimerInput.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"orderDate"];
    orderTimerInput.textColor = eliuyan_color(0x404040);
    orderTimerInput.font = [UIFont systemFontOfSize:14];
    orderTimerInput.backgroundColor = [UIColor clearColor];
    [self.view addSubview:orderTimerInput];
    
    
    UIImageView * imageHeng = [[[UIImageView alloc] initWithFrame:CGRectMake(15, orderTimer.frame.size.height+orderTimer.frame.origin.y+13, 290, 1)]autorelease];
    [imageHeng setBackgroundColor:[UIColor colorWithRed:218.0/255.0 green:217.0/255.0 blue:205.0/255.0 alpha:1]];
    [self.view addSubview:imageHeng];
    
    
    
    //初始化导航条
    navC = [[NavCustom alloc] init];
    [navC setNav:@"下单成功" mySelf:self];
    [navC setNavRightBtnImage:@"主页.png" RightBtnSelectedImage:@"主页.png" mySelf:self width:36 height:26];
    navC.NavDelegate = self;
    
    [self setLeftItem];
    
    // Do any additional setup after loading the view.
}

-(IBAction)onClick:(id)sender
{
    UIWebView*callWebview =[[[UIWebView alloc] init] autorelease];
    
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"shopPhone"]];
    
    NSURL *telURL =[NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    //记得添加到view上
    
    [self.view addSubview:callWebview];
}

-(void )setLeftItem{
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@""];

    backButton.backgroundColor=[UIColor clearColor];
    backButton.frame = CGRectMake(-20, 0, 45, 25);
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton setBackgroundImage: [UIImage imageNamed:@".png"] forState:UIControlStateHighlighted];

    [backButton addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    if([UIDevice currentDevice].systemVersion.floatValue >= 7.0f){
        UIBarButtonItem *negativeSpacer = [[[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil] autorelease];
        negativeSpacer.width = -7.5;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftButtonItem];
    }
    else{
        self.navigationItem.leftBarButtonItem = leftButtonItem;
    }
    
}

-(void)popself{
    
   // [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)NavRightButtononClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [navC release];
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
