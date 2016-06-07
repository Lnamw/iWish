//
//  ItemTableViewControllerTests.m
//  iWish
//
//  Created by Elena Maso Willen on 07/06/2016.
//  Copyright © 2016 Elena. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ItemTableViewController.h"
#import "Item.h"
#import "List.h"
#import "List+CoreDataProperties.h"
#import "AppDelegate.h"

@interface ItemTableViewControllerTests : XCTestCase

@property (nonatomic, strong) ItemTableViewController *controller;
@property (nonatomic, strong) NSManagedObjectContext* moc;

@end

@implementation ItemTableViewControllerTests

- (void)setUp {
    [super setUp];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.moc = [appDelegate managedObjectContext];
    List *list = (List*)[NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:self.moc];
    self.controller = [[ItemTableViewController alloc] init];
    self.controller.selectedList = list;
}

- (void)tearDown {
    [self.moc reset];
    [super tearDown];
}

- (void)testDeletingTheSecondOfThreeItemsUpdatesPositions {

    [self insertNumberOfItems:3];
    
    [self deletedItemAtRow:1];
    
    XCTAssertEqual([self itemPositionAtRow:0].integerValue, 1);
    XCTAssertEqual([self itemPositionAtRow:1].integerValue, 2);

}

- (void)testAddingItemsPositionsAreSequential {
    
    [self insertNumberOfItems:3];
    
    XCTAssertEqual([self itemPositionAtRow:0].integerValue, 1);
    XCTAssertEqual([self itemPositionAtRow:1].integerValue, 2);
    XCTAssertEqual([self itemPositionAtRow:2].integerValue, 3);
    
}

- (void)testDeletingItemsNumberOfItems {
    [self insertNumberOfItems:3];
    [self deletedItemAtRow:0];
    XCTAssertEqual(self.controller.selectedList.items.count, 2);
}

#pragma mark - Helpers

- (NSNumber*)itemPositionAtRow:(NSUInteger)row {
    NSArray *items = [self.controller sortItemsArray];
    
    return ((Item*) items[row]).position;
}

- (void)deletedItemAtRow:(NSUInteger)row {
    NSIndexPath *indexPathToDelete = [NSIndexPath indexPathForRow:row inSection:0];
    [self.controller tableView:self.controller.tableView
            commitEditingStyle:UITableViewCellEditingStyleDelete
             forRowAtIndexPath:indexPathToDelete];
}

- (void)insertNumberOfItems:(NSUInteger)itemCount {
    for (int i = 1; i <= itemCount; i++) {
        Item *item = (Item*)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:self.moc];
        item.name = [NSString stringWithFormat:@"%d", i];
        item.position = @(i);
        [self.controller.selectedList addItemsObject:item];
    }
}

@end



