//
//  ItemCell.h
//  iWish
//
//  Created by Elena Maso Willen on 02/06/2016.
//  Copyright © 2016 Elena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;

@end
