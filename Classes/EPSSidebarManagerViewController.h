//
//  EPSSidebarManagerViewController.h
//  EPSHamburger
//
//  Created by Peter Stuart on 5/13/14.
//  Copyright (c) 2014 Electric Peel, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSSidebarManagerViewController : UIViewController

@property (nonatomic) CGFloat openWidth; // Defaults to 200

- (id)initWithSidebarViewController:(UIViewController *)sidebarViewController mainViewController:(UIViewController *)mainViewController shadowImage:(UIImage *)shadowImage;
- (void)presentNewMainViewController:(UIViewController *)mainViewController;
- (UIBarButtonItem *)toggleItem;
- (void)toggle:(id)sender;

@end

@interface UIViewController (EPSHamburger)

- (EPSSidebarManagerViewController *)sidebarManager;

@end
