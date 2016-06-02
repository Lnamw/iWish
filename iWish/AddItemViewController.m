//
//  AddItemViewController.m
//  iWish
//
//  Created by Elena Maso Willen on 01/06/2016.
//  Copyright © 2016 Elena. All rights reserved.
//

#import "AddItemViewController.h"

#import <CoreData/CoreData.h>
#import "AppDelegate.h"

#import "Item.h"
#import "List.h"

@interface AddItemViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *items;

@property (weak, nonatomic) IBOutlet UITextField *itemNameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UITextField *itemDetailTextField;

- (IBAction)addPictureButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;


@end

@implementation AddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.items = [[NSMutableArray alloc] initWithObjects:self.listSelected.items, nil]; //(NSMutableArray *)self.selectedList.items;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillDisappear:(BOOL)animated {
//    
//    NSSet *test = [NSSet setWithArray:self.items];
////    NSLog(@"%lu", (unsigned long)test.count);
//    
//    self.listSelected
//    NSSet newSet  = [self.listSelected.items setByAddingObjectsFromArray:self.items];
////    [test setByAddingObjectsFromArray:self.items];
//    
//    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    NSError *error = nil;
//    [appDelegate.managedObjectContext save:&error];
//    if (error) {
//        NSLog(@"Core Data could not save: %@", [error localizedDescription]);
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    BOOL rc = NO;
    if (![textField.text isEqualToString:@""]) {
        [textField resignFirstResponder];
        rc = YES;
    }
    return rc;
}

#pragma mark - UIImageControllerDelegate delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.itemImageView.image = image;
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma  mark - Private

- (NSString *)savePictureToDisk
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSUUID *uuid = [NSUUID UUID];
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [uuid UUIDString]]];
    
    [UIImagePNGRepresentation(self.itemImageView.image) writeToFile:filePath atomically:YES];
    
    return filePath;
}

#pragma mark - Action handlers

- (IBAction)addPictureButtonPressed:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonPressed:(id)sender {

    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    if (![self.itemNameTextField.text isEqualToString:@""]) {
        Item *anItem = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:appDelegate.managedObjectContext];
        anItem.name = self.itemNameTextField.text;
        anItem.details = self.itemDetailTextField.text;
        long x = self.listSelected.items.count;
        anItem.position = [NSNumber numberWithLong:x];
        
        anItem.picture = [self savePictureToDisk];
        
        [self.listSelected addItemsObject:anItem];
        
        NSError *error = nil;
        [appDelegate.managedObjectContext save:&error];
        if (error) {
            NSLog(@"Core Data could not save: %@", [error localizedDescription]);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end









