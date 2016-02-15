//
//  DAContactViewController.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/15/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAContactViewController.h"
#import "DAContactListViewController.h"
#import "DAContactMapViewController.h"
#import "DAContactItemViewController.h"
#import "DAAddressFinderViewController.h"
#import "DAUserLocation.h"
#import "DAAddress.h"

@implementation DAContactViewController

@synthesize contactViewTitle;

- (id)init {
	
	if (self = [super initWithNibName:@"DAContactViewController" bundle:[NSBundle bundleForClass:[self class]]]) {
	}
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

   // toolbar.tintColor = [UIColor redColor];
	toolbar.tintColor = [[AppConfig sharedConfiguration].appClient defaultColor];
	viewType.tintColor = toolbar.tintColor;
	
	listVC = [[DAContactListViewController alloc] initWithNibName:@"DAContactListViewController" bundle:[NSBundle bundleForClass:[self class]]];
	listVC.delegate = self;
	listVC.view.bounds = CGRectMake(0, 0, contentView.bounds.size.width, contentView.bounds.size.height);
	listVC.view.frame = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);

	mapVC = [[DAContactMapViewController alloc] initWithNibName:@"DAContactMapViewController" bundle:[NSBundle bundleForClass:[self class]]];
	mapVC.delegate = self;
	mapVC.view.bounds = CGRectMake(0, 0, contentView.bounds.size.width, contentView.bounds.size.height);
	mapVC.view.frame = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
	mapVC.showLocationPin = NO;
	
//	arVC = [[TTARViewController alloc] init];
//	arVC.view.bounds = CGRectMake(0, 0, contentView.bounds.size.width, contentView.bounds.size.height);
//	arVC.view.frame = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
	
	[viewType setTitle:DALocalizedString(@"Map", nil) forSegmentAtIndex:0];
	[viewType setTitle:DALocalizedString(@"List", nil) forSegmentAtIndex:1];
	[searchButton setTitle:DALocalizedString(@"Search", nil)];
	
	[self changeView:0];
	[self loadContacts];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    mapVC.view.bounds = CGRectMake(0, 0, contentView.bounds.size.width, contentView.bounds.size.height);
    mapVC.view.frame = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
    listVC.view.bounds = CGRectMake(0, 0, contentView.bounds.size.width, contentView.bounds.size.height);
    listVC.view.frame = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	//NSLog(@"viewDidAppear");
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	//NSLog(@"viewWillDisappear");
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	//NSLog(@"viewDidDisappear");
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
	//NSLog(@"viewDidUnload");
}

#pragma mark UI events

- (IBAction)viewTypeChanged:(id)sender {
	[self changeView:viewType.selectedSegmentIndex];
}

- (IBAction)searchButtonTapped:(id)sender {
	
	if (![Utility hasInternet]) {			
		[Utility showNoInternetWarning];
		return;
	}
	
	DAAddressFinderViewController *addressFinderVC = [[DAAddressFinderViewController alloc] initWithNibName:@"DAAddressFinderViewController" bundle:[NSBundle bundleForClass:[self class]]];
	addressFinderVC.delegate = self;
	[self.navigationController pushViewController:addressFinderVC animated:YES];
}

- (void)changeView:(int)index {
	switch (index) {
		case 0:
			[listVC.view removeFromSuperview];
			[contentView addSubview:mapVC.view];
			//[arVC stopAR];
			break;
		case 1:
			[mapVC.view removeFromSuperview];
			[contentView addSubview:listVC.view];
			//[arVC stopAR];
			break;
//		case 2:
//			[mapVC.view removeFromSuperview];
//			[listVC.view removeFromSuperview];
//			[contentView addSubview:arVC.view];
//			[arVC startAR];
//			break;
	}
}

- (CLLocationCoordinate2D)searchReferenceCoordinate {

	if (searchReferenceCoordinate.latitude == 0 ||
		searchReferenceCoordinate.longitude == 0) {
		
		searchReferenceCoordinate = [DAUserLocation currentLocation].coordinate;
	}
	
	return searchReferenceCoordinate;
}

- (void)loadContacts {
	
}

- (void)showContacts:(NSArray *)contacts {

	mapVC.searchReferenceCoordinate = self.searchReferenceCoordinate;
	[mapVC showContacts:contacts];

	listVC.searchReferenceCoordinate = self.searchReferenceCoordinate;
	[listVC showContacts:contacts];
	
//	arVC.placemarks = contacts;
}

- (void)pushContactView:(DAContact *)contact {

	DAContactItemViewController *contactVC = [[DAContactItemViewController alloc] initWithContact:contact viewTitle:contactViewTitle];
	[self.navigationController pushViewController:contactVC animated:YES];
}

#pragma mark DAContactMapViewControllerDelegate methods

- (void)contactMapViewController:(DAContactMapViewController *)contactMapViewController didSelectContact:(DAContact *)contact {
	[self pushContactView:contact];
}

#pragma mark DAContactListViewControllerDelegate methods

- (void)contactListViewController:(DAContactListViewController *)contactMapViewController didSelectContact:(DAContact *)contact {
	[self pushContactView:contact];
}

#pragma mark DAAddressFinderViewControllerDelegate methods

- (void)addressFinderViewController:(DAAddressFinderViewController *)addressFinderViewController didSelectAddress:(DAAddress *)selectedAddress {
	
	[addressFinderViewController.navigationController popViewControllerAnimated:YES];
	mapVC.showLocationPin = YES;
	searchReferenceCoordinate = selectedAddress.coordinate;
	[self loadContacts];
}





@end
