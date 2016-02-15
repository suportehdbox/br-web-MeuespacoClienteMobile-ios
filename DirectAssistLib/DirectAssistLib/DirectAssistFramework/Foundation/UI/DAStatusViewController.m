//
//  DAStatusViewController.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 13/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DAStatusViewController.h"

@implementation DAStatusViewController


- (id)initWithStatus:(NSString *)status {
	if (self = [self initWithNibName:@"DAStatusView" bundle:[NSBundle bundleForClass:[self class]]]) {
		textToDisplay = status;				
	}
	return self;
}

- (void)showInViewController:(UIViewController *)viewController {
	[viewController.view insertSubview:self.view aboveSubview:viewController.parentViewController.view];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	CGFloat width = self.view.frame.size.width;
	CGFloat height = self.view.frame.size.height + 6;
	CGRect frame = CGRectMake(0, 0, width, height);
	self.view.frame = frame;
	self.view.backgroundColor = [UIColor blackColor];
	statusText.text = textToDisplay;
}

- (void)dismiss {
	[self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}



@end
