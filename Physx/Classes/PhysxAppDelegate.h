//
//  PhysxAppDelegate.h
//  Physx
//
//  Created by Angad Singh on 2/5/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhysxViewController;

@interface PhysxAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    PhysxViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PhysxViewController *viewController;

@end

