//
//  AppDelegate.h
//  WenminYizhangtong
//
//  Created by sgyaaron on 16/6/15.
//  Copyright © 2016年 alexyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

static NSString *appKey = @"f0d1a95d835d3c87cf2a3f94";
static NSString *channel = @"App Store";
static BOOL isProduction = FALSE;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UILabel *_infoLabel;
    UILabel *_tokenLabel;
    UILabel *_udidLabel;
}
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

