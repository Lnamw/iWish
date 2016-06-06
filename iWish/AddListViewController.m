//
//  AddListViewController.m
//  iWish
//
//  Created by Elena Maso Willen on 31/05/2016.
//  Copyright © 2016 Elena. All rights reserved.
//

#import "AddListViewController.h"

#import <CoreData/CoreData.h>
#import "AppDelegate.h"

#import "List.h"

@interface AddListViewController () <UITextFieldDelegate>

@property (nonatomic) AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UITextField *listNameTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end

@implementation AddListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Create a List";
    
    [self.doneButton setEnabled:NO];

    self.appDelegate = [UIApplication sharedApplication].delegate;
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    BOOL rc = NO;
    [textField resignFirstResponder];
    rc = YES;

    return rc;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (![textField.text isEqualToString:@""]) {
        [self.doneButton setEnabled:YES];
    } else {
        [self.doneButton setEnabled:NO];
    }
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

- (void)saveObject {
    
    NSError *error = nil;
    [self.appDelegate.managedObjectContext save:&error];
    if (error) {
        NSLog(@"Core Data could not save: %@", [error localizedDescription]);
    }
}

#pragma mark - Action handlers

- (IBAction)doneButtonPressed:(id)sender {
    
    if (![self.listNameTextField.text isEqualToString:@""]) {
        List *aList = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:self.appDelegate.managedObjectContext];
        aList.name = self.listNameTextField.text;

        [self saveObject];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end









