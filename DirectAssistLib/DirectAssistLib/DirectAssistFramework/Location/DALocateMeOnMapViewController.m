//
//  DALocateMeOnMapViewController.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 6/24/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DALocateMeOnMapViewController.h"
#import "DAUserLocation.h"
#import "DAUserLocationAnnotation.h"
#import "DAUserLocationAnnotationView.h"
#import "DAAddress.h"
#import "DAAnnotation.h"
#import "DAAddressViewController.h"
#import "DAAddressFinderViewController.h"

@implementation DALocateMeOnMapViewController

@synthesize delegate, canEdit;

- (id)initWithAddress:(DAAddress *)address {
	if (self = [self init]) {
		initAddress = address;
	}
	return self;
}

- (id)init {
	if (self = [super initWithNibName:@"DALocateMeOnMapView" bundle:[NSBundle bundleForClass:[self class]]]) {
		canEdit = YES;
		
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = DALocalizedString(@"LocateMe", nil);	
	self.view.autoresizesSubviews = NO;
    
    [Utility addBackButtonNavigationBar:self action:@selector(btnBack:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (canEdit) {
        [self showToolbar];
    }
    
    CLLocationCoordinate2D userCoordinate;
    if (nil == initAddress) {
        userCoordinate= [DAUserLocation currentLocation].coordinate;
        initAddress = [[DAAddress alloc] init];
        initAddress.coordinate = userCoordinate;
    }
    
    MKCoordinateRegion region;
    region.center = initAddress.coordinate;
    region.span.latitudeDelta = 0.005;
    region.span.longitudeDelta = 0.005;
    
    DAAnnotation *annotation = [[DAAnnotation alloc] initWithAddress:initAddress];
    
    [locateMeMap addAnnotation:annotation];
    
    [locateMeMap setRegion:region animated:NO];
    [locateMeMap regionThatFits:region];
    [locateMeMap selectAnnotation:annotation animated:NO];
    
}

/*
- (void)showToolbar {
    if (nil == toolbar) {
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,
                                                              self.view.frame.size.height - 44,
                                                              self.view.bounds.size.width,
                                                              44)];
        toolbar.tintColor = [DAConfiguration settings].applicationClient.defaultColor;
        toolbar.translucent = NO;
        [self.view addSubview:toolbar];
    }
	UIBarButtonItem *setAddressButton = [[UIBarButtonItem alloc] initWithTitle:DALocalizedString(@"SetCustomAddress", nil) 
																		 style:UIBarButtonItemStyleBordered 
																		target:self 
																		action:@selector(setAddressButtonClicked)];
	UIBarButtonItem *useAddress = [[UIBarButtonItem alloc] initWithTitle:DALocalizedString(@"UseCurrentAddress", nil) 
																   style:UIBarButtonItemStyleBordered 
																  target:self 
																  action:@selector(useAddressButtonClicked)];
		UIBarButtonItem *separator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			   target:nil 
																			   action:nil];
    NSArray *buttons = [NSArray arrayWithObjects:setAddressButton, separator, useAddress, nil];
    [toolbar setItems:buttons];
}*/
- (void)showToolbar {
    
    if (nil == toolbar) {
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        toolbar.tintColor = [DAConfiguration settings].applicationClient.defaultColor;
        
        [self.view addSubview:toolbar];
    }
    
    UIBarButtonItem *setAddressButton = [[UIBarButtonItem alloc] initWithTitle:DALocalizedString(@"SetCustomAddress", nil)
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:self
                                                                        action:@selector(setAddressButtonClicked)];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12], NSFontAttributeName, nil];
    
    [setAddressButton setTitleTextAttributes: attributes forState: UIControlStateNormal];
    
    UIBarButtonItem *useAddress = [[UIBarButtonItem alloc] initWithTitle:DALocalizedString(@"UseCurrentAddress", nil)
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(useAddressButtonClicked)];
    [useAddress setTitleTextAttributes: attributes forState: UIControlStateNormal];
    
    UIBarButtonItem *separator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];
    
    NSArray *buttons = [NSArray arrayWithObjects:setAddressButton, separator, useAddress, nil];
    [toolbar setItems:buttons];
}

- (void)centerUserAnnotation {
	
	[userLocationAnnotationView moveToCenterCoordinate];
}

- (void)showEditInfo {
	
	infoView = [[UIView alloc] initWithFrame:CGRectMake(0, -50, self.view.frame.size.width, 50)];
	infoView.backgroundColor = [UIColor darkGrayColor];
	infoView.alpha = 0.9;
	
	UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 2, infoView.frame.size.width - 8, 46)];
	infoLabel.numberOfLines = 2;
	infoLabel.backgroundColor = [UIColor clearColor];
	infoLabel.textColor = [UIColor whiteColor];
	infoLabel.shadowColor = [UIColor blackColor];
	infoLabel.shadowOffset = CGSizeMake(1, 1);
	infoLabel.lineBreakMode = UILineBreakModeWordWrap;
	infoLabel.font = [UIFont systemFontOfSize:14];
	infoLabel.alpha = 1.0;
	infoLabel.text = DALocalizedString(@"DragAndDropToGetTheAddressCorrected", nil);
	//@"Arraste e solte o alfinete se precisar corrigir sua localização";
	[infoView addSubview:infoLabel];
	
	[self.view addSubview:infoView];
	
	[UIView beginAnimations:@"InfoViewShow" context:nil];
	[UIView setAnimationDidStopSelector:@selector(hiddeEditInfo)];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDelay:1.0];
	[UIView setAnimationDuration:0.5];
	CGRect infoViewFrame = infoView.frame;
	infoViewFrame.origin.y = 0;
	infoView.frame = infoViewFrame;
	[UIView commitAnimations];
	
}

- (void)hiddeEditInfo {

	[UIView beginAnimations:@"InfoViewHide" context:nil];
	[UIView setAnimationDelay:6.0];
	[UIView setAnimationDuration:0.5];
 	CGRect infoViewFrame = infoView.frame;
 	infoViewFrame.origin.y = -50;
	infoView.frame = infoViewFrame;
	[UIView commitAnimations];		
}

- (void)showEditView {
	
	if (nil == targetImg) {
	
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        UIImage *image = [UIImage imageNamed:@"Target.png" inBundle:bundle compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
		targetImg = [[UIImageView alloc] initWithImage:image];
		//targetImg.contentStretch = UIViewContentModeCenter;
		targetImg.center = locateMeMap.center;
	}
	[self.view addSubview:targetImg];
}

- (void)hiddeEditView {

	[targetImg removeFromSuperview];
}

- (void)setAddressButtonClicked {

	userLocationAnnotationView.hidden = YES;
	
	UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc] initWithTitle:DALocalizedString(@"ConfirmAddress", nil) 
																			style:UIBarButtonItemStyleBordered 
																		   target:self 
																		   action:@selector(confirmAddressButtonClicked)];

	UIBarButtonItem *searchAddressButton = [[UIBarButtonItem alloc] initWithTitle:DALocalizedString(@"SearchAddress", nil) 
																			style:UIBarButtonItemStyleBordered 
																		   target:self 
																		   action:@selector(searchAddressButtonClicked)];
	
	UIBarButtonItem *separator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																			   target:nil 
																			   action:nil];
	
	
	NSArray *buttons = [NSArray arrayWithObjects:confirmButton, separator, searchAddressButton, nil];
	[toolbar setItems:buttons];
	
	[self showEditInfo];
	[self showEditView];
}

- (void)confirmAddressButtonClicked {
	
	[self hiddeEditView];
	[self showToolbar];
	userLocationAnnotationView.hidden = NO;
	[self centerUserAnnotation];
	//[self useAddressButtonClicked];
}

- (void)useAddressButtonClicked {
	
	DAAnnotation *annotation = (DAAnnotation *)[[locateMeMap annotations] objectAtIndex:0];
	if ([delegate respondsToSelector:@selector(locateMeOnMapViewController:didSelectAddress:)])
		[delegate locateMeOnMapViewController:self didSelectAddress:annotation.address];
}

- (void)searchAddressButtonClicked {

	userLocationAnnotationView.hidden = NO;
	[self hiddeEditView];
	
	DAAddressFinderViewController *addressFinder = [[DAAddressFinderViewController alloc] init];
	[addressFinder setDelegate:self];
	[addressFinder setAddressSearchType:kDAAddressSearchTypeStreetAndCity];
	[self.navigationController pushViewController:addressFinder animated:YES];
}

- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark MKMapViewDelegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView
			viewForAnnotation:(id <MKAnnotation>)annotation {

	userLocationAnnotationView = (DAUserLocationAnnotationView *)
		[locateMeMap dequeueReusableAnnotationViewWithIdentifier:@"UserLocationAnnotation"];
	
	if (nil == userLocationAnnotationView) {
	
		userLocationAnnotationView = [[DAUserLocationAnnotationView alloc] initWithAnnotation:annotation
																					  canEdit:self.canEdit];
		[userLocationAnnotationView setMap:locateMeMap];
		userLocationAnnotationView.canEdit = self.canEdit;
	}
	return userLocationAnnotationView;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view 
								calloutAccessoryControlTapped:(UIControl *)control {

	if (!canEdit)
		return;
	
	DAAddressViewController *addressVC = [[DAAddressViewController alloc] initWithNibName:@"DAAddressViewController" bundle:[NSBundle bundleForClass:[self class]]];
	[addressVC setDelegate:self];
	
	DAAnnotation *annotation = view.annotation;
	addressVC.address = annotation.address;
	
	[self.navigationController pushViewController:addressVC animated:YES];
}


#pragma mark DAAddressFinderViewControllerDelegate methods

- (void)addressFinderViewController:(DAAddressFinderViewController *)addressFinderViewController didSelectAddress:(DAAddress *)selectedAddress {

	[addressFinderViewController.navigationController popViewControllerAnimated:YES];
	
	DAAnnotation *annotation = (DAAnnotation *)[[locateMeMap annotations] objectAtIndex:0];
	DAUserLocationAnnotationView *userAnnotation = (DAUserLocationAnnotationView* )[locateMeMap viewForAnnotation:annotation];
	[userAnnotation setAddress:selectedAddress];

}

#pragma mark DAAddressViewControllerDelegate methods

- (void)addressViewController:(DAAddressViewController *)addressViewController 
			   didSaveAddress:(DAAddress *)savedAddress {

	[userLocationAnnotationView setAddress:savedAddress];
	[self.navigationController popViewControllerAnimated:YES];
}



@end
