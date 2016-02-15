//
//  DAUserLocationAnnotationView.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 6/24/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "DAReverseGeocoder.h"

@class DAAddress;

@interface DAUserLocationAnnotationView : MKAnnotationView <DAReverseGeocoderDelegate> {

	BOOL canMove;
	BOOL isMoving;
	BOOL canEdit;
	CGPoint startLocation;
	CGPoint originalCenter;
	CGPoint movingCenter;
	CGRect moveRect;
	
	MKMapView *__unsafe_unretained _map;
	DAReverseGeocoder *reverseGeocoder;

	UIActivityIndicatorView *updatingView;
	UIImageView *pinImageView;
	UIImageView *shadowImgView;

}

@property (nonatomic, unsafe_unretained) MKMapView *map;
@property (nonatomic) BOOL canEdit;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation canEdit:(BOOL)editable;
- (void)getAddressWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)setAddress:(DAAddress *)address;
- (void)moveToCenterCoordinate;
@end
