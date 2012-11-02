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
    self.transition = [[transitionClass alloc] initWithModalView:viewControllerToPresent.modalView];
    
    // create the overlay
    [self.transition setOverlayColor:overlayColor];
    [self.transition initializeTransition];
    [self.view addSubview:[self.transition getTheOverlayView]];
    
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
        }];
    }];
}

@end
