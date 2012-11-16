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
                animationType:(BGPartialModalTransition *)transition
                   completion:(void (^)(void))completion
{
    self.transition = transition;
    self.transition.rootViewController = self;
    
    // create the overlay
    // get correct bounds
    CGRect overlayFrame = self.view.bounds;
    if (self.navigationController) {
        overlayFrame = self.navigationController.view.bounds;
        viewControllerToPresent.backgroundOverlayOffset = -20.0f; // to hide status bar
    }
    
    UIView *overlayView = [[UIView alloc] initWithFrame:overlayFrame];
    overlayView.backgroundColor = overlayColor;
    self.transition.overlayView = overlayView;
    
    // make sure if a navigation controller exists to cover the nav bar
    if (self.navigationController)
        [self.navigationController.view addSubview:self.transition.overlayView];
    else
        [self.view addSubview:self.transition.overlayView];
    
    [self.transition performOverlayViewAnimationInCompletion:^{
        // determine if the there is a navigation bar
        UIImage *overlayImage;
        if (self.navigationController)
            overlayImage = [self captureImageFromViewController:self.navigationController];
        else
            overlayImage = [self captureImageFromViewController:self];
        
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
                animationType:(BGPartialModalTransition *)transition
                   completion:(void (^)(void))completion
{
    UIView *overlayView = self.transition.overlayView;
    self.transition = transition;
    self.transition.rootViewController = self;
    self.transition.modalViewController = partialModalViewController;
    self.transition.overlayView = overlayView;
    
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

#pragma mark - Helpers

- (UIImage *)captureImageFromViewController:(UIViewController *)viewController
{
    // capture an image of bg.
    // This method is used because it will help use the SDKs presentVC methods
    // TODO: test for performance, maybe move to new thread
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions([viewController.view bounds].size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext([viewController.view bounds].size);
    }
    
    [viewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
