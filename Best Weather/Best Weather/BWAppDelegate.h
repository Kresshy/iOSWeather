//
//  BWAppDelegate.h
//  Best Weather
//
//  Created by Szabolcs Varadi on 5/3/13.
//  Copyright (c) 2013 Szabolcs Varadi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWAppDelegate : UIResponder <UIApplicationDelegate> 

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+(BWAppDelegate*) sharedAppDelegate;

@end
