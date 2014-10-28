//
//  EPSSidebarManagerViewController.m
//  EPSHamburger
//
//  Created by Peter Stuart on 5/13/14.
//  Copyright (c) 2014 Electric Peel, LLC. All rights reserved.
//

#import "EPSSidebarManagerViewController.h"

#import "EPSSidebarBehavior.h"

typedef NS_ENUM(NSInteger, EPSSidebarManagerViewControllerState) {
    EPSSidebarManagerViewControllerStateOpen,
    EPSSidebarManagerViewControllerStateClosed
};

@interface EPSSidebarManagerViewController () <UIDynamicAnimatorDelegate>

@property (nonatomic) UIImage *shadowImage;

@property (nonatomic) UIViewController *sidebarViewController;
@property (nonatomic) UIViewController *mainViewController;

@property (nonatomic) EPSSidebarManagerViewControllerState state;

@property (nonatomic) UIView *sidebarView;
@property (nonatomic) UIView *mainView;

@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) EPSSidebarBehavior *sidebarBehavior;

@property (nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic) UIPanGestureRecognizer *panRecognizer;

@end

@implementation EPSSidebarManagerViewController

- (id)initWithSidebarViewController:(UIViewController *)sidebarViewController mainViewController:(UIViewController *)mainViewController shadowImage:(UIImage *)shadowImage {
    self = [super init];
    if (self == nil) return nil;
    
    self.openWidth = 200;
    self.sidebarViewController = sidebarViewController;
    self.mainViewController = mainViewController;
    self.shadowImage = shadowImage;
    
    return self;
}

- (void)presentNewMainViewController:(UIViewController *)mainViewController {
    [self.mainViewController willMoveToParentViewController:nil];
    [self.mainViewController.view removeFromSuperview];
    [self.mainViewController removeFromParentViewController];
    
    self.mainViewController = mainViewController;
    [self addChildViewController:self.mainViewController];
    self.mainViewController.view.frame = self.mainView.bounds;
    self.mainViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.mainView addSubview:self.mainViewController.view];
    [self.mainViewController didMoveToParentViewController:self];
}

- (UIBarButtonItem *)toggleItem {
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"EPSHamburgerIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(toggle:)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.sidebarView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.sidebarView.backgroundColor = [UIColor colorWithRed:23.0/255.0 green:165.0/255.0 blue:84.0/255.0 alpha:1.000];
    [self.view addSubview:self.sidebarView];
    
    self.mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.mainView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.mainView];
    
    self.sidebarBehavior = [[EPSSidebarBehavior alloc] initWithItem:self.mainView];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self.mainView addGestureRecognizer:tapRecognizer];
    self.tapRecognizer = tapRecognizer;
    
    UIScreenEdgePanGestureRecognizer *screenEdgeRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    screenEdgeRecognizer.edges = UIRectEdgeLeft;
    [self.mainView addGestureRecognizer:screenEdgeRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    self.panRecognizer = panRecognizer;
    [self.mainView addGestureRecognizer:panRecognizer];
    
    self.state = EPSSidebarManagerViewControllerStateClosed;
    
    [self addChildViewController:self.sidebarViewController];
    self.sidebarViewController.view.frame = self.sidebarView.bounds;
    self.sidebarViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.sidebarView addSubview:self.sidebarViewController.view];
    [self.sidebarViewController didMoveToParentViewController:self];
    
    [self addChildViewController:self.mainViewController];
    self.mainViewController.view.frame = self.mainView.bounds;
    self.mainViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.mainView addSubview:self.mainViewController.view];
    [self.mainViewController didMoveToParentViewController:self];
    
    if (self.shadowImage) {
        UIImageView *shadowImageView = [[UIImageView alloc] initWithImage:self.shadowImage];
        shadowImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        CGRect frame = shadowImageView.frame;
        frame.origin.x -= CGRectGetWidth(shadowImageView.frame);
        frame.size.height = CGRectGetHeight(self.mainView.frame);
        shadowImageView.frame = frame;
        [self.mainView addSubview:shadowImageView];
    }
}

- (void)setState:(EPSSidebarManagerViewControllerState)state {
    _state = state;
    
    self.panRecognizer.enabled = state == EPSSidebarManagerViewControllerStateOpen;
    self.tapRecognizer.enabled = state == EPSSidebarManagerViewControllerStateOpen;
}

- (void)toggle:(id)sender {
    if (self.state == EPSSidebarManagerViewControllerStateClosed) {
        self.state = EPSSidebarManagerViewControllerStateOpen;
    }
    else {
        self.state = EPSSidebarManagerViewControllerStateClosed;
    }
    
    [self animateWithInitialVelocity:self.sidebarBehavior.velocity];
}

- (void)animateWithInitialVelocity:(CGPoint)initialVelocity {
    self.sidebarBehavior.targetPoint = self.targetPoint;
    self.sidebarBehavior.velocity = initialVelocity;
    [self.animator addBehavior:self.sidebarBehavior];
}

- (CGPoint)targetPoint {
    if (self.state == EPSSidebarManagerViewControllerStateClosed) {
        return self.view.center;
    }
    else {
        CGPoint point = self.view.center;
        point.x += self.openWidth;
        
        return point;
    }
}

- (void)didTap:(UITapGestureRecognizer *)tapRecognizer {
    [self toggle:tapRecognizer];
}

- (void)didPan:(UIPanGestureRecognizer *)panRecognizer {
    CGPoint point = [panRecognizer translationInView:self.view];
    self.mainView.center = CGPointMake(self.mainView.center.x + point.x, self.mainView.center.y);
    [panRecognizer setTranslation:CGPointZero inView:self.view];
    if (panRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [panRecognizer velocityInView:self.view];
        velocity.y = 0;
        
        if (velocity.x > 0) {
            self.state = EPSSidebarManagerViewControllerStateOpen;
        }
        else {
            self.state = EPSSidebarManagerViewControllerStateClosed;
        }
        
        [self animateWithInitialVelocity:velocity];
    } else if (panRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.animator removeAllBehaviors];
    }
}

#pragma mark - UIDynamicAnimatorDelegate Methods

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    
}

@end

@implementation UIViewController (EPSHamburger)

- (EPSSidebarManagerViewController *)sidebarManager {
    if ([self.parentViewController isKindOfClass:[EPSSidebarManagerViewController class]]) {
        return self.parentViewController;
    }
    else if (self.parentViewController == nil) {
        return nil;
    }
    else {
        return [self.parentViewController sidebarManager];
    }
}

@end