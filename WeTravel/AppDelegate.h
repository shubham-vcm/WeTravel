//
//  AppDelegate.h
//  WeTravel
//
//  Created by Shubham Sharma on 12/4/18.
//  Copyright © 2018 TATA SIA AIRLINES LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

