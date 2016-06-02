//
//  ItemTableViewController.m
//  iWish
//
//  Created by Elena Maso Willen on 01/06/2016.
//  Copyright © 2016 Elena. All rights reserved.
//

#import "ItemTableViewController.h"
#import "AddItemViewController.h"

#import <CoreData/CoreData.h>
#import "AppDelegate.h"

#import "List.h"
#import "Item.h"

@interface ItemTableViewController ()

@property (nonatomic, strong) NSMutableArray *lists;


@end

@implementation ItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.selectedList.name;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectedList.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    
    NSArray *items = [self.selectedList.items allObjects];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position"
                                                                    ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];

    NSArray *sortedItems = [items sortedArrayUsingDescriptors:sortDescriptors];
    
    Item *anItem = sortedItems[indexPath.row];
    cell.textLabel.text = anItem.name;
    
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"AddItemSegue"]) {
        
        UINavigationController *navController = [segue destinationViewController];
        AddItemViewController *addItemVC = (AddItemViewController *)([navController viewControllers][0]);
        
        addItemVC.listSelected = self.selectedList;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/




@end
