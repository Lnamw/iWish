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
#import "List.h"
#import "WishDataStore.h"


@interface ListTableViewController ()

@property (nonatomic, weak) ItemTableViewController *itemTVC;
@property (nonatomic, strong) List *lastSelectedList;
@property (nonatomic, strong) NSIndexPath *cellIndexPath;

@end

@implementation ListTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"My Lists";
    self.lists = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataAfterChangeNotification:) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self loadData];
        
}

- (void)loadDataAfterChangeNotification:(NSNotification*)notification {
    
    
    NSArray *invalidatedObjects = [[notification userInfo] objectForKey:NSInvalidatedAllObjectsKey];
    
    if (invalidatedObjects.count) {
        
        [self loadData];

    }

}

- (void)loadData {
    
    self.lists = [NSMutableArray arrayWithArray:[self.dataStore fetchLists]];
    
    [self.tableView reloadData];
    
    if (self.lists.count) {
        [self passLastSelectedListWithIndexPath:self.cellIndexPath];
        
        [self.itemTVC.tableView reloadData];
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
        
        [self.dataStore deleteList:aList];
        
        [self.lists removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"showItemTVCSegue"]) {
        
        self.itemTVC = (ItemTableViewController *)[segue destinationViewController];
        
        self.cellIndexPath = [self.tableView indexPathForCell:sender];

        
        [self passLastSelectedListWithIndexPath:self.cellIndexPath];

        self.itemTVC.dataStore = self.dataStore;
    }
}

#pragma mark - Private

- (void)passLastSelectedListWithIndexPath:(NSIndexPath *)cellIndexPath {

    self.lastSelectedList = self.lists[cellIndexPath.row];
    
    self.itemTVC.selectedList = self.lastSelectedList;
    
}


@end







