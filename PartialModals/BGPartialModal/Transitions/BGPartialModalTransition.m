//
//  BGPartialModalTransition.m
//  PartialModals
//
//  Created by Andres Lopez on 11/2/12.
//  Copyright (c) 2012 Bolted Games. All rights reserved.
//

#import "BGPartialModalTransition.h"

@interface BGPartialModalTransition ()

@end

@implementation BGPartialModalTransition

/**
 * Delegate between in and out animations.
 */
- (void)performPartialModalAnimationPresent:(BOOL)flag Completion:(void (^)(void))completion
{
    if (flag)
        [self performInTransitionCompletion:completion];
    else
        [self performOutTransitionCompletion:completion];
}

#pragma mark - Perform animations
/**
 * Override these methods in your custom transtion subclasses.
 * By default there will be no animation just a simple display.
 */

- (void)performInTransitionCompletion:(void (^)(void))completion
{
    // modal in
    self.modalViewController.modalView.hidden = NO;
    completion();
}

- (void)performOutTransitionCompletion:(void (^)(void))completion
{
    // modal out
    self.modalViewController.modalView.hidden = YES;
    completion();
}

/**
 * Override for custom overlay transitions
 */

- (void)performOverlayViewAnimationInCompletion:(void (^)(void))completion
{
    self.overlayView.hidden = NO;
    completion();
}

- (void)performOverlayViewAnimationOutCompletion:(void (^)(void))completion
{
    self.overlayView.hidden = YES;
    completion();
}

@end
