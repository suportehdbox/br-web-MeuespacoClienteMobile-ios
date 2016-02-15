//
//  DAServiceMonitoringViewController.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 7/16/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DAServiceDispatchFinder.h"
//#import "CMViewController.h"

@class DAProviderAnnotation, DAVehicleAnnotation;

@interface DAServiceMonitoringViewController : UIViewController <DAServiceDispatchFinderDelegate, MKMapViewDelegate> {
	IBOutlet MKMapView *map;

	DAServiceDispatchFinder *dispatchFinder;
	NSInteger fileNumber;
	BOOL didFirstLoad;
	
	DAProviderAnnotation *providerAnnotation;
	DAVehicleAnnotation *clientAnnotation;
	
	BOOL isLoading;
}

@property (nonatomic, assign) NSInteger fileNumber;
@property (nonatomic, strong) MKMapView *map;

- (void)loadServiceDispatch;
- (void)showMap;

@end
