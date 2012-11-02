//
//  UIViewController+PartialModal.m
//  PartialModals
//
//  Created by Andres Lopez on 11/1/12.
//  Copyright (c) 2012 Bolted Games. All rights reserved.
//

#import "UIViewController+PartialModal.h"
#import "BGPartialModalTransition.h"
#import "BGPartialModalViewController.h"

// I don't like this. If anyone has a suggestion I would love to hear it.
static BGPartialModalTransition  *_transition;

@implementation UIViewController (PartialModal)

@dynamic transition;

- (void)setTransition:(BGPartialModalTransition *)transition
{
    _transition = transition;
}

- (BGPartialModalTransition *)transition
{
    return _transition;
}

#pragma mark - Present

- (void)presentViewController:(BGPartialModalViewController *)viewControllerToPresent
                 overlayColor:(UIColor *)overlayColor
                animationType:(Class)transitionClass
                   completion:(void (^)(void))completion
{
    self.transition = [[transitionClass alloc] init];
    self.transition.rootViewController = self;
    
    // create the overlay
    UIView *overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
    overlayView.backgroundColor = overlayColor;
    self.transition.overlayView = overlayView;
    [self.view addSubview:self.transition.overlayView];
    
    [self.transition performOverlayViewAnimationInCompletion:^{
        // capture an image of bg.
        // This method is used because it will help use the SDKs presentVC methods
        // TODO: test for performance, maybe move to new thread
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            UIGraphicsBeginImageContextWithOptions([self.view bounds].size, NO, [[UIScreen mainScreen] scale]);
        } else {
            UIGraphicsBeginImageContext([self.view bounds].size);
        }
        
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *overlayImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // prepare and present modal view controller
        viewControllerToPresent.backgroundOverlayImage = overlayImage;
        
        // animate in
        [self presentViewController:viewControllerToPresent animated:NO completion:^{
            self.transition.modalViewController = viewControllerToPresent;
            [self.transition performPartialModalAnimationPresent:YES Completion:completion];
        }];
    }];
}

#pragma mark - Dismiss

- (void)dismissViewController:(BGPartialModalViewController *)partialModalViewController
                animationType:(Class)transitionClass
                   completion:(void (^)(void))completion
{
    // animate out
    [self.transition performPartialModalAnimationPresent:NO Completion:^{
        [self dismissViewControllerAnimated:NO completion:^{
            [self.transition performOverlayViewAnimationOutCompletion:completion];
            self.transition = nil;
        }];
    }];
}

#pragma mark - Orientation change

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // TODO: revise this code
    if (self.transition) {
        self.transition.overlayView.frame = self.view.bounds;
        [self.transition.rootViewController dismissViewControllerAnimated:NO completion:^{
            // capture an image of bg.
            // This method is used because it will help use the SDKs presentVC methods
            // TODO: test for performance, maybe move to new thread
            if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
                UIGraphicsBeginImageContextWithOptions([self.transition.rootViewController.view bounds].size, NO, [[UIScreen mainScreen] scale]);
            } else {
                UIGraphicsBeginImageContext([self.transition.rootViewController.view bounds].size);
            }
            
            [self.transition.rootViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *overlayImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            // prepare and present modal view controller
            self.transition.modalViewController.backgroundOverlayImage = overlayImage;
            
            [self.transition.rootViewController presentViewController:self.transition.modalViewController animated:NO completion:nil];
        }];
    }
}

@end
