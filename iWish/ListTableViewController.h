//
//  ListTableViewController.h
//  iWish
//
//  Created by Elena Maso Willen on 31/05/2016.
//  Copyright © 2016 Elena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *lists;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
