//
//  UIViewController+PartialModal.h
//  PartialModals
//
//  Created by Andres Lopez on 11/1/12.
//  Copyright (c) 2012 Bolted Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class BGPartialModalViewController, BGPartialModalTransition;

@interface UIViewController (PartialModal)

@property (nonatomic, strong) BGPartialModalTransition *transition;

- (void)presentViewController:(BGPartialModalViewController *)viewControllerToPresent
                 overlayColor:(UIColor *)overlayColor
                animationType:(Class)transitionClass
                   completion:(void (^)(void))completion;

- (void)dismissViewController:(BGPartialModalViewController *)partialModalViewController
                animationType:(Class)transitionClass
                   completion:(void (^)(void))completion;

@end
