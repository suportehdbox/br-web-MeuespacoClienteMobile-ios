//
//  ServiceOnMapViewController.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 18/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DAServiceOnMapViewController.h"
#import "DAServiceDispatch.h"
#import "DAAutomotiveFile.h"
#import "DAStatusViewController.h"
#import "DAContact.h"
#import "DAAddress.h"

@implementation DAServiceOnMapViewController

@synthesize selectedFile, selectedDispatch;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	dispatchFinder = [[DAServiceDispatchFinder alloc] init];
	dispatchFinder.delegate = self;
}

-(void) btnRefresh_Clicked:(id)sender {
}

-(void) loadMap {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];	

}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark serviceDispatchFinderDelegate methods

- (void)serviceDispatchFinder:(DAServiceDispatchFinder *)dispatchFinder didFindServiceDispatch:(DAServiceDispatch *)dispatch {

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];	

	if ([dispatch.dispatchChannel isEqualToString:@"3"] && 
		([dispatch.dispatchStatus isEqualToString:@"5"] || [dispatch.dispatchStatus isEqualToString:@"6"])) {

		DAContact *provider = [[DAContact alloc] init];
		provider.name = dispatch.vehiclePlate;
				
		CLLocationCoordinate2D providerCoordinate;
		providerCoordinate.latitude = [dispatch.providerLatitude doubleValue];
		providerCoordinate.longitude = [dispatch.providerLongitude doubleValue];
		
		DAAddress *providerAddress = [[DAAddress alloc] init];
		providerAddress.coordinate = providerCoordinate;
		provider.address = providerAddress;
		
		CLLocationCoordinate2D vehicleCoordinate;
		vehicleCoordinate.latitude = [dispatch.clientLatitude doubleValue];
		vehicleCoordinate.longitude = [dispatch.clientLongitude doubleValue];
		//searchReferenceCoordinate = vehicleCoordinate;
		
		//[self showContacts:annotations];
		
	} else {
		[self.navigationController popViewControllerAnimated:YES];
	}
	
}

- (void)serviceDispatchFinder:(DAServiceDispatchFinder *)dispatchFinder didFailWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];	
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Falha ao carregar assistência" 
														 message:@"Tente novamente"
														delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[errorAlert show];
}

- (void)serviceDispatchFinderDidFailWithNoInternetConnection:(DAServiceDispatchFinder *)dispatchFinder {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];	
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Não foi possível carregar a assistência" 
														 message:@"O sistema não está conectado a Internet." 
														delegate:self cancelButtonTitle:nil
											   otherButtonTitles:@"OK", nil];
	[errorAlert show];
	
}

- (void)serviceDispatchFinderDidFailWithNoResults:(DAServiceDispatchFinder *)dispatchFinder {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];	
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Não foi possível carregar a assistência"  
														 message:@"Asistência não localizada"
														delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[errorAlert show];
}

#pragma mark --

#pragma mark UIAlertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}




@end
