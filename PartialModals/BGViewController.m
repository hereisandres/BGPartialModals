//
//  BGViewController.m
//  PartialModals
//
//  Created by Andres Lopez on 11/1/12.
//  Copyright (c) 2012 Bolted Games. All rights reserved.
//

#import "BGViewController.h"
#import "BGPartialModalFadeTransition.h"

@interface BGViewController ()

@end

@implementation BGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.transitions = [NSArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:@"No Transition", @"title", [BGPartialModalTransition class], @"transitionClass", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"Fade Transition", @"title", [BGPartialModalFadeTransition class], @"transitionClass", nil],
                        nil];
}

- (void)showModal:(Class)transitionClass
{
    // initialize modal controller
    BGMyModalViewController *myModalController = [[BGMyModalViewController alloc] initWithNibName:@"BGMyModalViewController" bundle:nil];
    myModalController.delegate = self;
    // set to NO to disable closing modal when tapping on overlay
    myModalController.enableOverlayClose = YES;
    
    // present modal
    [self presentViewController:myModalController
                   overlayColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f] // overlay color with alpha
                  animationType:transitionClass // animation type
                     completion:^{
                         // some completion stuff here
                     }];
}

#pragma mark - Partial Modal Delegate

- (void)willClosePartialModal:(BGPartialModalViewController *)partialModal
{
    // dismiss modal with animation
    [self dismissViewController:partialModal
                  animationType:[BGPartialModalFadeTransition class]
                     completion:^{
        // some completion stuff here
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.transitions count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TransitionsCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // get title
    NSDictionary *transition = [self.transitions objectAtIndex:indexPath.row];
    cell.textLabel.text =[transition valueForKey:@"title"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    // show modal with transition
    NSDictionary *transition = [self.transitions objectAtIndex:indexPath.row];
    [self showModal:[transition valueForKey:@"transitionClass"]];
}

@end
