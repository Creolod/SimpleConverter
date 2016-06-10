//
//  Currency+CoreDataProperties.h
//  SimpleConverter
//
//  Created by User on 10.06.16.
//  Copyright © 2016 User. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Currency.h"

NS_ASSUME_NONNULL_BEGIN

@interface Currency (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *rate;
@property (nullable, nonatomic, retain) NSNumber *checked;

@end

NS_ASSUME_NONNULL_END
