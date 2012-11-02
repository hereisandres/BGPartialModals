//
//  BGPartialModalTransition.m
//  PartialModals
//
//  Created by Andres Lopez on 11/2/12.
//  Copyright (c) 2012 Bolted Games. All rights reserved.
//

#import "BGPartialModalTransition.h"

@interface BGPartialModalTransition ()

@property (nonatomic, strong) UIView *modalView;
@property (nonatomic, strong) UIView *overlayView;

@end

@implementation BGPartialModalTransition

#pragma mark - Overlay view getters / setters

- (UIView *)overlayView
{
    if (_overlayView == nil)
    {
        _overlayView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f];
    }
    return _overlayView;
}

- (UIView *)getTheOverlayView
{
    return self.overlayView;
}

- (void)setOverlayColor:(UIColor *)color
{
    self.overlayView.backgroundColor = color;
}

#pragma mark - init methods

- (id)initWithModalView:(UIView *)modalView
{
    self = [super init];
    if (self) {
        _modalView = modalView;
    }
    return self;
}

- (void)initializeTransition
{
    self.overlayView.hidden = YES;
    self.modalView.hidden = YES;
}

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
    self.modalView.hidden = NO;
    completion();
}

- (void)performOutTransitionCompletion:(void (^)(void))completion
{
    // modal out
    self.modalView.hidden = YES;
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
