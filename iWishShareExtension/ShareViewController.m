//
//  ShareViewController.m
//  iWishShareExtension
//
//  Created by Elena Maso Willen on 10/06/2016.
//  Copyright © 2016 Elena. All rights reserved.
//

#import "ShareViewController.h"

#import "WishDataStore.h"

#import "List.h"



@interface ShareViewController ()

@property (nonatomic, strong) List *selectedList;
@property (nonatomic, strong) WishDataStore *dataStore;


@property (nonatomic, strong) SLComposeSheetConfigurationItem *item;


@end

@implementation ShareViewController

- (void)viewDidLoad {
    
    self.dataStore = [WishDataStore new];

}

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    NSExtensionItem *item = self.extensionContext.inputItems.firstObject;
    NSItemProvider *itemProvider = item.attachments.firstObject;
    if ([itemProvider hasItemConformingToTypeIdentifier:@"public.url"]) {
        [itemProvider loadItemForTypeIdentifier:@"public.url"
                                        options:nil
                              completionHandler:^(NSURL *url, NSError *error) {
                                  // Do what you want to do with url
                                  
                                  NSLog(@"Title is %@", self.contentText);
                                  [itemProvider loadPreviewImageWithOptions:nil completionHandler:^(UIImage *image, NSError *error){
                                      
                                      if(image){
                                          
                                          NSString *picture = [self.dataStore savePictureToDiskWithImage:image];
                                          long x = self.selectedList.items.count;
                                          NSNumber *position = [NSNumber numberWithLong:x];
                                          NSString *stringUrl = [url absoluteString];
                                          
                                          [self.dataStore addGiftItemWithName:self.contentText andUrl:stringUrl andPicture:picture andDetails:@"" andPosition:position andList:self.selectedList];

                                          
                                      }
                                      [super didSelectPost];
                                  }];
                              }];
    }

    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
//    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    
    self.item = [[SLComposeSheetConfigurationItem alloc] init];
    
    self.item.title = @"Wishlist";
    
    [self giveItemValue:[self.dataStore fetchLists].firstObject];
    
    __block ShareViewController *weakself = self;

    self.item.tapHandler = ^(void){
    
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainInterface" bundle:[NSBundle mainBundle]];

        ListShareTableViewController *controller = (id)[storyboard instantiateViewControllerWithIdentifier:@"ListeShareTableViewController"];
        
        controller.lists = [weakself.dataStore fetchLists];
    
        controller.delegate = weakself;
        
        [weakself pushConfigurationViewController:controller];
        
    };
    
    
    return @[self.item];
}

#pragma mark - List table view controller Delegate

- (void)listWasChoosen:(List *)list {
    
    [self giveItemValue:list];
    
    [self popConfigurationViewController];
    
}

#pragma mark - Private 

- (void)giveItemValue:(List *)list {
    
    self.selectedList = list;
    
    self.item.value = list.name;
}

@end







