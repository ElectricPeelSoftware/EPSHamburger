//
//  EPSSidebarBehavior.h
//  EPSHamburger
//
//  Created by Peter Stuart on 5/13/14.
//  Copyright (c) 2014 Electric Peel, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSSidebarBehavior : UIDynamicBehavior

@property (nonatomic) CGPoint targetPoint;
@property (nonatomic) CGPoint velocity;

- (id)initWithItem:(id <UIDynamicItem>)item;

@end
