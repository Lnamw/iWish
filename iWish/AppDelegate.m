//
//  AppDelegate.m
//  iWish
//
//  Created by Elena Maso Willen on 31/05/2016.
//  Copyright © 2016 Elena. All rights reserved.
//

#import "AppDelegate.h"
#import "WishDataStore.h"
#import "ListTableViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) WishDataStore *dataStore;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    UINavigationController *rootViewController = (id) self.window.rootViewController;
    ListTableViewController *controller = (id) rootViewController.topViewController;
    
    self.dataStore = [WishDataStore new];
    controller.dataStore = self.dataStore;
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [self.managedObjectContext reset];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext {
    return self.dataStore.managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
