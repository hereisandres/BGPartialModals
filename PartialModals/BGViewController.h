//
//  BGViewController.h
//  PartialModals
//
//  Created by Andres Lopez on 11/1/12.
//  Copyright (c) 2012 Bolted Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGMyModalViewController.h"

@interface BGViewController : UIViewController <BGPartialModalDelegate>

- (IBAction)showModalPressed:(id)sender;

@end
