//
//  OficinasReferenciadasViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLPlacemark.h>
#import "DadosLoginSegurado.h"
#import "OficinasReferenciadasBuscaViewController.h"
#import "OficinasReferenciadasDetalheViewController.h"
#import "Constants.h"

@interface OficinasReferenciadasViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate,OficinasReferenciadasBuscaViewControllerDelegate, OficinasReferenciadasDetalheViewControllerDelegate>
{
    UITableView* oficinasTableView;
    IBOutlet MKMapView* oficinasMapView;
    IBOutlet UISegmentedControl* segmentsTela;
    IBOutlet UISegmentedControl* segmentsMapView;
    IBOutlet UIToolbar* toolbarTela;
    IBOutlet UIToolbar* toolbarMapView;
    IBOutlet UILabel *textLocation;
    IBOutlet UIImageView *imgLocation;
    NSMutableArray * oficinas;
    
    IBOutlet CLGeocoder *geoCoder;
    IBOutlet CLLocationManager *locationManager;
    UIActivityIndicatorView *indicator;

    DadosLoginSegurado *dadosLoginSegurado;
    
    NSInteger findTypeMapViewReverse;
}

@property (nonatomic, retain) IBOutlet UITableView* oficinasTableView;
@property (nonatomic, retain) IBOutlet CLGeocoder *geoCoder;
@property (nonatomic, retain) IBOutlet CLLocationManager *locationManager;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) DadosLoginSegurado *dadosLoginSegurado;

- (IBAction)btnMenu:(id)sender;
- (IBAction)btnEnderecos:(id)sender;
- (IBAction)setMapType:(id)sender;
- (IBAction)setViewType:(id)sender;
- (IBAction)viewLocalAtual:(id)sender;
- (IBAction)setMarkPoint:(id)sender;

@end
