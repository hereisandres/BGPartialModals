//
//  BGPartialModalViewController.m
//  PartialModals
//
//  Created by Andres Lopez on 11/1/12.
//  Copyright (c) 2012 Bolted Games. All rights reserved.
//

#import "BGPartialModalViewController.h"

@interface BGPartialModalViewController ()

@property (nonatomic, strong) UIImageView *backgroundOverlay;
@property (nonatomic, strong) UITapGestureRecognizer *overlayCloseGestureRecognizer;

@end

@implementation BGPartialModalViewController

- (void)setBackgroundOverlayImage:(UIImage *)backgroundOverlayImage
{
    _backgroundOverlayImage = backgroundOverlayImage;
    self.backgroundOverlay.image = backgroundOverlayImage;
    [self.backgroundOverlay sizeToFit];
}

- (void)setEnableOverlayClose:(BOOL)enableOverlayClose
{
    _enableOverlayClose = enableOverlayClose;
    
    // remove or add overlay tap gesture recognizer
    if (enableOverlayClose)
        [self.backgroundOverlay addGestureRecognizer:self.overlayCloseGestureRecognizer];
    else
        [self.backgroundOverlay removeGestureRecognizer:self.overlayCloseGestureRecognizer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // add pseudo modal views
    self.backgroundOverlay = [[UIImageView alloc] initWithImage:self.backgroundOverlayImage];
    self.backgroundOverlay.userInteractionEnabled = YES;
    
    // ensure that there is not extra status bar space on top
    self.backgroundOverlay.frame = CGRectMake(0, self.backgroundOverlayOffset, self.backgroundOverlayImage.size.width, self.backgroundOverlayImage.size.height);
    
    // add the overlay
    [self.view addSubview:self.backgroundOverlay];
    
    [self.view bringSubviewToFront:self.modalView];
    
    // create the overlay tap gesture recognizer
    self.overlayCloseGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(closeModal:)];
    if (self.enableOverlayClose)
        [self.backgroundOverlay addGestureRecognizer:self.overlayCloseGestureRecognizer];
}

- (void)closeModal:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.delegate willClosePartialModal:self];
}

@end
