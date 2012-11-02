//
//  BGViewController.m
//  PartialModals
//
//  Created by Andres Lopez on 11/1/12.
//  Copyright (c) 2012 Bolted Games. All rights reserved.
//

#import "BGViewController.h"
#import "BGPartialModalTransition.h"

@interface BGViewController ()

@end

@implementation BGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showModalPressed:(id)sender
{
    // initialize modal controller
    BGMyModalViewController *myModalController = [[BGMyModalViewController alloc] initWithNibName:@"BGMyModalViewController" bundle:nil];
    myModalController.delegate = self;
    // set to YES to enable close modal when tapping on overlay
    myModalController.enableOverlayClose = NO;
    
    // present modal
    [self presentViewController:myModalController
                   overlayColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f] // overlay color with alpha
                  animationType:[BGPartialModalTransition class] // animation type
                     completion:^{
                         // some completion stuff here
                     }];
}

#pragma mark - Partial Modal Delegate

- (void)willClosePartialModal:(BGPartialModalViewController *)partialModal
{
    // dismiss modal with animation
    [self dismissViewController:partialModal
                  animationType:[BGPartialModalTransition class]
                     completion:^{
        // some completion stuff here
    }];
}

@end
