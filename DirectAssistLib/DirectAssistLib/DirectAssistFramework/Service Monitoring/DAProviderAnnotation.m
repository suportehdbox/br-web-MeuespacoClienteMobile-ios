//
//  DAProviderAnnotation.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/16/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAProviderAnnotation.h"
#import "DAServiceDispatch.h"

@implementation DAProviderAnnotation

@synthesize coordinate;

- (id)initWithServiceDispatch:(DAServiceDispatch *)serviceDispatch {
	
	if (self = [self initWithCoordinate:serviceDispatch.providerCoordinate]) {
		
		dispatch = serviceDispatch;
	}
	return self;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)annotationCoordinate {
	
	if (self = [super init]) 
		coordinate = annotationCoordinate;

	return self;
}

- (void)changeCoordinate:(CLLocationCoordinate2D)newCoordinate {
	coordinate = newCoordinate;
}

- (NSString *)title{
	
	if (nil != dispatch) {
		return [NSString stringWithFormat:@"%@ (%@)", DALocalizedString(@"Provider", nil), dispatch.vehiclePlate]; 
	}
	else 
		return DALocalizedString(@"ServiceProvider", nil);
}

- (NSString *)subtitle{
	
	//if (nil != dispatch) {
	//	return [NSString stringWithFormat:@"%@", dispatch.vehiclePlate];
	//}
	//else
		return nil; 
}

@end
