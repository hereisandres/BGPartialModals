//
//  BGPartialModalViewController.h
//  PartialModals
//
//  Created by Andres Lopez on 11/1/12.
//  Copyright (c) 2012 Bolted Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+PartialModal.h"

@class BGPartialModalViewController;

@protocol BGPartialModalDelegate

- (void)willClosePartialModal:(BGPartialModalViewController *)partialModal;

@end

@interface BGPartialModalViewController : UIViewController

@property (nonatomic, weak) id<BGPartialModalDelegate> delegate;

@property (nonatomic, strong) UIImage *backgroundOverlayImage;
@property (nonatomic, strong) IBOutlet UIView *modalView;
@property (nonatomic) BOOL enableOverlayClose;
@property (nonatomic) CGFloat backgroundOverlayOffset;

- (UIImageView *)backgroundOverlay;

@end
