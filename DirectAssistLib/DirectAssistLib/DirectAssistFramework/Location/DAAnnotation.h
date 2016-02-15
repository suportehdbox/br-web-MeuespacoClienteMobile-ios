//
//  DAAnnotation.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/8/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class DAAddress;

@interface DAAnnotation : NSObject <MKAnnotation> {
	DAAddress *address;
	CLLocationCoordinate2D coordinate;
	
	BOOL updatingAddress;
}

@property (nonatomic, strong) DAAddress *address;
@property (nonatomic, getter=isUpdatingAddress) BOOL updatingAddress;

- (id)initWithAddress:(DAAddress *)annotationAddress;
- (void)changeCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
