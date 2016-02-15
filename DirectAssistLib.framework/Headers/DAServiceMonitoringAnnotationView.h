//
//  DAServiceMonitoringAnnotationView.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/16/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

enum {
	DAServiceMonitoringPinProvider = 0,
	DAServiceMonitoringPinVehicle
};
typedef NSUInteger DAServiceMonitoringPinType;

@interface DAServiceMonitoringAnnotationView : MKAnnotationView {
	UIImageView *pinImageView;
	DAServiceMonitoringPinType pinType;
	MKMapView *map;
}

@property (nonatomic) DAServiceMonitoringPinType pinType;
@property (nonatomic, strong) MKMapView *map;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation;

@end
