//
//  DAProviderAnnotation.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/16/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class DAServiceDispatch;

@interface DAProviderAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	
	DAServiceDispatch *dispatch;
}

- (id)initWithServiceDispatch:(DAServiceDispatch *)serviceDispatch;
- (id)initWithCoordinate:(CLLocationCoordinate2D)annotationCoordinate;
- (void)changeCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end
