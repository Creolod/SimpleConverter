//
//  CoreDataManager.h
//  SimpleConverter
//
//  Created by Станислав on 13.05.16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@class AppDelegate;
@interface CoreDataManager : NSObject

+(NSManagedObjectContext *)managedObjectContext;
+(NSManagedObject *)addEntity:(NSString*)entityName;
+(NSMutableArray *)fetchThisEntity:(NSString *)entityName;
+(void)deleteEntity:(NSManagedObject *)objectForDelete;
+(NSMutableArray *)fetchThisEntity:(NSString *)entityName key:(NSString*)key value:(NSString*)value;
+(NSArray *)fetchWithOrderThisEntity:(NSString *)entityName;

@end
