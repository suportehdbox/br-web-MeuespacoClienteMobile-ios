//
//  DAVehicleAnnotation.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/16/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAVehicleAnnotation.h"


@implementation DAVehicleAnnotation

@synthesize coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)annotationCoordinate {
	
	if (self = [super init]) 
		coordinate = annotationCoordinate;
	
	return self;
}

- (void)changeCoordinate:(CLLocationCoordinate2D)newCoordinate {
	coordinate = newCoordinate;
}

- (NSString *)title{
	
	return DALocalizedString(@"Client", nil);
}

- (NSString *)subtitle{
	
	return nil; //@"Sei la";
}

@end
