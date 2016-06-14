//
//  ListShareTableViewController.h
//  iWish
//
//  Created by Elena Maso Willen on 13/06/2016.
//  Copyright © 2016 Elena. All rights reserved.
//

#import <UIKit/UIKit.h>

@class List;
@class WishDataStore;

@protocol ListShareTableViewControllerDelegate <NSObject>

- (void)listWasChoosen:(List *)list;

@end

@interface ListShareTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *lists;

@property (weak, nonatomic) id<ListShareTableViewControllerDelegate>delegate;


@end
