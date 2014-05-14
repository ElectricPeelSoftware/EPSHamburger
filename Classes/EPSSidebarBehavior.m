//
//  EPSSidebarBehavior.m
//  EPSHamburger
//
//  Created by Peter Stuart on 5/13/14.
//  Copyright (c) 2014 Electric Peel, LLC. All rights reserved.
//

#import "EPSSidebarBehavior.h"

@interface EPSSidebarBehavior () <UICollisionBehaviorDelegate>

@property (nonatomic, strong) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;
@property (nonatomic, strong) id <UIDynamicItem> item;

@end

@implementation EPSSidebarBehavior

- (id)initWithItem:(id <UIDynamicItem>)item {
    self = [super init];
    if (self) {
        self.item = item;
        [self setup];
    }
    return self;
}

- (void)setup {
    UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.item attachedToAnchor:CGPointZero];
    attachmentBehavior.frequency = 3.5;
    attachmentBehavior.damping = .4;
    attachmentBehavior.length = 0;
    [self addChildBehavior:attachmentBehavior];
    self.attachmentBehavior = attachmentBehavior;
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ self.item ]];
    itemBehavior.density = 100;
    itemBehavior.resistance = 10;
    [self addChildBehavior:itemBehavior];
    self.itemBehavior = itemBehavior;
    
    /*
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[ self.item ]];
    [collisionBehavior addBoundaryWithIdentifier:@"edge" fromPoint:CGPointMake(-1, 0) toPoint:CGPointMake(-1, 1000)];
    collisionBehavior.collisionDelegate = self;
    [self addChildBehavior:collisionBehavior];
     */
}

- (void)setTargetPoint:(CGPoint)targetPoint {
    _targetPoint = targetPoint;
    self.attachmentBehavior.anchorPoint = targetPoint;
}

- (void)setVelocity:(CGPoint)velocity {
    _velocity = velocity;
    CGPoint currentVelocity = [self.itemBehavior linearVelocityForItem:self.item];
    CGPoint velocityDelta = CGPointMake(velocity.x - currentVelocity.x, velocity.y - currentVelocity.y);
    [self.itemBehavior addLinearVelocity:velocityDelta forItem:self.item];
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    NSLog(@"%@", identifier);
}

@end
