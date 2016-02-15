//
//  DAAppInfoViewController.m
//  DirectAssistHyundai
//
//  Created by Cadu on 3/4/10.
//  Copyright 2010 Mondial Assistance. All rights reserved.
//

#import "DAAppInfoViewController.h"

@interface DAAppInfoViewController (PrivateMethods)

- (void)contactButtonPressed;
- (void)doneButtonPressed;

@end

@implementation DAAppInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"Sobre o aplicativo";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(contactButtonPressed)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];

	// paint the navigation bar with the client default color
	self.navigationController.navigationBar.tintColor = [[AppConfig sharedConfiguration].appClient defaultColor];

//	_bgImageView.image = [UIImage imageNamed:@"PoweredBy.png"];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIImage *image = [UIImage imageNamed:@"PoweredBy.png" inBundle:bundle compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
    _bgImageView.image = image;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



#pragma mark buttons

- (void)contactButtonPressed {
	
	MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
	mailVC.mailComposeDelegate = self;
	mailVC.navigationBar.tintColor = [[AppConfig sharedConfiguration].appClient defaultColor];
	[mailVC setSubject:@"Comentários"];
	[mailVC setToRecipients:[NSArray arrayWithObject:@"iphone@mondial-assistance.com.br"]];
	[self.navigationController presentModalViewController:mailVC animated:YES];
}

- (void)doneButtonPressed {
	
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	
	[self dismissModalViewControllerAnimated:YES];
}



@end
