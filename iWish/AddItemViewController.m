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

@interface AddItemViewController () <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) UITextView *activeField;
@property (nonatomic) UIEdgeInsets originalContentInsets;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *itemNameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UITextView *itemDetailsTextView;


- (IBAction)addPictureButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;


@end

@implementation AddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Add Item";
    
    [self.itemDetailsTextView setDelegate:self];
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(grTapped:)];
    [self.scrollView addGestureRecognizer:gr];
    
}

- (void) viewDidAppear:(BOOL)animated  {
    self.originalContentInsets = self.scrollView.contentInset;
    [self registerForKeyboardNotifications];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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

#pragma mark - TextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    self.activeField = textView;
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    self.activeField = nil;

    [textView resignFirstResponder];
    return YES;
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

#pragma mark - KeyBoard


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.originalContentInsets.top, self.originalContentInsets.left, self.originalContentInsets.bottom + kbSize.height , self.originalContentInsets.right);
    
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    
    if ( CGRectGetMaxY(aRect) < CGRectGetMaxY(self.activeField.frame) ) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.scrollView.contentInset = self.originalContentInsets;
    self.scrollView.scrollIndicatorInsets = self.originalContentInsets;
    [self.scrollView scrollRectToVisible:CGRectZero animated:YES];
}

#pragma  mark - Private

- (NSString *)savePictureToDisk
{
    if (self.itemImageView.image) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSUUID *uuid = [NSUUID UUID];
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [uuid UUIDString]]];
        
        [UIImagePNGRepresentation(self.itemImageView.image) writeToFile:filePath atomically:YES];
        
        return filePath;
    }
    return nil;
}

- (void)grTapped:(id)sender {
    
    [self.scrollView endEditing:YES];
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
        anItem.details = self.itemDetailsTextView.text;
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









