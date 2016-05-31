//
//  Item+CoreDataProperties.h
//  iWish
//
//  Created by Elena Maso Willen on 31/05/2016.
//  Copyright © 2016 Elena. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Item.h"

NS_ASSUME_NONNULL_BEGIN

@interface Item (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *picture;
@property (nullable, nonatomic, retain) NSString *details;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSSet<List *> *lists;

@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addListsObject:(List *)value;
- (void)removeListsObject:(List *)value;
- (void)addLists:(NSSet<List *> *)values;
- (void)removeLists:(NSSet<List *> *)values;

@end

NS_ASSUME_NONNULL_END
