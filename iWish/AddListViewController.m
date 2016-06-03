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

@property (weak, nonatomic) IBOutlet UITextField *listNameTextField;

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end

@implementation AddListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    BOOL rc = NO;
    if (![textField.text isEqualToString:@""]) {
        [textField resignFirstResponder];
        rc = YES;
    }
    return rc;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Action handlers

- (IBAction)doneButtonPressed:(id)sender {
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    if (![self.listNameTextField.text isEqualToString:@""]) {
        List *aList = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:appDelegate.managedObjectContext];
        aList.name = self.listNameTextField.text;
        
        NSError *error = nil;
        [appDelegate.managedObjectContext save:&error];
        if (error) {
            NSLog(@"Core Data could not save: %@", [error localizedDescription]);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end









