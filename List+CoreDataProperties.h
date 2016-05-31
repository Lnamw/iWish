//
//  List+CoreDataProperties.h
//  iWish
//
//  Created by Elena Maso Willen on 31/05/2016.
//  Copyright © 2016 Elena. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "List.h"

NS_ASSUME_NONNULL_BEGIN

@interface List (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *picture;
@property (nullable, nonatomic, retain) NSSet<Item *> *items;

@end

@interface List (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet<Item *> *)values;
- (void)removeItems:(NSSet<Item *> *)values;

@end

NS_ASSUME_NONNULL_END
