//
//  ListTableViewController.m
//  iWish
//
//  Created by Elena Maso Willen on 31/05/2016.
//  Copyright © 2016 Elena. All rights reserved.
//

#import "ListTableViewController.h"
#import "ListCell.h"
#import "ItemTableViewController.h"

#import <CoreData/CoreData.h>
#import "AppDelegate.h"

#import "List.h"

@interface ListTableViewController ()

@property (nonatomic, strong) NSMutableArray *lists;
@property (nonatomic) AppDelegate *appDelegate;

@end

@implementation ListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My Lists";

    self.lists = [NSMutableArray array];
    
    self.appDelegate = [UIApplication sharedApplication].delegate;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"List" inManagedObjectContext:self.appDelegate.managedObjectContext];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *fetchResults = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        // Fetch request encountered error
        NSLog(@"Fetch request failed: %@", [error localizedDescription]);
    } else {
        for (List *aList in fetchResults) {
            NSPredicate *listSearch = [NSPredicate predicateWithFormat:@"name=%@", aList.name];
            NSArray *foundLists = [self.lists filteredArrayUsingPredicate:listSearch];
            if (foundLists.count == 0) {
                [self.lists addObject:aList];
            }
        }
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListCell *cell = (ListCell *)[tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
    
    List *aList = self.lists[indexPath.row];
    cell.listNameLabel.text = aList.name;
    
    return cell;
}

#pragma mark - tableView Delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        List *aList = self.lists[indexPath.row];
        [self.appDelegate.managedObjectContext deleteObject:aList];
        [self saveObject];
        [self.lists removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"showItemTVCSegue"]) {
        ItemTableViewController *itemTVC = (ItemTableViewController *)[segue destinationViewController];
        
        NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:sender];
        List *selectedList = self.lists[cellIndexPath.row];
        
        itemTVC.selectedList = selectedList;
    }
}

#pragma mark - Private 

- (void)saveObject {
    
    NSError *error = nil;
    [self.appDelegate.managedObjectContext save:&error];
    if (error) {
        NSLog(@"Core Data could not save: %@", [error localizedDescription]);
    }
}


@end







