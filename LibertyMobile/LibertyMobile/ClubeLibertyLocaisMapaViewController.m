//
//  ClubeLibertyLocaisMapaViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ClubeLibertyLocaisMapaViewController.h"
#import "Util.h"
#import "DisplayMap.h"


@implementation ClubeLibertyLocaisMapaViewController

@synthesize cellDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [Util initCustomNavigationBar:self.navigationController.navigationBar];

    [self.navigationController setNavigationBarHidden:NO];    
    self.title = [cellDict objectForKey:@"Titulo"];

//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *voltarButton = [Util addCustomButtonNavigationBar:self action:@selector(btnVoltar:) imageName:@"59_clube-ecommerce-btn-clube.png"];
//    self.navigationItem.leftBarButtonItem = voltarButton;
//    [voltarButton release];

    [Util addBackButtonNavigationBar:self action:@selector(btnVoltar:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    
    //Verificando se o primeiro registro tem loja
    NSMutableArray *arrayContatos = [cellDict objectForKey:@"Contatos"];
    NSDictionary *dictContato = [arrayContatos objectAtIndex:0];
    
    //Get Location
    if ([[dictContato objectForKey:@"Latitude"] doubleValue] != 0 && [[dictContato objectForKey:@"Longitude"] doubleValue] != 0) {
        MKCoordinateRegion region = { {0.0, 0.0}, {0.0, 0.0} };
        region.center.latitude = [[dictContato objectForKey:@"Latitude"] doubleValue];
        region.center.longitude = [[dictContato objectForKey:@"Longitude"] doubleValue];
        region.span.longitudeDelta = 0.01f;
        region.span.latitudeDelta = 0.01f;
        [localMapView setRegion:region animated:YES];
        
        DisplayMap *estabelecimento = [[DisplayMap alloc] init];
        estabelecimento.title = [cellDict objectForKey:@"Titulo"];
        estabelecimento.subtitle = [NSString stringWithFormat:@"%@ - %@/ %@", [dictContato objectForKey:@"Endereco"], [dictContato objectForKey:@"Bairro"], [dictContato objectForKey:@"CEP"]];
        estabelecimento.coordinate = region.center;
        
        [localMapView addAnnotation:estabelecimento];
        
        [estabelecimento release];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -s Location Manager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);   //setar zoom do mapa
    
    //Criar uma região no mapa com a localização recebida
    MKCoordinateRegion region = MKCoordinateRegionMake(newLocation.coordinate, span);
    
    //Setar região no mapa
    [localMapView setRegion:region animated:YES];
    
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
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

#pragma mark -s Actions

- (IBAction)btnVoltar:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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


- (IBAction)viewLocalAtual:(id)sender
{
    if ([CLLocationManager locationServicesEnabled]) {
        CLLocationManager* manager = [[CLLocationManager alloc] init];
        [manager startUpdatingLocation];
        [manager release];
    }
}


@end
