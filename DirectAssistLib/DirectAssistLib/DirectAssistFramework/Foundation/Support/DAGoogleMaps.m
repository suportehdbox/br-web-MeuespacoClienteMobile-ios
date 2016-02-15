//
//  DAGoogleMaps.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/15/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAGoogleMaps.h"
#import "DAAddress.h"

@implementation DAGoogleMaps

+ (void)gotoAddress:(DAAddress *)address {

	NSString *addressText = [[address fullAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *urlText = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", addressText];

	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];	
}

+ (void)getDirectionsFromAddress:(DAAddress *)source toAddress:(DAAddress *)destination {

	NSString *sourceAddress = [[source fullAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *destinationAddress = [[destination fullAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

	NSString *urlText = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%@&saddr=%@", 
						 sourceAddress, destinationAddress];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];	
}

+ (void)getDirectionsFromCoordinate:(CLLocationCoordinate2D)source toAddress:(DAAddress *)destination {

	NSString *destinationAddress = [[destination fullAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *urlText = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%@&saddr=%0.6f,%0.6f", 
						 destinationAddress, source.latitude, source.longitude];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
}

@end
