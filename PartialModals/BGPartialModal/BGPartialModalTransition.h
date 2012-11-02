//
//  BGPartialModalTransition.h
//  PartialModals
//
//  Created by Andres Lopez on 11/2/12.
//  Copyright (c) 2012 Bolted Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BGPartialModalTransitionDelegate

- (void)partialModalTransitionDidCompleteAnimation;

@end

@interface BGPartialModalTransition : NSObject

@property (nonatomic, weak) id<BGPartialModalTransitionDelegate> delegate;

- (id)initWithModalView:(UIView *)modalView;
- (void)initializeTransition;
- (void)performPartialModalAnimationPresent:(BOOL)flag Completion:(void (^)(void))completion;

- (void)performOverlayViewAnimationInCompletion:(void (^)(void))completion;
- (void)performOverlayViewAnimationOutCompletion:(void (^)(void))completion;

- (UIView *)getTheOverlayView;
- (void)setOverlayColor:(UIColor *)color;

@end
