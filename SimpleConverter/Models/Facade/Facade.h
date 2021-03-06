//
//  Facade.h
//  SimpleConverter
//
//  Created by User on 08.06.16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Currency;

@interface Facade : NSObject

+(id)sharedManager;

//CoreDataManager
+(void)saveCurrencyWithName:(NSString*)name rate:(float)rate;
+(void)changeCheckCurrencyWithName:(NSString*)name;
+(NSArray*)loadAllCurrencies;
+(Currency*)getCurrencyWithName:(NSString*)name;
+(NSArray*)getCurrenciesWithCheckedStatus:(BOOL)checkedStatus;

//InternetReachability
-(BOOL)getInternetStatus;

//XMLParser
+(void)updateConvertRates;

@end
