//
//  WishDataStore.m
//  iWish
//
//  Created by Elena Maso Willen on 10/06/2016.
//  Copyright © 2016 Elena. All rights reserved.
//

#import "WishDataStore.h"
#import "List.h"

@implementation WishDataStore

- (NSArray*)fetchLists {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"List" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        // Fetch request encountered error
        NSLog(@"Fetch request failed: %@", [error localizedDescription]);
        
        return @[];
        
    } else {
        
        return fetchResults;
        
//        for (List *aList in fetchResults) {
//            NSPredicate *listSearch = [NSPredicate predicateWithFormat:@"name=%@", aList.name];
//            NSArray *foundLists = [self.lists filteredArrayUsingPredicate:listSearch];
//            if (foundLists.count == 0) {
//                [self.lists addObject:aList];
//            }
//        }
        
        //        [self.tableView reloadData];
    }
}
@end
