//
//  DAUserLocationAnnotation.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 6/24/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "DAAddress.h"

@interface DAUserLocationAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	DAAddress *userAddress;
	BOOL isUpdatingAddress;
}

@property (nonatomic) BOOL isUpdatingAddress;
@property (nonatomic, readonly) BOOL hasAddress;

- (id)initWithUserAddress:(DAAddress *)address;
- (void)changeCoordinate:(CLLocationCoordinate2D)newCoordinate;
- (void)changeUserAddress:(DAAddress *)newAddress;

@end
