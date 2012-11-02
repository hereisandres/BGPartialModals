//
//  UIViewController+PartialModal.h
//  PartialModals
//
//  Created by Andres Lopez on 11/1/12.
//  Copyright (c) 2012 Bolted Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef void (^BGPartialModalAnimationCompletion)(void);

typedef enum {
    BGPartialModalAnimationNone = 0,
    BGPartialModalAnimationFade,
    BGPartialModalAnimationBounce
} BGPartialModalAnimation;

@class BGPartialModalViewController;

@interface UIViewController (PartialModal)

- (void)presentViewController:(BGPartialModalViewController *)viewControllerToPresent
                 overlayColor:(UIColor *)overlayColor
                animationType:(BGPartialModalAnimation)animationType
                   completion:(void (^)(void))completion;

- (void)dismissViewController:(BGPartialModalViewController *)partialModalViewController
                AnimationType:(BGPartialModalAnimation)animationType
                   completion:(void (^)(void))completion;

@end
