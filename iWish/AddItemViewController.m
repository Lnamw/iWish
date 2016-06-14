//
//  AddItemViewController.m
//  iWish
//
//  Created by Elena Maso Willen on 01/06/2016.
//  Copyright © 2016 Elena. All rights reserved.
//

#import "AddItemViewController.h"

//#import <CoreData/CoreData.h>
//#import "AppDelegate.h"
#import "WishDataStore.h"

#import "Item.h"
#import "List.h"

@interface AddItemViewController () <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) UIView *activeView;
@property (nonatomic) BOOL isValidUrl;
@property (nonatomic) UIEdgeInsets originalContentInsets;
@property (nonatomic) BOOL pictureTaken;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *itemNameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UITextView *itemDetailsTextView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;


- (IBAction)addPictureButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;


@end

@implementation AddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Add Item";
    
    self.pictureTaken = NO;

    [self.doneButton setEnabled:NO];
    
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

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    BOOL rc = NO;
    [textField resignFirstResponder];
    rc = YES;
    return rc;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField == self.itemNameTextField) {
        if (self.itemNameTextField.text.length > 1 || (string.length > 0 && ![string isEqualToString:@""])) {
            [self.doneButton setEnabled:YES];
        } else {
            [self.doneButton setEnabled:NO];
        }
    }
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField {
    
    if (textField == self.itemNameTextField) {
        [self.doneButton setEnabled:NO];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.activeView = textField;
}

-(BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    
    self.activeView = nil;
    
    return YES;
}

#pragma mark - TextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    self.activeView = textView;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    self.activeView = nil;
    
    [textView resignFirstResponder];
    return YES;
}

#pragma mark - UIImageControllerDelegate delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    self.pictureTaken = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.itemImageView.image = image;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - KeyBoard

- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    [self adjustScrollViewContentInsetSize:kbSize.height];
    
    [self adjustScrollViewContentOffsetIfNeeded:kbSize];
}

- (void)adjustScrollViewContentInsetSize:(CGFloat)keyboardHeight {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.originalContentInsets.top, self.originalContentInsets.left, self.originalContentInsets.bottom + keyboardHeight , self.originalContentInsets.right);
    
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)adjustScrollViewContentOffsetIfNeeded:(CGSize)keyboardSize {
    
    if ( [self isCurrentActiveFieldObscuredByKeyboard] ) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            CGPoint contentOffset = [self currentActiveFieldContentOffsetForKeyboardHeight:keyboardSize.height];
            [self.scrollView setContentOffset:contentOffset animated:YES];
        });
    }
}

- (CGPoint)currentActiveFieldContentOffsetForKeyboardHeight:(CGFloat)keyboardHeight {
    
    CGFloat keyboardMinY = self.view.bounds.size.height - keyboardHeight;
    CGFloat contentOffsetY = [self activeTextfieldMaxY] - keyboardMinY;
    
    return CGPointMake(0, contentOffsetY);
}

- (BOOL)isCurrentActiveFieldObscuredByKeyboard {
    
    CGFloat activeTextfieldMaxY = [self activeTextfieldMaxY];
    CGRect currentContentFrame = [self currentContentFrame];
    
    return !CGRectContainsPoint(currentContentFrame, CGPointMake(0, activeTextfieldMaxY));
}

- (CGFloat)activeTextfieldMaxY {
    
    CGFloat fieldBottomPadding = 10.0;
    
    return CGRectGetMaxY(self.activeView.frame) + fieldBottomPadding;
}

- (CGRect)currentContentFrame {
    
    CGFloat visibleContentHeight = (self.scrollView.contentInset.bottom + self.scrollView.contentInset.top);
    CGFloat currentContentOffsetAdjustment = (self.originalContentInsets.top + self.scrollView.contentOffset.y);
    CGFloat visibleHeight = self.view.frame.size.height - visibleContentHeight + currentContentOffsetAdjustment;
    
    return CGRectMake(0, 0, self.view.frame.size.width, visibleHeight) ;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    self.scrollView.contentInset = self.originalContentInsets;
    self.scrollView.scrollIndicatorInsets = self.originalContentInsets;
}

#pragma  mark - Private

//- (NSString *)savePictureToDisk {
//    
//     if (self.itemImageView.image) {
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSUUID *uuid = [NSUUID UUID];
//        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [uuid UUIDString]]];
//        
//        [UIImagePNGRepresentation(self.itemImageView.image) writeToFile:filePath atomically:YES];
//        
//        return filePath;
//    }
//    return nil;
//}

- (void)grTapped:(id)sender {
    
    [self.scrollView endEditing:YES];
}

- (BOOL)isValidUrl {
    
    self.isValidUrl = NO;
        NSURL* url = [NSURL URLWithString:self.urlTextField.text];
        if (url && url.scheme && url.host) {
            self.isValidUrl = YES;
            return YES;
        } else {
            self.isValidUrl = NO;
            return NO;
        }
    return self.isValidUrl;
}

- (void)showUrlAlert {
    
    UIAlertController *urlAlert = [UIAlertController alertControllerWithTitle:@"Url Invalid" message:@"Please enter a valid url (https://...)" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [urlAlert addAction:ok];
    [self presentViewController:urlAlert animated:YES completion:nil];
}

- (void)showPictureAlert {
    
    UIAlertController *pictureAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePicture = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self displayImagePickerController:UIImagePickerControllerSourceTypeCamera];
    }];
    
    UIAlertAction *chooseLibrary = [UIAlertAction actionWithTitle:@"Choose From Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self displayImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    [pictureAlert addAction:takePicture];
    [pictureAlert addAction:chooseLibrary];
    [pictureAlert addAction:cancel];

    [self presentViewController:pictureAlert animated:YES completion:nil];
}

- (void)displayImagePickerController:(UIImagePickerControllerSourceType)sourceType {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - Action handlers

- (IBAction)addPictureButtonPressed:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        [self showPictureAlert];
        
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        [self displayImagePickerController:UIImagePickerControllerSourceTypeCamera];
        
    } else if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        [self displayImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonPressed:(id)sender {
    
    if (self.urlTextField.text.length >= 1) {
        [self isValidUrl];
    }
    if (self.isValidUrl || self.urlTextField.text.length == 0) {
        
        NSString *picture;
        if (self.pictureTaken) {
            picture = [self.dataStore savePictureToDiskWithImage:self.itemImageView.image];
        } else {
            picture = nil;
        }
        long x = self.listSelected.items.count;
        NSNumber *position = [NSNumber numberWithLong:x];
        
        [self.dataStore addGiftItemWithName:self.itemNameTextField.text andUrl:self.urlTextField.text andPicture:picture andDetails:self.itemDetailsTextView.text andPosition:position andList:self.listSelected];

        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self showUrlAlert];
    }
}




@end









