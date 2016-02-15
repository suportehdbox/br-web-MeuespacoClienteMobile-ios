//
//  KeyboardNavigationBar.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KeyboardNavigationBar.h"


@implementation KeyboardNavigationBar

@synthesize keyboardNavigationBarView;
@synthesize keyboardNavigationBar;
@synthesize keyboardPreviousButton;
@synthesize keyboardNextButton;

- (IBAction)keyboardNavigationBarPreviousPressed:(id)sender {}
- (IBAction)keyboardNavigationBarNextPressed:(id)sender {}
- (IBAction)keyboardNavigationBarDonePressed:(id)sender {}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.keyboardNavigationBarView = nil;
	self.keyboardNavigationBar = nil;
	self.keyboardPreviousButton = nil;
	self.keyboardNextButton = nil;
}


- (void)dealloc {
    [super dealloc];
	[keyboardNavigationBarView release];
	[keyboardNavigationBar release];
	[keyboardPreviousButton release];
	[keyboardNextButton release];
}


@end
