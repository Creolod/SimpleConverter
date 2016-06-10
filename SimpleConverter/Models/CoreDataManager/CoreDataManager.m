//
//  CoreDataManager.m
//  testRss
//
//  Created by Станислав on 13.05.16.
//  Copyright © 2016 test. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

+(NSManagedObjectContext *)managedObjectContext{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication]delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    return context;
}

+(NSArray *)fetchThisEntity:(NSString *)entityName{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:entityName];
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    temp = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
    return temp;
}

+(NSArray *)fetchWithOrderThisEntity:(NSString *)entityName{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:entityName];
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    temp = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
    
    return temp;
}

+(NSMutableArray *)fetchThisEntity:(NSString *)entityName key:(NSString*)key value:(NSString*)value{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:entityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", key, value];
    [fetchRequest setPredicate:predicate];
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    temp = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
    return temp;
}


+(void)deleteEntity:(NSManagedObject *)objectForDelete{
    NSManagedObjectContext *context = [self managedObjectContext];
    [context deleteObject:objectForDelete];
    NSError *error = nil;
    if (![context save:&error]) {
    }
}

+(NSManagedObject *)addEntity:(NSString*)entityName{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *createNotes = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    return createNotes;
}

@end
