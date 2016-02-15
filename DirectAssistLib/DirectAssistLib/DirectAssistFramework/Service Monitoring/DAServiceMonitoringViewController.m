//
//  DAServiceMonitoringViewController.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 7/16/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAServiceMonitoringViewController.h"
#import "DAProviderAnnotation.h"
#import "DAVehicleAnnotation.h"
#import "DAServiceMonitoringAnnotationView.h"
#import "GoogleAnalyticsManager.h"

@implementation DAServiceMonitoringViewController

@synthesize fileNumber, map;

- (id)init {

    if (self = [super initWithNibName:@"DAServiceMonitoringViewController" bundle:[NSBundle bundleForClass:[self class]]]) {
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = DALocalizedString(@"Map", nil);
    
    [GoogleAnalyticsManager send:@"Assistência Automotiva: Mapa"];
    NSLog(@"Assistência Automotiva: Mapa");
    
    [Utility addBackButtonNavigationBar:self action:@selector(btnBack:)];
    
    UIBarButtonItem *saveButton = [Utility addCustomButtonNavigationBar:self action:@selector(loadServiceDispatch) imageName:@"header-botao-2" title:NSLocalizedString(@"Refresh", )];
    self.navigationItem.rightBarButtonItem = saveButton;

	didFirstLoad = NO;
	map.showsUserLocation = NO;
	[self loadServiceDispatch];
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

- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark DAServiceMonitoringViewController methods

- (void)loadServiceDispatch {
	
	if (isLoading)
		return;
	
	isLoading = YES;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];	

	dispatchFinder = [[DAServiceDispatchFinder alloc] init];
	dispatchFinder.delegate = self;
	[dispatchFinder getServiceDispatchWithFileNumber:fileNumber];
}

- (void)showMap {
}

#pragma mark DAServiceDispatchFinderDelegate methods

- (void)serviceDispatchFinder:(DAServiceDispatchFinder *)dispatchFinder didFindServiceDispatch:(DAServiceDispatch *)dispatch {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];	
	isLoading = NO;
	
	if (!didFirstLoad) {
		
		CLLocationDegrees maxLat = -90;
		CLLocationDegrees maxLon = -180;
		CLLocationDegrees minLat = 90;
		CLLocationDegrees minLon = 180;
	
		providerAnnotation = [[DAProviderAnnotation alloc] initWithServiceDispatch:dispatch];
		[self.map addAnnotation:providerAnnotation];

		clientAnnotation = [[DAVehicleAnnotation alloc] initWithCoordinate:dispatch.clientCoordinate];
		[self.map addAnnotation:clientAnnotation];
	
		//	CLLocation *provideLocation = [[CLLocation alloc] initWithLatitude:dispatch.providerCoordinate.latitude,
		//																longitude:dispatch.providerCoordinate.longitude];	
		//	double distance = [sourceLocation getDistanceFrom:destinationLocation];
		//		[sourceLocation release];
		//		[destinationLocation release];
			
		if(dispatch.providerCoordinate.latitude > maxLat)
			maxLat = dispatch.providerCoordinate.latitude;
		if(dispatch.providerCoordinate.latitude < minLat)
			minLat = dispatch.providerCoordinate.latitude;
		if(dispatch.providerCoordinate.longitude > maxLon)
			maxLon = dispatch.providerCoordinate.longitude;
		if(dispatch.providerCoordinate.longitude < minLon)
			minLon = dispatch.providerCoordinate.longitude;

		if(dispatch.clientCoordinate.latitude > maxLat)
			maxLat = dispatch.clientCoordinate.latitude;
		if(dispatch.clientCoordinate.latitude < minLat)
			minLat = dispatch.clientCoordinate.latitude;
		if(dispatch.clientCoordinate.longitude > maxLon)
			maxLon = dispatch.clientCoordinate.longitude;
		if(dispatch.clientCoordinate.longitude < minLon)
			minLon = dispatch.clientCoordinate.longitude;
	
		MKCoordinateRegion region;
		region.center.latitude = (maxLat + minLat) / 2;
		region.center.longitude = (maxLon + minLon) / 2;
		region.span.latitudeDelta = (maxLat - minLat) * 1.1;
		region.span.longitudeDelta = maxLon - minLon;
	
		[self.map setRegion:region animated:YES];
		[self.map regionThatFits:region];
		[self.map selectAnnotation:providerAnnotation animated:NO];
		didFirstLoad = YES;
	} else {
		DAServiceMonitoringAnnotationView *providerAnnotationView = 
			(DAServiceMonitoringAnnotationView *)[self.map viewForAnnotation:providerAnnotation];
		
		if (nil != providerAnnotationView) {

			CGPoint originalCenter = [self.map convertCoordinate:providerAnnotation.coordinate 
											   toPointToView:self.map];
			
			CGPoint newCenter = [self.map convertCoordinate:dispatch.providerCoordinate 
												   toPointToView:self.map];

			CGFloat diffX = newCenter.x - originalCenter.x;
			CGFloat diffY = newCenter.y - originalCenter.y;
			
			[providerAnnotation changeCoordinate:dispatch.providerCoordinate];

			[UIView beginAnimations:@"MovePin" context:nil];
			[UIView setAnimationDuration:0.5];
			providerAnnotationView.center = CGPointMake(providerAnnotationView.center.x + diffX, 
														providerAnnotationView.center.y + diffY);
			[UIView commitAnimations];
		
			[self.map deselectAnnotation:providerAnnotation animated:NO];
			[self.map selectAnnotation:providerAnnotation animated:NO];
		}
	
	}
}

- (void)serviceDispatchFinderDidFailWithNoResults:(DAServiceDispatchFinder *)dispatchFinder {
	isLoading = NO;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];	
}

- (void)serviceDispatchFinder:(DAServiceDispatchFinder *)dispatchFinder didFailWithError:(NSError *)error {
	isLoading = NO;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];	
}

- (void)serviceDispatchFinderDidFailWithNoInternetConnection:(DAServiceDispatchFinder *)dispatchFinder {
	isLoading = NO;

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];	
}


#pragma mark MKMapViewDelegate methods 

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	DAServiceMonitoringAnnotationView *annotationView = (DAServiceMonitoringAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"DAServiceMonitoringAnnotationView"];
	if (nil == annotationView)
		annotationView = [[DAServiceMonitoringAnnotationView alloc] initWithAnnotation:annotation];

	return annotationView;			 
}

@end
