//
//  DAContactMapViewController.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/15/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DAAddress.h"

@class DAContact;
@protocol DAContactMapViewControllerDelegate;

@interface DAContactMapViewController : UIViewController <MKMapViewDelegate> {
	IBOutlet MKMapView *map;
	id <DAContactMapViewControllerDelegate> __unsafe_unretained delegate;
	
	NSArray *currentAnnotations;
	CLLocationCoordinate2D searchReferenceCoordinate;
	
	BOOL showLocationPin;
}

@property (nonatomic, unsafe_unretained) id <DAContactMapViewControllerDelegate> delegate;
@property (nonatomic, strong) MKMapView *map;
@property (nonatomic, assign) CLLocationCoordinate2D searchReferenceCoordinate;
@property (nonatomic, assign) BOOL showLocationPin;

- (void)showContacts:(NSArray *)contacts;

@end

@protocol DAContactMapViewControllerDelegate <NSObject>
@optional

- (void)contactMapViewController:(DAContactMapViewController *)contactMapViewController 
		didSelectContact:(DAContact *)contact;
@end