We have all been in situations where designers think an app should behave as a website. BGPartialModals makes presenting a web like modals for iOS easy!

Feel free to contribute or suggest any code.

## How To Get Started
[Download](https://github.com/lopeza511/BGPartialModals/zipball/master) the files and run the demo App.

### Requirements
- iOS 4+
- QuartzCore.framework

### Steps
1. Copy the following files into your project:
	1. **UIViewController+PartialModal.h**
	1. **UIViewController+PartialModal.m**
	1. **BGPartialModalViewController.h**
	1. **BGPartialModalViewController.m**
1. Add a new class file that subclasses **BGPartialModalViewController**.
1. If using a xib file:
	1. Drag a UIView into your the main view.
	1. Reference it to **modalView**.
	1. Customize like you wish.
1. If no xib file:
	1. In your newly created modal view controller's `viewDidLoad:` customize/add views to `self.modalView`.
1. **Optional:** Add a UIButton however you please and configure it's actions like so:
``` objective-c
- (IBAction)closeModalPressed:(id)sender
{
    [self.delegate willClosePartialModal:self];
}
```
1. In your main view controller's header (or where ever you will be calling the modal) include:
	1. **BGMyModalViewController.h**
	1. and add `<BGPartialModalDelegate>`
1. Your main view controller will need the following:
``` objective-c
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
                  animationType:BGPartialModalAnimationBounce // animation type
                     completion:^{
                         // some completion stuff here
                     }];
}
```
``` objective-c
- (void)willClosePartialModal:(BGPartialModalViewController *)partialModal
{
    // dismiss modal with animation
    [self dismissViewController:partialModal AnimationType:BGPartialModalAnimationFade completion:^{
        // some completion stuff here
    }];
}
```

### Animation Options
Currently there are three available options to choose from: **BGPartialModalAnimationNone**, **BGPartialModalAnimationFade**, and **BGPartialModalAnimationBounce**.

## TODO
1. Add more animations
1. Add nice UI
1. Write better documentaion
1. Create visual tutorial, maybe a video