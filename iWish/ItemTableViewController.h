//
//  ItemTableViewController.h
//  iWish
//
//  Created by Elena Maso Willen on 01/06/2016.
//  Copyright © 2016 Elena. All rights reserved.
//

#import <UIKit/UIKit.h>

@class List;
@class WishDataStore;

@interface ItemTableViewController : UITableViewController

@property (nonatomic, strong) List *selectedList;
@property (nonatomic, strong) WishDataStore *dataStore;


- (NSArray *)sortItemsArray;

@end
