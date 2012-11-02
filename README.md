We have all been in situations where designers think an app should behave as a website does. Especially, when you see designs with bunch of modals. BGPartialModals to the rescue! BGPartialModals makes presenting a web like modals easy for iOS.

## Get Started
[Download](https://github.com/lopeza511/BGPartialModals/zipball/master) the files and run the demo App and check out the source code. Check out the [docs](https://github.com/lopeza511/BGPartialModals/wiki).

### Requirements
- iOS 4.3+
- QuartzCore.framework
- ARC

### Quick Start (TL;DR)
1. Link against the **QuartzCore.framework**
1. Add the BGPartialModal source folder to your project. Make sure you have **Copy items into destination group's folder** checked. Also, check your target in the **Add to targets** view.
1. Create a new Objective-C class and make it a subclass of **BGPartialModalViewController**. Make sure the **With XIB for user interface** is checked.
1. In the XIB file do the following:
    1. Drag and drop a new UIView into your main view.
    1. Reference it to the **modalView** outlet.
    1. Customize your modal view however you like.
1. Do the following in the view controller where you will present the modal:
    1. Open the view controller's header file and add:
        - `#import "BGPartialModalFadeTransition.h"` (replace with a transition of your choice).
        - Don't forget to import your modal view controller.
    1. Open the view controller's main file and add something similar to the following lines of code in your action method:
        ``` objective-c
        // initialize modal view controller
        MyModalViewController *myModalController = [[MyModalViewController alloc] initWithNibName:@"MyModalViewController" bundle:nil];
        myModalController.enableOverlayClose = YES;
        
        // present modal
        [self presentViewController:myModalController
                       overlayColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.75f] // overlay color with alpha
                      animationType:[BGPartialModalFadeTransition class] // animation type
                         completion:^{
                             // some completion stuff here
                         }];
        ```
    1. Create an action to launch your modal, compile and run!

## Available Transitions
- **BGPartialModalTransition**: This is the father of all transitions. Feel free to subclass it to create your own awesome transitions.
- **BGPartialModalFadeTransition**: A simple fade transition.

More transitions are needed! Feel free to contribute or suggest any code.

## TODO
- Add more transitions
- Add nice UI, and cool demo
- Create an iPad demo
- Write better documentaion
- Create visual tutorial, maybe a video