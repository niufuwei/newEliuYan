//
//  AppDelegate.h
//  ELiuYan
//
//  Created by shanchen on 14-4-21.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import <AudioToolbox/AudioToolbox.h>
#import "tabbarViewController.h"
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIScrollViewDelegate,NSFetchedResultsControllerDelegate>

{
    UIScrollView *_scrollView;
    UIImageView *_mainImageView;
    UIPageControl *_page;
    NSTimer *_timer;
    
     int num ;
    
    BMKMapManager* _mapManager;
    NSUserDefaults *_appDefault;
    
    
    
}

@property (nonatomic,strong) NSManagedObjectModel * managedObjectModel;
@property (nonatomic,strong) NSManagedObjectContext * managedObjectContext;
@property (nonatomic,strong) NSPersistentStoreCoordinator * persistentStoreCoordinator;
@property (nonatomic,strong) NSFetchedResultsController * fetchResultController;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSUserDefaults *appDefault;
@property (strong,nonatomic) tabbarViewController * tabbar;


-(void)createScrollerView;
-(void)hidenTabbar;
-(void)showTabbar;

-(NSPersistentStoreCoordinator*) persistentStoreCoordinator;
-(NSManagedObjectContext *)NSManagedObjectContext;
-(NSManagedObjectModel *)NSManagedObjectModel;
-(NSFetchedResultsController *)fetchResultController;

@end
