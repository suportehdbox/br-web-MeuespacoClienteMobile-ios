//
//  DAAccreditedGaragesViewController.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/1/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAAccreditedGaragesViewController.h"
#import "DAUserLocation.h"
#import "DAAccreditedGarage.h"
#import "DAUserLocationAnnotation.h"
#import "DAAddress.h"
#import "DAWebServiceActionResult.h"
#import "DAAccessLog.h"

@implementation DAAccreditedGaragesViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.title = DALocalizedString(@"AccreditedGarages", nil);
	self.contactViewTitle = DALocalizedString(@"Garage", nil);
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *menuButton = [Utility addCustomButtonNavigationBar:self action:@selector(btnMenu:) imageName:@"btn-menu.png"];
    self.navigationItem.leftBarButtonItem = menuButton;
}

- (IBAction)btnMenu:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadContacts {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES]; 
	
	// configure and start the webserver 
	DAAccreditedGaragesManager *garagesManager = [[DAAccreditedGaragesManager alloc] init];
	[garagesManager setDelegate:self];
	[garagesManager findAccreditedGaragesWithClientID:[AppConfig client].clientID
									 withCoordinate:super.searchReferenceCoordinate];
	
}

#pragma mark AccreditedGaragesViewControllerWS methods

- (void)accreditedGaragesManager:(DAAccreditedGaragesManager *)manager didFindAccreditedGarages:(NSMutableArray *)foundGarages {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	DAWebServiceActionResult *actionResult = [[DAWebServiceActionResult alloc] init];
	actionResult.actionType = kDAActionListAccreditedGarages;	
	actionResult.resultType = kDAResultSuccess;
	
	[DAAccessLog saveAccessLog:actionResult];
	
	[self showContacts:foundGarages];
}

- (void)accreditedGaragesManagerDidNotFindAccreditedGarages:(DAAccreditedGaragesManager *)manager {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void)accreditedGaragesManager:(DAAccreditedGaragesManager *)manager didFailWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	UIAlertView *locationErrorAlert = [[UIAlertView alloc] 
									   initWithTitle:@"Não foi possível obter as Oficinas Referenciadas" 
									   message:@"Tente novamente." 
									   delegate:self cancelButtonTitle:nil
									   otherButtonTitles:@"OK", nil];
	[locationErrorAlert show];
}

- (void)accreditedGaragesManagerDidFailWithNoInternetConnection:(DAAccreditedGaragesManager *)manager {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Não foi possível obter as Oficinas Referenciadas" 
														 message:@"O sistema não está conectado a Internet." 
														delegate:self cancelButtonTitle:nil
											   otherButtonTitles:@"OK", nil];
	[errorAlert show];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}




@end
