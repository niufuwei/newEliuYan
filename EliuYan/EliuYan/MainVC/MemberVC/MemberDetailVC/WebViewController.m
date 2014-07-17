//
//  WebViewController.m
//  ELiuYan
//
//  Created by eliuyan_mac on 14-5-2.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

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
    
    [appDelegate hidenTabbar];
    
    NavCustom *nav=[[NavCustom alloc] init];
    [nav setNav:_name mySelf:self];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIWebView * myWebView;
    if (IOS_VERSION >= 7)
    {
     myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 64)];
    }
    else
    {
    
        myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 44)];
    
    }
    
    NSURL *url = [NSURL URLWithString:_url];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    myWebView.backgroundColor=eliuyan_color(0xf5f5f5);
    myWebView.delegate = self;
    [self.view addSubview: myWebView];
    [myWebView loadRequest:request];
    
    
    
    _activity = [[Activity alloc] initWithActivity:self.view];
    
    
    
}
- (void )webViewDidStartLoad:(UIWebView  *)webView
{

    [_activity start];


}
- (void )webViewDidFinishLoad:(UIWebView  *)webView
{

    [_activity stop];
    

}

- (void)webView:(UIWebView *)webView  didFailLoadWithError:(NSError *)error
{
    
    
    [_activity stop];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
    
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
