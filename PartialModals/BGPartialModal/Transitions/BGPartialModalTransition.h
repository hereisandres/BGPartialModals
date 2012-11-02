//
//  BGPartialModalTransition.h
//  PartialModals
//
//  Created by Andres Lopez on 11/2/12.
//  Copyright (c) 2012 Bolted Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGPartialModalViewController.h"

@protocol BGPartialModalTransitionDelegate

- (void)partialModalTransitionDidCompleteAnimation;

@end

@interface BGPartialModalTransition : NSObject

@property (nonatomic, weak) id<BGPartialModalTransitionDelegate> delegate;

@property (nonatomic, weak) BGPartialModalViewController *modalViewController;
@property (nonatomic, weak) UIViewController *rootViewController;
@property (nonatomic, weak) UIView *overlayView;

- (void)performPartialModalAnimationPresent:(BOOL)flag Completion:(void (^)(void))completion;

- (void)performOverlayViewAnimationInCompletion:(void (^)(void))completion;
- (void)performOverlayViewAnimationOutCompletion:(void (^)(void))completion;

@end
