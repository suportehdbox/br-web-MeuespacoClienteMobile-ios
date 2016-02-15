//
//  SinistroNovoLocalMapaViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SinistroNovoLocalMapaViewController.h"
#import "Util.h"


@implementation SinistroNovoLocalMapaViewController

@synthesize geoCoder;
@synthesize locationManager;
@synthesize indicator;
@synthesize placeSelect;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
//    [Util initCustomNavigationBar:self.navigationController.navigationBar];
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];    
    self.title = @"Local do Sinistro";
    
//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *sinistroButton = [Util addCustomButtonNavigationBar:self action:@selector(btnSinistroNovo:) imageName:@"05_sinistrosdados-btn-novo.png"];
//    self.navigationItem.leftBarButtonItem = sinistroButton;
//    [sinistroButton release];
    
    [Util addBackButtonNavigationBar:self action:@selector(btnSinistroNovo:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    
    
    [indicator startAnimating];
    
    localMapView.hidden = TRUE;
    toolbarMapView.hidden = TRUE;
    
    self.placeSelect = nil;

    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    //Get Location
    MKCoordinateRegion region = { {0.0, 0.0}, {0.0, 0.0} };
    region.center.latitude = locationManager.location.coordinate.latitude;
    region.center.longitude = locationManager.location.coordinate.longitude;
    region.span.longitudeDelta = 0.01f;
    region.span.latitudeDelta = 0.01f;
    
    [localMapView setRegion:region animated:YES];


    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:locationManager.location // You can pass aLocation here instead
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                       dispatch_async(dispatch_get_main_queue(),^ {
                           // do stuff with placemarks on the main thread
                           
                           if (placemarks.count >= 1) {
                               CLPlacemark *place;
                               place = [placemarks objectAtIndex:0];
                               
                               self.placeSelect = [place addressDictionary];

                               //Adicionando o botão direito na NavigationBar
                               UIBarButtonItem *concluidoButton = [Util addCustomButtonNavigationBar:self action:@selector(btnConcluido:) imageName:@"btn-concluido-lm.png"];
                               self.navigationItem.rightBarButtonItem = concluidoButton;
                               [concluidoButton release];
                               
                               localMapView.hidden = FALSE;
                               toolbarMapView.hidden = FALSE;
                               
                               [indicator stopAnimating];

                           }
                       });
                       
                   }];
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.geoCoder = nil;
	self.locationManager = nil;
}

- (void)dealloc {
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -s MapView Delegate

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    [indicator stopAnimating];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Erro ao obter dados de localização! Favor verificar sua conexão com a Internet!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
  
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    [indicator stopAnimating];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Erro ao obter dados de localização! Favor verificar sua conexão com a Internet!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    [indicator stopAnimating];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *pinView = nil;
    
    static NSString *defaultPinID = @"com.invasivecode.pin";
    pinView = (MKPinAnnotationView *)[localMapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if (pinView == nil) {
        pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
    }
    
    pinView.canShowCallout = YES;
    pinView.draggable = YES;
    
    return pinView;
}

/*
-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    self.placeSelect = placemark;

    //Adicionando o botão direito na NavigationBar
    UIBarButtonItem *concluidoButton = [Util addCustomButtonNavigationBar:self action:@selector(btnConcluido:) imageName:@"btn-concluido-lm.png"];
    self.navigationItem.rightBarButtonItem = concluidoButton;
    [concluidoButton release];

    localMapView.hidden = FALSE;
    toolbarMapView.hidden = FALSE;

    [indicator stopAnimating];
}

-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    [indicator stopAnimating];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Erro ao obter dados de localização! Favor verificar sua conexão com a Internet!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];

}
 */

#pragma mark -s Actions

- (IBAction)btnSinistroNovo:(id)sender {
    [locationManager stopUpdatingLocation];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnConcluido:(id)sender {
    [locationManager stopUpdatingLocation];

    if (placeSelect != nil) {

        [self.delegate mapaViewLocalViewController:self address:[self.placeSelect objectForKey:@"SubLocality"] city:[self.placeSelect  objectForKey:@"City"] zipoCode:[self.placeSelect objectForKey:@"ZIP"]];

        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)viewLocalAtual:(id)sender
{
    if ([CLLocationManager locationServicesEnabled]) {
        
        //Get actual position
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
        
        //Get Location
        MKCoordinateRegion region = { {0.0, 0.0}, {0.0, 0.0} };
        region.center.latitude = locationManager.location.coordinate.latitude;
        region.center.longitude = locationManager.location.coordinate.longitude;
        region.span.longitudeDelta = 0.01f;
        region.span.latitudeDelta = 0.01f;
        
        [localMapView setRegion:region animated:YES];
    }
}

- (IBAction)setMapType:(id)sender
{
    switch (((UISegmentedControl *)sender).selectedSegmentIndex)
    {
        case 0:
        {
            localMapView.mapType = MKMapTypeStandard;
            break;
        }
        case 1:
        {
            localMapView.mapType = MKMapTypeSatellite;
            break;
        }
        default:
        {
            localMapView.mapType = MKMapTypeHybrid;
            break;
        }
    }
}

@end
