//
//  BGPartialModalFadeTransition.m
//  PartialModals
//
//  Created by Andres Lopez on 11/2/12.
//  Copyright (c) 2012 Bolted Games. All rights reserved.
//

#import "BGPartialModalFadeTransition.h"

@implementation BGPartialModalFadeTransition

#pragma mark - Perform animations
/**
 * Override these methods in your custom transtion subclasses.
 * By default there will be no animation just a simple display.
 */

- (void)performInTransitionCompletion:(void (^)(void))completion
{
    // modal in
    self.modalView.hidden = NO;
    self.modalView.alpha = 0.0f;
    
    [UIView animateWithDuration:.2
                          delay:0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         self.modalView.alpha = 1.0f;
                     } completion:^(BOOL finished) {
                         completion();
                     }];
}

- (void)performOutTransitionCompletion:(void (^)(void))completion
{
    // modal out
    [UIView animateWithDuration:.2
                          delay:0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         self.modalView.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                         self.modalView.hidden = YES;
                         completion();
                     }];
}

/**
 * Override for custom overlay transitions
 */

- (void)performOverlayViewAnimationInCompletion:(void (^)(void))completion
{
    self.overlayView.hidden = NO;
    self.overlayView.alpha = 0.0f;
    
    [UIView animateWithDuration:.1
                          delay:0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         self.overlayView.alpha = 1.0f;
                     } completion:^(BOOL finished) {
                         completion();
                     }];
}

- (void)performOverlayViewAnimationOutCompletion:(void (^)(void))completion
{
    [UIView animateWithDuration:.2
                          delay:0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         self.overlayView.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                         self.overlayView.hidden = YES;
                         completion();
                     }];
}

@end
