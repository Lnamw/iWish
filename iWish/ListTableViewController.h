//
//  ListTableViewController.h
//  iWish
//
//  Created by Elena Maso Willen on 31/05/2016.
//  Copyright © 2016 Elena. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WishDataStore;
@class List;


@interface ListTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *lists;
@property (nonatomic, strong) WishDataStore *dataStore;

@end
