//
//  DADealersListViewController.m
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 8/3/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DADealersListViewController.h"
#import "DAWebServiceActionResult.h"
#import "DAAccessLog.h"

@implementation DADealersListViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.title = DALocalizedString(@"Dealers", nil);
	self.contactViewTitle = DALocalizedString(@"Dealer", nil);
}

- (void)loadContacts {
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES]; 

	// configure and start the webserver 
	DADealersListWS *dealersListWS = [[DADealersListWS alloc] init];
	[dealersListWS setDelegate:self];
	[dealersListWS listDealersWithCoordinate:super.searchReferenceCoordinate];
	
}

#pragma mark DADealersListWSDelegate methods

- (void)dealersList:(DADealersListWS *)dealersList didListDealers:(NSMutableArray *)dealers {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	DAWebServiceActionResult *actionResult = [[DAWebServiceActionResult alloc] init];
	actionResult.actionType = kDAActionListDealers;	
	actionResult.resultType = kDAResultSuccess;
	
	[DAAccessLog saveAccessLog:actionResult];
	
	[self showContacts:dealers];
}

- (void)dealersList:(DADealersListWS *)dealersList didFailWithErrorMessage:(NSString *)errorMessage {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	UIAlertView *locationErrorAlert = [[UIAlertView alloc] 
									   initWithTitle:DALocalizedString(@"CantLoadDealers", nil)
									   message:errorMessage 
									   delegate:nil cancelButtonTitle:nil
									   otherButtonTitles:@"OK", nil];
	[locationErrorAlert show];
}

@end
