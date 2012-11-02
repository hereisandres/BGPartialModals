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
    [self.view addSubview:self.backgroundOverlay];
    
    self.modalView.hidden = YES;
    [self.view addSubview:self.modalView];
    
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
