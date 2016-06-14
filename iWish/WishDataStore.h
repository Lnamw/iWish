//
//  WishDataStore.h
//  iWish
//
//  Created by Elena Maso Willen on 10/06/2016.
//  Copyright © 2016 Elena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@class List;

@interface WishDataStore : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (NSArray*)fetchLists;

- (void)deleteList:(List*)list;

- (void)addGiftItemWithName:(NSString *)name andUrl:(NSString *)url andPicture:(NSString *)picture andDetails:(NSString *)details andPosition:(NSNumber *)position andList:(List *)list;

- (NSString *)savePictureToDiskWithImage:(UIImage *)image;

@end
