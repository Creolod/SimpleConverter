//
//  Facade.m
//  SimpleConverter
//
//  Created by User on 08.06.16.
//  Copyright © 2016 User. All rights reserved.
//

#import "Facade.h"
#import "XMLParser.h"
#import "CoreDataManager.h"
#import "Currency.h"
#import "Reachability.h"

@implementation Facade{
    NetworkStatus networkStatus;
    Reachability * reachability;
}

+(id)sharedManager {
    static Facade *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(id)init{
    self = [super init];
    if (self) {
        reachability = [Reachability reachabilityForInternetConnection];
        [reachability startNotifier];
    }
    return self;
}

#pragma mark - XMLParser

+(void)updateConvertRates{
    if ([[self sharedManager] getInternetStatus]) {
        [[[XMLParser alloc] init] updateConvertRates];
    }
}

#pragma mark - Core Data Manager;

+(void)saveCurrencyWithName:(NSString*)name rate:(float)rate{
    NSArray * currenciesArray = [CoreDataManager fetchThisEntity:@"Currency" key:@"name" value:name];
    Currency * currency;
    if (currenciesArray.count > 0) {
        currency = currenciesArray[0];
        currency.rate = @(rate);
    } else {
        currency = (Currency*)[CoreDataManager addEntity:@"Currency"];
        currency.name = name;
        currency.rate = @(rate);
        currency.checked = @NO;
    }
}

+(void)changeCheckCurrencyWithName:(NSString*)name{
    Currency * currency = [CoreDataManager fetchThisEntity:@"Currency" key:@"name" value:name][0];
    currency.checked = @(!currency.checked.boolValue);
    NSError *error = nil;
    [[CoreDataManager managedObjectContext] save:&error];
}

+(NSArray*)loadAllCurrencies{
    return [CoreDataManager fetchWithOrderThisEntity:@"Currency"];
}

+(NSArray*)getCurrenciesWithCheckedStatus:(BOOL)checkedStatus{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"checked = %@", @(checkedStatus)];
    return [[self loadAllCurrencies] filteredArrayUsingPredicate:predicate];
}

+(Currency*)getCurrencyWithName:(NSString*)name{
    return [CoreDataManager fetchThisEntity:@"Currency" key:@"name" value:name][0];
}

#pragma mark - Internet Reachability

-(BOOL)getInternetStatus{
    networkStatus = [reachability currentReachabilityStatus];
    return (networkStatus != NotReachable) ? YES :  NO;
}
@end
