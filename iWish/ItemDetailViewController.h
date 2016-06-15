//
//  ItemDetailViewController.h
//  iWish
//
//  Created by Elena Maso Willen on 15/06/2016.
//  Copyright © 2016 Elena. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;
@class WishDataStore;

@interface ItemDetailViewController : UIViewController

@property (nonatomic, strong) Item *selectedItem;
@property (nonatomic, strong) WishDataStore *dataStore;

@end
