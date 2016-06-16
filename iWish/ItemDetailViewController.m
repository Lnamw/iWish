//
//  ItemDetailViewController.m
//  iWish
//
//  Created by Elena Maso Willen on 15/06/2016.
//  Copyright © 2016 Elena. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "AddItemViewController.h"
#import "WishDataStore.h"
#import "Item.h"

@interface ItemDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *NameDetailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *urlButton;

@property (weak, nonatomic) AddItemViewController *addItemVC;

- (IBAction)buyButtonPressed:(id)sender;

@end

@implementation ItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}

- (void)viewWillAppear:(BOOL)animated {
    
    self.NameDetailLabel.text = self.selectedItem.name;
    self.detailLabel.text = self.selectedItem.details;
    self.detailImageView.image = [self displayImage:self.selectedItem];
    
    NSString *domain = [[NSURL URLWithString:self.selectedItem.url] host];
    [self.urlButton setTitle:[NSString stringWithFormat:@"link: %@", domain] forState:UIControlStateNormal];
    
    if ([self.selectedItem.url isEqualToString:@""]) {
        [self.urlButton setHidden:YES];
    } else {
        [self.urlButton setHidden:NO];
    }
    

}

-(void)setSelectedItem:(Item *)selectedItem {
    _selectedItem = selectedItem;
    
    [self updateChildViewControllerItem];
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"EditItemSegue"]) {
        
        UINavigationController *navController = [segue destinationViewController];
        self.addItemVC = (AddItemViewController *)([navController viewControllers][0]);
        
        [self updateChildViewControllerItem];
        
//        addItemVC.itemSelected = self.selectedItem;
//        addItemVC.dataStore = self.dataStore;
    }
    
}

-(void)updateChildViewControllerItem {
    
    self.addItemVC.itemSelected = self.selectedItem;
    self.addItemVC.dataStore = self.dataStore;
}

#pragma mark - Private

- (UIImage *)displayImage:(Item *)anItem {
    
    NSString *pathToImage = anItem.picture;
    NSData *imageData = [NSData dataWithContentsOfFile:pathToImage];
    UIImage *imageWithData = [UIImage imageWithData:imageData];
    
    if (imageWithData) {
        UIImage *imageToDisplay =[UIImage imageWithCGImage:[imageWithData CGImage]];
        
        return imageToDisplay;
    } else {
        UIImage *giftBoxImage = [UIImage imageNamed:@"giftbox-3"];
        
        return giftBoxImage;
    }
}

- (IBAction)buyButtonPressed:(id)sender {
    
    NSURL *url = [NSURL URLWithString:self.selectedItem.url];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}


@end









