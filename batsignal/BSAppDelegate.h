//
//  BSAppDelegate.h
//  batsignal
//
//  Created by Kyle Warren on 4/24/13.
//  Copyright (c) 2013 Kyle Warren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSMainViewController;
@class BSLoginViewController;

@interface BSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (readonly, nonatomic) BSMainViewController *mainViewController;
@property (readonly, nonatomic) BSLoginViewController *loginViewController;

+ (NSManagedObjectContext *)moc;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
