//
//  DAVehicleAnnotation.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/16/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DAVehicleAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)annotationCoordinate;
- (void)changeCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end
