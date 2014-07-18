//
//  AppDelegate.m
//  ELiuYan
//
//  Created by shanchen on 14-4-21.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "AppDelegate.h"
#import "NavViewController.h"
#import "MainViewController.h"
#import "Reachability.h"
#import "ShoppingViewController.h"
#import "NewListViewController.h"
#import "MemberDetailViewController.h"
#import "CommunityViewController.h"

@implementation AppDelegate
{
    Reachability *hostReach;
}

-(NSFetchedResultsController*)fetchResultController
{
    if(_fetchResultController)
    {
        return _fetchResultController;
    }
    
    _fetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:nil managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:@"root"];
    return _fetchResultController;
}

-(NSManagedObjectModel *)managedObjectModel
{
    if(_managedObjectModel)
    {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

-(NSManagedObjectContext*)managedObjectContext
{
    if(_managedObjectContext)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator * coordinator = [self persistentStoreCoordinator];
    if(coordinator!=nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if(_persistentStoreCoordinator)
    {
        return _persistentStoreCoordinator;
    }
    
    NSString * docs = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
    NSURL * storeUrl = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"CoreDataExample.sqlite"]];
    
    NSError * error =nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error])
    {
        NSLog(@"ERROR====>%@",error);
    }
    return _persistentStoreCoordinator;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];

    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"G27D5UzyGSfHP98tKMQOIpnH"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    _appDefault = [NSUserDefaults standardUserDefaults];
    
    
    ShoppingViewController *MainVC=[[ShoppingViewController alloc] init];
    UINavigationController *nav=[[NavViewController alloc] initWithRootViewController:MainVC];
    
    CommunityViewController *ListVC=[[CommunityViewController alloc] init];
    UINavigationController *navList=[[NavViewController alloc] initWithRootViewController:ListVC];
    
    MemberDetailViewController *MemberVC=[[MemberDetailViewController alloc] init];
    UINavigationController *navMember=[[NavViewController alloc] initWithRootViewController:MemberVC];
    

    _tabbar = [[tabbarViewController alloc] init];
    _tabbar.viewControllers = @[nav, navList, navMember];

    if(![_appDefault objectForKey:@"UserId"])
    {
        [_appDefault setObject:@"" forKey:@"UserId"];
    }
    
    //监听网络
    [self ListenWork];
    
    [_window setRootViewController:_tabbar];
    [_window makeKeyAndVisible];
    
    
    //判断程序是否是第一次运行
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        NSLog(@"first");
        //加载宣传动画
        [self createScrollerView];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"newMessageCount"];
    }
    else
    {
        NSLog(@"noFirst");
        
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAllCount" object:nil];
    return YES;
}

-(void)hidenTabbar
{
    [_tabbar hideTabBar];
}

-(void)showTabbar
{
    [_tabbar showTabBar];
}

-(void)ListenWork
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"] ;
    
    //开始监听，会启动一个run loop
    
    [hostReach startNotifier];
}

-(void)reachabilityChanged:(NSNotification *)note

{
    
    Reachability *currReach = [note object];
    
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    
    
    
    //对连接改变做出响应处理动作
    
    NetworkStatus status = [currReach currentReachabilityStatus];
    
    //如果没有连接到网络就弹出提醒实况
    
    if(status == NotReachable)
        
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络异常！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"networkError"];
        return;
        
    }
    else{
        
        NSLog(@"网络正常!");
        
        return ;
        
    }
}


//添加_scrollView
-(void)createScrollerView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.window.frame.size.height)];
    _scrollView.contentSize=CGSizeMake(320*4, self.window.frame.size.height);
    _scrollView.delegate=self;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.pagingEnabled=YES;
    //四张图片
    for (int i=1; i<=4; i++) {
        //闪页1.png
        _mainImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"闪页%d.png",i]]];
        _mainImageView.frame=CGRectMake(320*(i-1), 0, 320, self.window.frame.size.height);
        [_scrollView addSubview:_mainImageView];
    }
    [self.window addSubview:_scrollView];
    
    //定时器
    _timer =  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    
}

-(void)changeImage
{
    num++;
    NSLog(@"num=%d",num);
    if (_scrollView.contentOffset.x>=320*3) {
        // 移除_scrollView 停止定时器
        [_timer invalidate];
        _timer=nil;
   
        [_scrollView removeFromSuperview];
    }
    //_page.currentPage=num%4;
    [_scrollView setContentOffset:CGPointMake(((num%4)*320), 0) animated:YES];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.window endEditing:YES];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //进入程序的时候图标的信息数量设置为0
    [[NSNotificationCenter defaultCenter] postNotificationName:@"becameActive" object:nil];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark - ScrollViewDelegate
//开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}
//滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}
//手指离开屏幕
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}
//减速完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    num=scrollView.contentOffset.x/320;
    NSLog(@"num=======%d",num);
    if (scrollView.contentOffset.x==320*3) {
        NSLog(@"最后一张");
        [_scrollView removeFromSuperview];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken
{

    NSLog(@"%@",[[[pToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""]);
    
    [[NSUserDefaults standardUserDefaults] setObject:[[[pToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"DeviceToken"];
    
    //注册成功，将deviceToken保存到应用服务器数据库中
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCount" object:nil userInfo:userInfo];
    
    NSString *count = [[userInfo objectForKey:@"aps"] objectForKey:@"badge"];
    
    int i = [count intValue];
    NSLog(@"i is %d",i);
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",i] forKey:@"allCount"];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAllCount" object:nil];
    
    if (application.applicationState == UIApplicationStateActive) {
        AudioServicesPlaySystemSound(1007);
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
    
    NSLog(@"Regist fail%@",error);
    
}


@end
