//
//  DALocateMeViewController.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 12/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DALocateMeViewController.h"
#import "DAAddress.h"
#import "DAStatusViewController.h"
#import "DAUserLocation.h"

@implementation DALocateMeViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = DALocalizedString(@"LocateMe", nil);
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
		
	[self.view addSubview:[self createLocateMeToolbar:self.view.bounds]];

	statusView = [[DAStatusViewController alloc] initWithStatus:DALocalizedString(@"GettingAddress", nil)];;
	[statusView showInViewController:self];

	reverseGeocoder = [[DAReverseGeocoder alloc] initWithLocation:[DAUserLocation currentLocation]];
	[reverseGeocoder setDelegate:self];	
	[reverseGeocoder start];	
}

#pragma mark DAReverseGeocoderDelegate methods

- (void)reverseGeocoder:(DAReverseGeocoder *)geocoder didFindAddress:(DAAddress *)address {
	txtStreetName.text = address.streetName;
	txtHouseNumber.text = address.houseNumber;
	txtDistrict.text = address.district;
	txtCity.text = address.city;
	txtState.text = address.state;
	
	txtCity.enabled = NO;
	txtState.enabled = NO;
	
	txtDistrict.returnKeyType = UIReturnKeyDone;
	
	[statusView.view removeFromSuperview];
	[self loadPreviewMap];
	
	if ([delegate respondsToSelector:@selector(locateMeViewController:didFindAddress:)])
		[delegate locateMeViewController:self didFindAddress:address];

}

- (void)reverseGeocoder:(DAReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	[statusView dismiss];	
	UIAlertView *locationErrorAlert = [[UIAlertView alloc] 
									   initWithTitle:@"Não foi possível obter sua localização" 
									   message:@"Tente novamente." 
									   delegate:self cancelButtonTitle:nil
									   otherButtonTitles:@"OK", nil];
	[locationErrorAlert show];
}

- (void)reverseGeocoderDidFailNoInternetConnection:(DAReverseGeocoder *)geocoder {
	[statusView dismiss];	
	UIAlertView *locationErrorAlert = [[UIAlertView alloc] 
									   initWithTitle:@"Não foi possível obter sua Localização" 
									   message:@"O sistema não está conectado a Internet." 
									   delegate:self cancelButtonTitle:nil
									   otherButtonTitles:@"OK", nil];
	[locationErrorAlert show];
}

#pragma mark --

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
		[self.navigationController popViewControllerAnimated:YES];
}


- (void)loadPreviewMap {

/*	NSString *googleUrl = [NSString stringWithFormat:
						   @"http://www.webmondial.com.br/mobile/maps/default3.aspx?latCli=%.6f&lonCli=%.6f",
						   [AppConfig sharedConfiguration].userLocation.coordinate.latitude,
						   [AppConfig sharedConfiguration].userLocation.coordinate.longitude];
*/	
		NSString *googleUrl = [NSString stringWithFormat:
						   @"http://maps.google.com/staticmap?zoom=16&size=320x160&maptype=mobile&markers=%.6f,%.6f,bluec&key=MAPS_API_KEY",
						   [DAUserLocation currentLocation].coordinate.latitude,
						   [DAUserLocation currentLocation].coordinate.longitude];
	
	
	//NSLog(@"%@", googleUrl);
	
	NSURL *mapUrl = [NSURL URLWithString:googleUrl];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:mapUrl];
	
	[mapPreview loadRequest:urlRequest];
}

- (void) btnDone_Clicked:(id)sender {

	if ([txtStreetName.text length] == 0 ||
		[txtCity.text length] == 0 ||
		[txtState.text length] == 0) {

		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Operação cancelada."
															 message:@"Por favor, informe a localização do seu veículo." delegate:nil cancelButtonTitle:nil 
														otherButtonTitles:@"OK", nil];
		[errorAlert show];
	}
	else {
		CLLocation *userLocation = [DAUserLocation currentLocation];
	
		DAAddress *address = [DAAddress alloc];
		address.streetName = txtStreetName.text;
		address.houseNumber = txtHouseNumber.text;
		address.district = txtDistrict.text;
		address.city = txtCity.text;
		address.state = txtState.text;
		address.coordinate = userLocation.coordinate;
	
		if ([delegate respondsToSelector:@selector(locateMeViewController:didAcceptAddress:)])
			[delegate locateMeViewController:self didAcceptAddress:address];
	
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void) btnEdit_Clicked:(id)sender {
	[txtStreetName becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField { 
	
	[theTextField resignFirstResponder];
	
	if (theTextField == txtStreetName) 
		[txtHouseNumber becomeFirstResponder];

	else if (theTextField == txtHouseNumber)
		[txtDistrict becomeFirstResponder];

	else if (theTextField == txtDistrict)
		if (txtCity.enabled)
			[txtCity becomeFirstResponder];
	
	else if (theTextField == txtCity)
		[txtState becomeFirstResponder];
		
	return YES; 
} 

- (UIToolbar *)createLocateMeToolbar:(CGRect)parentBounds {
	
	//Caclulate the height of the toolbar
	CGFloat toolbarHeight = 44;
	
	//Get the height of the parent view.
	CGFloat rootViewHeight = CGRectGetHeight(parentBounds);
	
	//Get the width of the parent view,
	CGFloat rootViewWidth = CGRectGetWidth(parentBounds);
	
	//Create a rectangle for the toolbar
	CGRect rectArea = CGRectMake(0, rootViewHeight - toolbarHeight + 4, rootViewWidth, toolbarHeight);
	
	toolBar = [[UIToolbar alloc] initWithFrame:rectArea];
	
	UIBarButtonItem *btnEdit = [[UIBarButtonItem alloc] initWithTitle:@"Editar localização" 
																style:UIBarButtonItemStyleBordered target:self action:@selector(btnEdit_Clicked:)];
	UIBarButtonItem *btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Usar esta localização" 
																style:UIBarButtonItemStyleBordered target:self action:@selector(btnDone_Clicked:)];
	
	toolBar.tintColor = [AppConfig sharedConfiguration].appClient.defaultColor;
	[toolBar setItems:[NSArray arrayWithObjects:btnEdit, btnSpace, btnDone, nil]];
	
	return toolBar;
}

#pragma mark WebView delegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[loadingMap startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[loadingMap stopAnimating];
}

#pragma mark --

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}



@end
