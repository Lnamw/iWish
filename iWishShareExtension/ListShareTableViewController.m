//
//  ListShareTableViewController.m
//  iWish
//
//  Created by Elena Maso Willen on 13/06/2016.
//  Copyright © 2016 Elena. All rights reserved.
//

#import "ListShareTableViewController.h"

#import "WishDataStore.h"

#import "List.h"

@interface ListShareTableViewController ()

@end

@implementation ListShareTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My Lists";
}

//
//
//- (void)setLists:(NSMutableArray *)lists {
//    _lists = lists;
//    [self.tableView reloadData];
//}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListShareCell" forIndexPath:indexPath];
    
    List *aList = self.lists[indexPath.row];
    cell.textLabel.text = aList.name;
    
    return cell;
}

#pragma mark - Table view Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate listWasChoosen:self.lists[indexPath.row]];
}


@end
