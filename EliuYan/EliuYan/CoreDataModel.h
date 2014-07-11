//
//  CoreDataModel.h
//  EliuYan
//
//  Created by laoniu on 14-7-8.
//  Copyright (c) 2014年 eliuyan.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CoreDataModel : NSManagedObject

@property (nonatomic, retain) NSString * storeID;
@property (nonatomic, retain) NSString * menuID;
@property (nonatomic, retain) NSString * content;

@end
