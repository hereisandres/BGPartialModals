//
//  BGPartialModalSlideUnderTransition.m
//  PartialModals
//
//  Created by Andres Lopez on 11/14/12.
//  Copyright (c) 2012 Bolted Games. All rights reserved.
//

#import "BGPartialModalSlideUnderTransition.h"

@interface BGPartialModalSlideUnderTransition () {
    CGRect _rootFrame;
}

@end

@implementation BGPartialModalSlideUnderTransition

#pragma mark - Perform animations
/**
 * Override these methods in your custom transtion subclasses.
 * By default there will be no animation just a simple display.
 */

- (void)performInTransitionCompletion:(void (^)(void))completion
{
    // prepare animations
    [self.modalViewController.view sendSubviewToBack:self.modalViewController.modalView];
    _rootFrame = [self.modalViewController backgroundOverlay].frame;
    
    [UIView animateWithDuration:.2
                          delay:0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         [self.modalViewController backgroundOverlay].frame = CGRectMake(_rootFrame.origin.x + self.slideWith, _rootFrame.origin.y, _rootFrame.size.width, _rootFrame.size.height);
                     } completion:^(BOOL finished) {
                         completion();
                     }];
}

- (void)performOutTransitionCompletion:(void (^)(void))completion
{
    _rootFrame = [self.modalViewController backgroundOverlay].frame;
    
    // modal out
    [UIView animateWithDuration:.2
                          delay:0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         [self.modalViewController backgroundOverlay].frame = CGRectMake(_rootFrame.origin.x + self.slideWith, _rootFrame.origin.y, _rootFrame.size.width, _rootFrame.size.height);;
                     } completion:^(BOOL finished) {
                         completion();
                     }];
}

/**
 * Override for custom overlay transitions
 */

- (void)performOverlayViewAnimationInCompletion:(void (^)(void))completion
{
    // Show no overlay
    self.overlayView.hidden = YES;
    completion();
}

- (void)performOverlayViewAnimationOutCompletion:(void (^)(void))completion
{
    // Show no overlay
    self.overlayView.hidden = YES;
    completion();
}

@end
