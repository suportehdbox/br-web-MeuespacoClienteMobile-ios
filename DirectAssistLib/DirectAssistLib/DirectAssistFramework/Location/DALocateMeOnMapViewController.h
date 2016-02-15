//
//  DALocateMeOnMapViewController.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 6/24/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DAAddressFinderViewController.h"
#import "DAAddressViewController.h"
#import "DAUserLocationAnnotationView.h"

@class DAAddress;
@protocol DALocateMeOnMapViewControllerDelegate;

@interface DALocateMeOnMapViewController : UIViewController <MKMapViewDelegate, 
	DAAddressFinderViewControllerDelegate, DAAddressViewControllerDelegate> {
		
	IBOutlet MKMapView *locateMeMap;
	
	UIView *infoView;
	MKReverseGeocoder *reverseGeocoder;
	
	id <DALocateMeOnMapViewControllerDelegate> delegate;
	DAAddress *initAddress;
		
	DAUserLocationAnnotationView *userLocationAnnotationView;
		
	BOOL canEdit;
		
	UIImageView *targetImg;
	UIToolbar *toolbar;
}

@property (nonatomic, strong) id <DALocateMeOnMapViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL canEdit;

- (id)initWithAddress:(DAAddress *)address;
- (void)centerUserAnnotation;
- (void)showToolbar;
- (void)showEditInfo;
- (void)showEditView;
- (void)hiddeEditView;
- (void)useAddressButtonClicked;
- (IBAction)btnBack:(id)sender;

@end

@protocol DALocateMeOnMapViewControllerDelegate <NSObject>
@optional

- (void)locateMeOnMapViewController:(DALocateMeOnMapViewController *)locateMeOnMapViewController 
				   didSelectAddress:(DAAddress *)selectedAddress;

@end