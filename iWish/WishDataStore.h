//
//  WishDataStore.h
//  iWish
//
//  Created by Elena Maso Willen on 10/06/2016.
//  Copyright © 2016 Elena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface WishDataStore : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (NSArray*)fetchLists;
    
@end
