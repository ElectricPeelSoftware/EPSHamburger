//
//  EPSSidebarManagerViewController.h
//  EPSHamburger
//
//  Created by Peter Stuart on 5/13/14.
//  Copyright (c) 2014 Electric Peel, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSSidebarManagerViewController : UIViewController

- (id)initWithSidebarViewController:(UIViewController *)sidebarViewController mainViewController:(UIViewController *)mainViewController;
- (void)presentNewMainViewController:(UIViewController *)mainViewController;

- (UIBarButtonItem *)toggleItem;

@end

@interface UIViewController (EPSHamburger)

- (EPSSidebarManagerViewController *)sidebarManager;

@end
