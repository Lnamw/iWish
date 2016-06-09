//
//  ItemTableViewController.m
//  iWish
//
//  Created by Elena Maso Willen on 01/06/2016.
//  Copyright © 2016 Elena. All rights reserved.
//

#import "ItemTableViewController.h"
#import "AddItemViewController.h"
#import "ItemCell.h"

#import <CoreData/CoreData.h>
#import "AppDelegate.h"

#import <MessageUI/MFMailComposeViewController.h>

#import "List.h"
#import "Item.h"

@interface ItemTableViewController () <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *lists;

- (IBAction)shareList:(id)sender;

@end

@implementation ItemTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.selectedList.name;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectedList.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemCell *cell = (ItemCell *)[tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];

    Item *anItem = [self ItemAtIndexPath:indexPath];
    cell.itemNameLabel.text = anItem.name;

    cell.itemImageView.image = [self displayImage:anItem];
    
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

        Item *anItem = [self ItemAtIndexPath:indexPath];
        
        [self.selectedList removeItemsObject:anItem];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSArray *sortedItems = [self sortItemsArray];
        
        int i = 1;
        for (Item *anItem in sortedItems) {
            anItem.position = @(i);
            i++;
        }
        [self saveObject];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"AddItemSegue"]) {
        
        UINavigationController *navController = [segue destinationViewController];
        AddItemViewController *addItemVC = (AddItemViewController *)([navController viewControllers][0]);
    
        addItemVC.listSelected = self.selectedList;
    }
}

#pragma mark - Mail compose controller delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private 

- (NSArray *)sortItemsArray {
    
    NSArray *items = [self.selectedList.items allObjects];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position"
                                                                   ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedItems = [items sortedArrayUsingDescriptors:sortDescriptors];
    
    return sortedItems;
}

- (Item *)ItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *sortedItems = [self sortItemsArray];
    Item *anItem = sortedItems[indexPath.row];
    
    return anItem;
}

- (UIImage *)displayImage:(Item *)anItem {
    
    NSString *pathToImage = anItem.picture;
    NSData *imageData = [NSData dataWithContentsOfFile:pathToImage];
    UIImage *imageWithData = [UIImage imageWithData:imageData];
        
    if (imageWithData) {
        UIImage *imageToDisplay =[UIImage imageWithCGImage:[imageWithData CGImage]
                                                     scale:[imageWithData scale]
                                               orientation: UIImageOrientationRight];
        
        return imageToDisplay;
    } else {
        UIImage *giftBoxImage = [UIImage imageNamed:@"giftbox-3"];
        
        return giftBoxImage;
    }
}

- (void)saveObject {
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    NSError *error = nil;
    [appDelegate.managedObjectContext save:&error];
    if (error) {
        NSLog(@"Core Data could not save: %@", [error localizedDescription]);
    }
}

- (NSArray *)emailItemsDescription {
    
    NSArray *sortedItems = [self sortItemsArray];
    NSMutableArray *itemsDescription = [[NSMutableArray alloc] init];
    
    for (Item *anItem in sortedItems) {
        NSMutableString *emailString = [[NSMutableString alloc] init];
        [emailString appendFormat:@"<ul><li><font color=\"#e74c3c\"><strong>%@ </strong></font>", anItem.name];

        if (![anItem.url isEqualToString:@""]) {
            [emailString appendFormat:@"<a href=\"%@\">(see product)</a>", anItem.url];
        }
        if (![anItem.details isEqualToString:@""]) {
            [emailString appendFormat:@"<br> %@", anItem.details];
        }
        [emailString appendString:@"</li></ul>"];
        
        NSLog(@"%@", emailString);
        [itemsDescription addObject:emailString];
    }
    return itemsDescription;
}

#pragma mark - Action handlers

- (IBAction)shareList:(id)sender {
    
    if (![MFMailComposeViewController canSendMail]) {
        NSLog(@"Mail services are not available.");
        return;
    } else {
        MFMailComposeViewController *composeVC = [[MFMailComposeViewController alloc] init];
        composeVC.mailComposeDelegate = self;
        
        NSArray *itemsDescription = [self emailItemsDescription];
        
        // Configure the fields of the interface.
        [composeVC setSubject:@"Here is my Wishlist"];
        [composeVC setMessageBody:[NSString stringWithFormat:@"<header style=\"background-color:#e74c3c;padding:1px\"><center><h3><font color=\"white\">iWish</h3></font></center></header> <h4>Hey!</h4> \n\n <p>If you don't want to spend too much time looking for the perfect gift, you can pick one (or more 😊) in this list:</p> <p>\n\n %@ \n\n </p> <h4>Thank you!</h4><footer style=\"background-color:#e74c3c;padding:3px\"><center><font color=\"white\">iWish - share your wish lists with your family and friends!</font></center></footer>", [itemsDescription componentsJoinedByString:@"\n\n"]] isHTML:YES];
        
        // Present the view controller modally.
        [self presentViewController:composeVC animated:YES completion:nil];
    }
}

@end





















