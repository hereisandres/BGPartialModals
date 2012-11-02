//
//  BGMyModalViewController.m
//  PartialModals
//
//  Created by Andres Lopez on 11/1/12.
//  Copyright (c) 2012 Bolted Games. All rights reserved.
//

#import "BGMyModalViewController.h"

@interface BGMyModalViewController ()

@end

@implementation BGMyModalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // add a nice shadow
    self.modalView.layer.shadowOpacity = 0.8;
    self.modalView.layer.shadowOffset = CGSizeMake(0, 0);
    self.modalView.layer.masksToBounds = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeModalPressed:(id)sender
{
    [self.delegate willClosePartialModal:self];
}

@end
