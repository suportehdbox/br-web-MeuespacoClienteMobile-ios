//
//  DAContactMapViewController.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/15/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAContactMapViewController.h"
#import "DAUserLocation.h"
#import "DAContact.h"
#import "DAContactAnnotation.h"
#import "DAContactAnnotationView.h"
#import "DAContactItemViewController.h"
#import "DAAddress.h"

@implementation DAContactMapViewController

@synthesize map, delegate, searchReferenceCoordinate, showLocationPin;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	showLocationPin = NO;
	
	MKCoordinateRegion region;
	region.center = [[DAUserLocation currentLocation] coordinate];
	region.span.latitudeDelta = 0.005;
	region.span.longitudeDelta = 0.005;
	
	[self.map setRegion:region animated:NO];
	[self.map regionThatFits:region];
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


#pragma mark ContactMapViewController methods

- (void)showContacts:(NSArray *)contacts {
	
	if ([currentAnnotations count] > 0)
		[self.map removeAnnotations:currentAnnotations];
	
	NSMutableArray *annotations = [[NSMutableArray alloc] initWithCapacity:[contacts count]];
	int count = 0;

	CLLocationDegrees maxLat = -90;
	CLLocationDegrees maxLon = -180;
	CLLocationDegrees minLat = 90;
	CLLocationDegrees minLon = 180;
	
	for (DAContact *contact in contacts) {
		
		DAContactAnnotation *contactAnnotation = [[DAContactAnnotation alloc] initWithContact:contact];		

		CLLocation *sourceLocation = [[CLLocation alloc] initWithLatitude:searchReferenceCoordinate.latitude 
																longitude:searchReferenceCoordinate.longitude];
		CLLocation *destinationLocation = [[CLLocation alloc] initWithLatitude:contact.address.coordinate.latitude 
																	 longitude:contact.address.coordinate.longitude];
		double distance = [sourceLocation distanceFromLocation:destinationLocation];
		
		
		contactAnnotation.distanceFromCenter = distance;
		
		[annotations addObject:contactAnnotation];

		count ++;
		
		if (count <= 5) {
			if(contact.address.coordinate.latitude > maxLat)
				maxLat = contact.address.coordinate.latitude;
			if(contact.address.coordinate.latitude < minLat)
				minLat = contact.address.coordinate.latitude;
			if(contact.address.coordinate.longitude > maxLon)
				maxLon = contact.address.coordinate.longitude;
			if(contact.address.coordinate.longitude < minLon)
				minLon = contact.address.coordinate.longitude;
		}
	}
	
	if (showLocationPin) {
	
		MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:searchReferenceCoordinate addressDictionary:nil];
		[self.map addAnnotation:placemark];
	}
	
	CLLocationCoordinate2D userLocation = searchReferenceCoordinate;

	if(userLocation.latitude > maxLat)
		maxLat = userLocation.latitude;
	if(userLocation.latitude < minLat)
		minLat = userLocation.latitude;
	if(userLocation.longitude > maxLon)
		maxLon = userLocation.longitude;
	if(userLocation.longitude < minLon)
		minLon = userLocation.longitude;
		
	MKCoordinateRegion region;
	region.center.latitude = (maxLat + minLat) / 2;
	region.center.longitude = (maxLon + minLon) / 2;
	region.span.latitudeDelta = maxLat - minLat;
	region.span.longitudeDelta = maxLon - minLon;
	
	if (region.span.latitudeDelta != 0) {
		[self.map setRegion:region animated:YES];
		[self.map regionThatFits:region];
	}
	
	[self.map addAnnotations:annotations];
	currentAnnotations = annotations;
}

#pragma mark MKMapViewDelegate methods


- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
	
	CGRect visibleRect = [mapView annotationVisibleRect];
	
	for (MKAnnotationView *view in views) {
		
		CGRect endFrame = view.frame;
		
		CGRect startFrame = endFrame;
		startFrame.origin.y = visibleRect.origin.y - startFrame.size.height;
		view.frame = startFrame;
		
		[UIView beginAnimations:@"drop" context:NULL];
		view.frame = endFrame;
		[UIView commitAnimations];
	}
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {

	if ([annotation isKindOfClass:[MKUserLocation class]])
		 return nil;

	if ([annotation isKindOfClass:[MKPlacemark class]])
		return nil;

	DAContactAnnotationView *annotationView = (DAContactAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"DAContactAnnotationView"];
	if (nil == annotationView) 
		annotationView = [[DAContactAnnotationView alloc] initWithAnnotation:annotation];
	
	return annotationView;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

	DAContactAnnotation *contactAnnotation = (DAContactAnnotation *)view.annotation;

	if ([delegate respondsToSelector:@selector(contactMapViewController:didSelectContact:)])
		[delegate contactMapViewController:self didSelectContact:contactAnnotation.contact];
}



@end
