//
//  ItemDetailViewController.m
//  iWish
//
//  Created by Elena Maso Willen on 15/06/2016.
//  Copyright © 2016 Elena. All rights reserved.
//

#import "ItemDetailViewController.h"

#import "Item.h"

@interface ItemDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *NameDetailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *urlButton;

- (IBAction)buyButtonPressed:(id)sender;

@end

@implementation ItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.NameDetailLabel.text = self.selectedItem.name;
    self.detailLabel.text = self.selectedItem.details;
    self.detailImageView.image = [self displayImage:self.selectedItem];
    
    if ([self.selectedItem.url isEqualToString:@""]) {
        [self.urlButton setHidden:YES];
    } else {
        [self.urlButton setHidden:NO];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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









