//
//  OficinasReferenciadasViewController.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "OficinasReferenciadasViewController.h"
#import "Util.h"
#import "OficinasReferenciadasTableViewCell.h"
#import "DisplayMap.h"
#import "CallWebServices.h"
#import "LibertyMobileAppDelegate.h"

@implementation OficinasReferenciadasViewController

@synthesize oficinasTableView;
@synthesize geoCoder;
@synthesize locationManager;
@synthesize indicator;
@synthesize dadosLoginSegurado;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        LibertyMobileAppDelegate *appDelegate = (LibertyMobileAppDelegate *)[[UIApplication sharedApplication] delegate];
        dadosLoginSegurado = appDelegate.dadosSegurado;
        
        [Constants setPesquisa:LMPesquisa_GPS_LOCAL];
        
        NSLog(@"%@", @"GPS LOCAL    - initWithNibName");
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];    
    locationManager = nil;
    geoCoder = nil;
    
    NSLog(@"%@", @"dealloc");
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
//    [Util initCustomNavigationBar:self.navigationController.navigationBar];
    [super viewDidLoad];
    
    [indicator startAnimating];
    [self hideControls];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"Oficinas referenciadas";
    
    [GoogleAnalyticsManager send:@"Oficinas Referenciadas"];
    
    [Util dropTableBackgroudColor:self.oficinasTableView];
    
    [textLocation setText:@""];
    
//    //Adicionando o botão esquerdo na NavigationBar
//    UIBarButtonItem *closeButton = [Util addCustomButtonNavigationBar:self action:@selector(btnMenu:) imageName:@"btn-menu-lm.png"];
//    self.navigationItem.leftBarButtonItem = closeButton;
//    [closeButton release];
    
    [Util addBackButtonNavigationBar:self action:@selector(btnMenu:)];
    
    // Coloca a imagem de fundo na barra:
    UIImage *imagebg = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:imagebg forBarMetrics:UIBarStyleDefault];
    
    
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    
    findTypeMapViewReverse = 0;
    
    //TODO TESTE
//    [self callGeoCoder:locationManager.location];
    
    // TESTE >>

    [self.oficinasTableView registerNib:[UINib nibWithNibName:@"OficinasReferenciadasTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CellOficinasReferenciadas"];
    
    NSLog(@"%@", @"viewDidLoad");
}

-(void)callGeoCoder:(CLLocation *)location {
    
    //
    if (location) {
        [locationManager stopUpdatingLocation];
    }
    
    //Pega o endereço atual a partir da coordenada gps
    if (!geoCoder) {
        geoCoder = [[CLGeocoder alloc] init];
    }
    
    [geoCoder reverseGeocodeLocation:location // You can pass aLocation here instead
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                       dispatch_async(dispatch_get_main_queue(),^ {
                           // do stuff with placemarks on the main thread
                           
                           if (placemarks.count >= 1) {

                               CLPlacemark *place = [placemarks objectAtIndex:0]; // TODO incluir for com break em cep
                               NSDictionary *dict = [place addressDictionary];
                               
                               NSString *street = [dict objectForKey:(NSString *)kABPersonAddressStreetKey] != nil ? [NSString stringWithFormat:@"%@, ",[dict objectForKey:(NSString *)kABPersonAddressStreetKey]] : @"";
                               NSString *subLocality = [dict objectForKey:@"SubLocality"] != nil ? [dict objectForKey:@"SubLocality"]: @"";
                               NSString *city = [dict objectForKey:(NSString *)kABPersonAddressCityKey];
                               NSString *zip = [dict objectForKey:(NSString *)kABPersonAddressZIPKey];
                               
                               if (findTypeMapViewReverse == 0) {
                                   
                                   //textLocation.text = [NSString stringWithFormat:@"%@, %@ - %@ - CEP: %@-%@", [dict objectForKey:@"Street"], [dict objectForKey:@"SubLocality"], [dict objectForKey:@"City"], [dict objectForKey:@"ZIP"], [dict objectForKey:@"PostCodeExtension"]];
                                   
                                  textLocation.text = [NSString stringWithFormat:@"%@%@ - %@ - CEP: %@-%03ld", street, subLocality, city, zip, (long)[(NSString*)[dict objectForKey:@"PostCodeExtension"]integerValue]];
                                   
                                   [self callWebService:[NSString stringWithFormat:@"%@%03ld", [dict objectForKey:@"ZIP"], (long)[(NSString*)[dict objectForKey:@"PostCodeExtension"]integerValue]]];
                               }
                               else if (findTypeMapViewReverse == 1) {
                                   
                                   DisplayMap *posicao = [[DisplayMap alloc] init];
                                   posicao.title = @"Ponto";
                                   posicao.subtitle = [NSString stringWithFormat:@"%@%@ - %@ - CEP: %@-%03ld", street, subLocality, city, zip, (long)[(NSString*)[dict objectForKey:@"PostCodeExtension"]integerValue]];
                                   
                                   posicao.coordinate = oficinasMapView.centerCoordinate;
                                   [oficinasMapView addAnnotation:posicao];
                                   [posicao release];
                               }
                           }
                       });
                       
                   }];
    NSLog(@"%@", @"callGeoCoder");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [oficinas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OficinasReferenciadasTableViewCell *cell = (OficinasReferenciadasTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellOficinasReferenciadas"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSMutableDictionary* dict = [oficinas objectAtIndex:indexPath.row];
    
    cell.lblEstabelecimento.text = [dict objectForKey:@"Nome"];
    cell.lblEndereco.text = [NSString stringWithFormat:@"%@: %@, %@", [dict objectForKey:@"Logradouro"], [dict objectForKey:@"Endereco"], [dict objectForKey:@"Numero"]];
    cell.lblBairroCidadeUF.text = [NSString stringWithFormat:@"%@-%@/%@", [dict objectForKey:@"Bairro"], [dict objectForKey:@"Cidade"], [dict objectForKey:@"UF"]];
    cell.lblCEP.text = [dict objectForKey:@"CEP"];
    NSString* sKm = [Util fmtDoubleToString:[[dict objectForKey:@"Distancia"] doubleValue]];
    cell.lblKm.text = [NSString stringWithFormat:@"%@ Km", sKm];
    
    return cell;
}



#pragma mark -s Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary* dict = [oficinas objectAtIndex:indexPath.row];
    OficinasReferenciadasDetalheViewController *defaultViewController = [[OficinasReferenciadasDetalheViewController alloc] init];
    defaultViewController.delegate = self;
    defaultViewController.cellDict = dict;
    [self.navigationController pushViewController:defaultViewController animated:YES];
    
    // Deselect the row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

#pragma mark -s Actions

- (IBAction)btnMenu:(id)sender {
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnEnderecos:(id)sender
{
    OficinasReferenciadasBuscaViewController *defaultViewController = [[OficinasReferenciadasBuscaViewController alloc] init];
    defaultViewController.delegate = self;
    [self.navigationController pushViewController:defaultViewController animated:YES];
}


- (IBAction)setMapType:(id)sender
{
    switch (((UISegmentedControl *)sender).selectedSegmentIndex)
    {
        case 0:{
            oficinasMapView.mapType = MKMapTypeStandard;
            break;
        }
        case 1:{
            oficinasMapView.mapType = MKMapTypeSatellite;
            break;
        }
        default:{
            oficinasMapView.mapType = MKMapTypeHybrid;
            break;
        }
    }
}

- (IBAction)setViewType:(id)sender
{
    switch (((UISegmentedControl *)sender).selectedSegmentIndex)
    {
        case 0: //MapView
        {
            oficinasTableView.hidden = TRUE;
            oficinasMapView.hidden = FALSE;
            toolbarMapView.hidden = FALSE;
            break;
        }
        case 1: //TableView
        {
            oficinasTableView.hidden = FALSE;
            oficinasMapView.hidden = TRUE;
            toolbarMapView.hidden = TRUE;
            break;
        }
    }
}

- (IBAction)viewLocalAtual:(id)sender {
    [self callLocalAtual];
}

-(void)callLocalAtual
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
        
        [oficinasMapView setRegion:region animated:YES];
    }
    NSLog(@"%@", @"callLocalAtual");
}

- (IBAction)setMarkPoint:(id)sender
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:oficinasMapView.centerCoordinate.latitude longitude:oficinasMapView.centerCoordinate.longitude];
    findTypeMapViewReverse = 1;
    [self callGeoCoder:location];
}

#pragma mark -s Location Manager delegate

//Método chamado pelo delegate sempre que há uma alteração na localização
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if ([Constants pesquisa] != LMPesquisa_FEITA) {
        [Constants setPesquisa:LMPesquisa_FEITA];
        
        //Obtém a última localização
        NSLog(@"%@",locations.lastObject);        
        [self callGeoCoder:locations.lastObject];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", @"locationManager: didFailWithError");
    [indicator stopAnimating];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *pinView = nil;
    
    static NSString *defaultPinID = @"com.invasivecode.pin";
    pinView = (MKPinAnnotationView *)[oficinasMapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if (pinView == nil) {
        pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
    }
    
    pinView.canShowCallout = YES;
    pinView.draggable = YES;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pinView.rightCalloutAccessoryView = rightButton;
    
    return pinView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    DisplayMap *display = view.annotation;
    
    MKPlacemark *placeMark = [[[MKPlacemark alloc] initWithCoordinate:display.coordinate addressDictionary:nil] autorelease];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:placeMark];
    destination.name = display.title;
    
    if ([destination respondsToSelector:@selector(openInMapsWithLaunchOptions:)]) {
        [destination openInMapsWithLaunchOptions:
         @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
    } else {
        NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=Current+Location&daddr=%f,%f", display.coordinate.latitude, display.coordinate.longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    NSLog(@"%@", @"mapView");
}


#pragma mark -s Web Service

- (void)callWebService:(NSString *)cepSearch {
    
    if (![Utility hasInternet]) {
        [Utility showNoInternetWarning];
        return;
    }
    
    [indicator startAnimating];
    
    [self hideControls];
    
    CallWebServices *callWs = [[CallWebServices alloc] init];
    [callWs callGetOficinasReferenciadas:self email:(!dadosLoginSegurado.logado ? @"" : dadosLoginSegurado.cpf) cep:cepSearch raio:@"30"];
    [callWs release];
    
    NSLog(@"%@", @"callWebService");
}

- (void)callWebServicesDidFinish:(CallWebServices *)call {
    
    oficinas = [[NSMutableArray alloc] initWithArray:call.retGetOficinasReferenciadas];
    
    if (oficinas != nil) {
        
        //Add object in Dictionary
        for (NSMutableDictionary *dict in oficinas) {
            [dict setObject:[NSNumber numberWithDouble:[[dict objectForKey:@"Distancia"] doubleValue]] forKey:@"DistanciaDbl"];
        }
        
        //Ordenando o Array por Distância
        NSSortDescriptor *desc = [[NSSortDescriptor alloc] initWithKey:@"DistanciaDbl" ascending:YES selector:@selector(compare:)];
        [oficinas sortUsingDescriptors:[NSMutableArray arrayWithObject:desc]];
        
        for (int iIndex = [oficinas count] - 1; iIndex >= 0; iIndex--) {
            NSDictionary *dict = [oficinas objectAtIndex:iIndex];
            
            //Get Location
            MKCoordinateRegion region = { {0.0, 0.0}, {0.0, 0.0} };
            region.center.latitude = [[dict objectForKey:@"Latitude"] doubleValue];
            region.center.longitude = [[dict objectForKey:@"Longitude"] doubleValue];
            region.span.longitudeDelta = 0.01f;
            region.span.latitudeDelta = 0.01f;
            [oficinasMapView setRegion:region animated:YES];
            
            DisplayMap *estabelecimento = [[DisplayMap alloc] init];
            estabelecimento.title = [dict objectForKey:@"Nome"];
            estabelecimento.subtitle = [NSString stringWithFormat:@"%@: %@, %@ - %@/ %@", [dict objectForKey:@"Logradouro"], [dict objectForKey:@"Endereco"], [dict objectForKey:@"Numero"], [dict objectForKey:@"Bairro"], [dict objectForKey:@"CEP"]];
            estabelecimento.coordinate = region.center;
            
            [oficinasMapView addAnnotation:estabelecimento];
            
            [estabelecimento release];
        }
        
        oficinasTableView.hidden = TRUE;
        oficinasMapView.hidden = FALSE;
        toolbarMapView.hidden = FALSE;
        toolbarTela.hidden = FALSE;
        textLocation.hidden = FALSE;
        imgLocation.hidden = FALSE;
        
        //Adicionando o botão esquerdo na NavigationBar
        UIBarButtonItem *enderecoButton = [Util addCustomButtonNavigationBar:self action:@selector(btnEnderecos:) imageName:@"58_clube-lojamapa-btn-endereco.png"];
        self.navigationItem.rightBarButtonItem = enderecoButton;
        [enderecoButton release];
        
        //force load data
        [oficinasTableView reloadData];
        
    }
    
    [indicator stopAnimating];
    NSLog(@"%@", @"callWebServicesDidFinish");
}

- (void)callWebServicesFailWithError:(CallWebServices *)call error:(NSError *)error {
    [indicator stopAnimating];
    [Util viewMsgErrorConnection:self codeError:error];
}

#pragma Delegate OficinasReferenciadasBusca
- (void)buscaOficinasViewController:(OficinasReferenciadasBuscaViewController *)controller cepSearch:(NSString *)cepSearch
{
    if (![cepSearch isEqualToString:@""]) {
        textLocation.text = [NSString stringWithFormat:@"Próximo ao CEP: %@", cepSearch];
        [self callWebService:cepSearch];
    }
}

- (void)oficinaDetalheViewController:(OficinasReferenciadasDetalheViewController *)controller dict:(NSMutableDictionary*)dict
{
    segmentsTela.selectedSegmentIndex = 0;
    oficinasTableView.hidden = TRUE;
    oficinasMapView.hidden = FALSE;
    toolbarMapView.hidden = FALSE;
    
    //Get Location
    MKCoordinateRegion region = { {0.0, 0.0}, {0.0, 0.0} };
    region.center.latitude = [[dict objectForKey:@"Latitude"] doubleValue];
    region.center.longitude = [[dict objectForKey:@"Longitude"] doubleValue];
    region.span.longitudeDelta = 0.01f;
    region.span.latitudeDelta = 0.01f;
    [oficinasMapView setRegion:region animated:YES];
    NSLog(@"%@", @"oficinaDetalheViewController");
}

-(void)hideControls
{
    oficinasTableView.hidden = TRUE;
    oficinasMapView.hidden = TRUE;
    toolbarMapView.hidden = TRUE;
    toolbarTela.hidden = TRUE;
    textLocation.hidden = TRUE;
    imgLocation.hidden = TRUE;
}

@end
