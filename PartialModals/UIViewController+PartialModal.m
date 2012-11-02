//
//  UIViewController+PartialModal.m
//  PartialModals
//
//  Created by Andres Lopez on 11/1/12.
//  Copyright (c) 2012 Bolted Games. All rights reserved.
//

#import "UIViewController+PartialModal.h"
#import "BGPartialModalViewController.h"


@implementation UIViewController (PartialModal)

#pragma mark - Constants

const NSUInteger kOverlayViewTag = 5110;

#pragma mark - Present

- (void)presentViewController:(BGPartialModalViewController *)viewControllerToPresent
                 overlayColor:(UIColor *)overlayColor
                animationType:(BGPartialModalAnimation)animationType
                   completion:(void (^)(void))completion
{
    // create the overlay
    UIView *overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
    overlayView.tag = kOverlayViewTag;
    overlayView.backgroundColor = overlayColor;
    [self.view addSubview:overlayView];
    
    // animate overlay in
    overlayView.alpha = 0.0f;
    [UIView animateWithDuration:.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         overlayView.alpha = 1.0f;
                     } completion:^(BOOL finished) {
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
                         [self presentViewController:viewControllerToPresent animated:NO completion:^{
                             // preform animations
                             switch (animationType) {
                                 case BGPartialModalAnimationFade:
                                     [self performPartialModalAnimationFade:viewControllerToPresent.modalView completion:completion];
                                     break;
                                 case BGPartialModalAnimationBounce:
                                     [self performPartialModalAnimationBounce:viewControllerToPresent.modalView completion:completion];
                                     break;
                                     
                                 default:
                                     viewControllerToPresent.modalView.hidden = NO;
                                     break;
                             }
                         }];
                     }];
}

- (void)performPartialModalAnimationFade:(UIView *)modal completion:(void (^)(void))completion
{
    // animate in
    if (modal.hidden)
    {
        modal.alpha = 0.0f;
        modal.hidden = NO;
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             modal.alpha = 1.0f;
                         } completion:^(BOOL finished) {
                             completion();
                         }];
    }
    
    // animate out
    else
    {
        modal.alpha = 1.0f;
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             modal.alpha = 0.0f;
                         } completion:^(BOOL finished) {
                             modal.hidden = YES;
                             completion();
                         }];
    }
}

- (void)performPartialModalAnimationBounce:(UIView *)modal completion:(void (^)(void))completion
{
    // animate in
    if (modal.hidden)
    {
        modal.hidden = NO;
        // thanks to http://stackoverflow.com/a/4200005/1470647
        modal.alpha = 0;
        [UIView animateWithDuration:0.1 animations:^{modal.alpha = 1.0;}];
        
        modal.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
        
        CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        bounceAnimation.values = [NSArray arrayWithObjects:
                                  [NSNumber numberWithFloat:0.5],
                                  [NSNumber numberWithFloat:1.1],
                                  [NSNumber numberWithFloat:0.8],
                                  [NSNumber numberWithFloat:1.0], nil];
        bounceAnimation.duration = 0.3;
        bounceAnimation.removedOnCompletion = NO;
        [modal.layer addAnimation:bounceAnimation forKey:@"bounce"];
        
        modal.layer.transform = CATransform3DIdentity;
        
        // trigger completion after animation is done
        [NSTimer timerWithTimeInterval:bounceAnimation.duration target:self selector:@selector(bounceAnimationComplete:) userInfo:completion repeats:NO];
    }

    // animate out
    else
    {
        // thanks to http://stackoverflow.com/a/4200005/1470647
        modal.alpha = 1.0;
        [UIView animateWithDuration:0.1 animations:^{modal.alpha = 0.0;}];
        
        modal.layer.transform = CATransform3DMakeScale(1.0, 0.5, 0.5);
        
        CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        bounceAnimation.values = [NSArray arrayWithObjects:
                                  [NSNumber numberWithFloat:1.0],
                                  [NSNumber numberWithFloat:0.8],
                                  [NSNumber numberWithFloat:1.1],
                                  [NSNumber numberWithFloat:0.5], nil];
        bounceAnimation.duration = 0.3;
        bounceAnimation.removedOnCompletion = NO;
        bounceAnimation.delegate = self;
        
        [CATransaction setCompletionBlock:^{completion();}];
        [modal.layer addAnimation:bounceAnimation forKey:@"bounce"];
        [CATransaction commit];
        
        modal.layer.transform = CATransform3DIdentity;
    }
}

- (void)performOverlayOutAnimation
{
    // find and fade overlay out
    __block UIView *overlayView = [self.view viewWithTag:kOverlayViewTag];
    [UIView animateWithDuration:.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         overlayView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         // clean up
                         [overlayView removeFromSuperview];
                         overlayView = nil;
                     }];
}

#pragma mark - Dismiss

- (void)dismissViewController:(BGPartialModalViewController *)partialModalViewController
                AnimationType:(BGPartialModalAnimation)animationType
                   completion:(void (^)(void))completion
{
    // preform animations
    switch (animationType) {
        case BGPartialModalAnimationFade: {
            [self performPartialModalAnimationFade:partialModalViewController.modalView completion:^{
                [self dismissViewControllerAnimated:NO completion:completion];
                [self performOverlayOutAnimation];
            }];
            break;
        }
        case BGPartialModalAnimationBounce: {
            [self performPartialModalAnimationBounce:partialModalViewController.modalView completion:^{
                [self dismissViewControllerAnimated:NO completion:completion];
                [self performOverlayOutAnimation];
            }];
            break;
        }
            
        default:
            [self dismissViewControllerAnimated:NO completion:^{
                [self performOverlayOutAnimation];
                completion();
            }];
            break;
    }
}

@end
