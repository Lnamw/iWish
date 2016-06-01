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

@end

@implementation ListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My Lists";
    

    self.lists = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"List" inManagedObjectContext:appDelegate.managedObjectContext];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *fetchResults = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    UIImage *listImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:aList.picture]];
    cell.listImageView.image = listImage;
    
    return cell;
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
