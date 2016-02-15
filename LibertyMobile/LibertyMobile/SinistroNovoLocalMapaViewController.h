//
//  SinistroNovoLocalMapaViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Address.h"

@protocol SinistroNovoLocalMapaViewControllerDelegate;

@interface SinistroNovoLocalMapaViewController : UIViewController <MKMapViewDelegate> {
    IBOutlet MKMapView* localMapView;
    IBOutlet CLGeocoder *geoCoder;
    IBOutlet CLLocationManager *locationManager;
    NSDictionary *placeSelect;
    UIActivityIndicatorView *indicator;
    IBOutlet UIToolbar* toolbarMapView;
    IBOutlet UISegmentedControl* segmentsMapView;

	id<SinistroNovoLocalMapaViewControllerDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet CLGeocoder *geoCoder;
@property (nonatomic, retain) IBOutlet CLLocationManager *locationManager;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) NSDictionary *placeSelect;

@property (nonatomic, assign) id<SinistroNovoLocalMapaViewControllerDelegate> delegate;

- (IBAction)btnSinistroNovo:(id)sender;
- (IBAction)btnConcluido:(id)sender;
- (IBAction)setMapType:(id)sender;
- (IBAction)viewLocalAtual:(id)sender;

@end

@protocol SinistroNovoLocalMapaViewControllerDelegate <NSObject>

@optional

- (void)mapaViewLocalViewController:(SinistroNovoLocalMapaViewController *)controller address:(NSString *)address city:(NSString *)city zipoCode:(NSString *)zipCode ;

@end
