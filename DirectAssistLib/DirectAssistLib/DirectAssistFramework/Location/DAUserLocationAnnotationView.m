//
//  DAUserLocationAnnotationView.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 6/24/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAUserLocationAnnotationView.h"
#import "DAUserLocationAnnotation.h"
#import "DAAnnotation.h"

#define MOVING_ANNOTATION_WIDTH 310
#define MOVING_ANNOTATION_HEIGHT 450
#define TOUCH_RECT_WIDTH 50
#define TOUCH_RECT_HEIGHT 70

#define IMG_PIN @"Pin.png"
#define IMG_PIN_DOWN1 @"PinDown1.png"
#define IMG_PIN_DOWN2 @"PinDown2.png"
#define IMG_PIN_DOWN3 @"PinDown3.png"
#define IMG_PIN_FLOATING @"PinFloating.png"
#define IMG_PIN_SHADOW @"PinShadow.png"

@implementation DAUserLocationAnnotationView

@synthesize map = _map, canEdit;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation canEdit:(BOOL)editable
{
    self = [super initWithAnnotation:annotation
					 reuseIdentifier:@"UserLocationAnnotation"];
    if (self) {
		
		self.canEdit = editable;
		self.canShowCallout = YES;
		self.multipleTouchEnabled = NO;
		self.backgroundColor = [UIColor clearColor];

		self.bounds = CGRectMake(0, 0, MOVING_ANNOTATION_WIDTH, MOVING_ANNOTATION_HEIGHT);
		moveRect = CGRectMake((MOVING_ANNOTATION_WIDTH / 2) - (TOUCH_RECT_WIDTH / 2), 
							   (MOVING_ANNOTATION_HEIGHT / 2) - (TOUCH_RECT_HEIGHT / 2) - 10, 
							   TOUCH_RECT_WIDTH, 
							   TOUCH_RECT_HEIGHT);
		
		self.calloutOffset = CGPointMake(0, 188);
		
		//MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Teste"];
		//pinImageView = [[UIImageView alloc] initWithImage:pin.image];
        
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        UIImage *image = [UIImage imageNamed:IMG_PIN inBundle:bundle compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
        
		pinImageView = [[UIImageView alloc] initWithImage:image];
		pinImageView.frame = CGRectMake(((MOVING_ANNOTATION_WIDTH - pinImageView.image.size.width) / 2) + 8, 
										((MOVING_ANNOTATION_HEIGHT - pinImageView.image.size.height) / 2) - 16, 
										32, 39);
		[self addSubview:pinImageView];
		
        UIImage *imageShadow = [UIImage imageNamed:IMG_PIN_SHADOW inBundle:bundle compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
		shadowImgView = [[UIImageView alloc] initWithImage:imageShadow];
		shadowImgView.frame = CGRectMake(pinImageView.frame.origin.x + 5, 
										pinImageView.frame.origin.y - 0, 
										26, 25);
		[self addSubview:shadowImgView];
		[shadowImgView setHidden:YES];
		
		updatingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		[updatingView setHidesWhenStopped:YES];

		if (canEdit) {
			UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
			self.rightCalloutAccessoryView = rightButton;
		}
		
		DAAnnotation *userAnnotation = (DAAnnotation *)annotation;
		if (nil == userAnnotation.address.streetName)
			[self getAddressWithCoordinate:annotation.coordinate];
		else 
			[self setAddress:userAnnotation.address];
	}
    return self;
}

- (void)drawRect:(CGRect)rect {
	/*
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetRGBFillColor(context, 0, 0, 255, 0.1);
	CGContextSetRGBStrokeColor(context, 0, 0, 255, 0.5);
	
	CGContextMoveToPoint(context, 0, self.bounds.size.height / 2);
	CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height / 2);
	CGContextStrokePath(context);
	
	CGContextMoveToPoint(context, self.bounds.size.width / 2, 0);
	CGContextAddLineToPoint(context, self.bounds.size.width / 2, self.bounds.size.height);
	CGContextStrokePath(context);
	
	CGContextFillRect(context, self.bounds);
	CGContextStrokeRect(context, self.bounds);

	CGContextStrokeRect(context, moveRect);
*/
}

#pragma mark Touch events
/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
		
	if (!canEdit)
		return;
	
	originalCenter = self.center;
	
	UITouch *touch = [touches anyObject];
	CGPoint touchPoint = [touch locationInView:self];

	CGRect touchRect = CGRectMake(touchPoint.x - 2, touchPoint.y - 2, 5, 5);
	canMove = CGRectIntersectsRect(touchRect, moveRect);
	
	if (canMove) {
		startLocation = [touch locationInView:[self superview]];
	
		[UIView setAnimationDuration:0.5];
		[UIView beginAnimations:@"AnnotationView" context:nil];
	
		movingCenter = CGPointMake(originalCenter.x, originalCenter.y - 50);
		self.center = movingCenter;

		[shadowImgView setHidden:NO];
		shadowImgView.frame = CGRectMake(pinImageView.frame.origin.x + 50, 
										 pinImageView.frame.origin.y - 20, 
										 26, 25);		
		[UIView commitAnimations];
		pinImageView.image = [UIImage imageNamed:IMG_PIN_FLOATING];

		
		[_map deselectAnnotation:self.annotation animated:YES];
		[self setCanShowCallout:NO];
	}
	//[super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

	if (!canEdit)
		return;
	
	if (canMove) {
		UITouch *touch = [touches anyObject];
		CGPoint newLocation = [touch locationInView:[self superview]];
	
		CGPoint newPoint;
		newPoint.x = movingCenter.x + (newLocation.x - startLocation.x);
		newPoint.y = movingCenter.y + (newLocation.y - startLocation.y);
	
		self.center = newPoint;
		isMoving = YES;	
	}
	[super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

	if (!canEdit)
		return;
	
	[self setCanShowCallout:YES];

	if (isMoving) {
		
		DAAnnotation *placemark = self.annotation;
		[placemark setUpdatingAddress:YES];

		CGPoint annotationCenter = CGPointMake(self.center.x, self.center.y);
		CLLocationCoordinate2D centerCoordinate = [_map convertPoint:annotationCenter toCoordinateFromView:[self superview]];


		[placemark changeCoordinate:centerCoordinate];
		[_map setCenterCoordinate:centerCoordinate];
		[self getAddressWithCoordinate:placemark.coordinate];
		
		isMoving = NO;
	}
	else {
		
		[UIView setAnimationDuration:0.7];
		[UIView beginAnimations:@"AnnotationView" context:nil];
		
		self.center = originalCenter;
		
		[UIView commitAnimations];

		DAAnnotation *placemark = self.annotation;
		[placemark setUpdatingAddress:NO];
	}
	
	pinImageView.image = [UIImage imageNamed:IMG_PIN];
	[shadowImgView setHidden:YES];
	shadowImgView.frame = CGRectMake(pinImageView.frame.origin.x + 5, 
									 pinImageView.frame.origin.y - 0, 
									 26, 25);		
	
	[_map deselectAnnotation:self.annotation animated:NO];
	[_map selectAnnotation:self.annotation animated:NO];		

	[super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {

	if (!canEdit)
		return;
	
	if (canMove) {
		[UIView setAnimationDuration:0.7];
		[UIView beginAnimations:@"AnnotationView" context:nil];
	
		self.center = originalCenter;
	
		[UIView commitAnimations];
	}
	[super touchesCancelled:touches withEvent:event];
 
	pinImageView.image = [UIImage imageNamed:IMG_PIN];
	[shadowImgView setHidden:YES];
	shadowImgView.frame = CGRectMake(pinImageView.frame.origin.x + 5, 
									 pinImageView.frame.origin.y - 0, 
									 26, 25);		

	[_map selectAnnotation:self.annotation animated:YES];
	[self setCanShowCallout:YES];
}
*/

#pragma mark MKReverseGeocoderDelegate methods

- (void)reverseGeocoder:(DAReverseGeocoder *)geocoder didFindAddress:(DAAddress *)address {

	if (nil == address) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
														message:DALocalizedString(@"CountryNotCovered", nil) 
													   delegate:nil 
											  cancelButtonTitle:nil 
											  otherButtonTitles:DALocalizedString(@"OK", nil), nil];
		[alert show];
		DAAnnotation *placemark = self.annotation;
		[placemark setUpdatingAddress:NO];
		[updatingView stopAnimating];
		self.leftCalloutAccessoryView = nil;
		self.rightCalloutAccessoryView.hidden = YES;
	}
	else {
		[self setAddress:address];	
	}
	geocoder = nil;
}

- (void)reverseGeocoder:(DAReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
													message:DALocalizedString(@"ReverseGeocodeFailWarning", nil) 
												   delegate:nil 
										  cancelButtonTitle:nil 
										  otherButtonTitles:DALocalizedString(@"OK", nil), nil];
	[alert show];
	DAAnnotation *placemark = self.annotation;
	[placemark setUpdatingAddress:NO];
	[updatingView stopAnimating];
	self.leftCalloutAccessoryView = nil;
	self.rightCalloutAccessoryView.hidden = YES;

	geocoder = nil;
}

- (void)reverseGeocoderDidFailNoInternetConnection:(DAReverseGeocoder *)geocoder {

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
													message:DALocalizedString(@"NoInternetWarning", nil) 
												   delegate:nil 
										  cancelButtonTitle:nil 
										  otherButtonTitles:DALocalizedString(@"OK", nil), nil];
	[alert show];
	DAAnnotation *placemark = self.annotation;
	[placemark setUpdatingAddress:NO];
	[updatingView stopAnimating];
	self.leftCalloutAccessoryView = nil;
	self.rightCalloutAccessoryView.hidden = YES;
	
	geocoder = nil;
}

- (void)getAddressWithCoordinate:(CLLocationCoordinate2D)coordinate {
	
	updatingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[updatingView setHidesWhenStopped:YES];
	[updatingView startAnimating];
	self.leftCalloutAccessoryView = updatingView;
		
	CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
	
	reverseGeocoder.delegate = nil;
	reverseGeocoder = [[DAReverseGeocoder alloc] initWithLocation:location];
	[reverseGeocoder setDelegate:self];
	[reverseGeocoder start];

}

- (void)setAddress:(DAAddress *)address {
	[self setCanShowCallout:YES];
	self.rightCalloutAccessoryView.hidden = NO;
	
	DAAnnotation *placemark = self.annotation;
	[placemark setAddress:address];
	[placemark setUpdatingAddress:NO];

	[updatingView stopAnimating];
	self.leftCalloutAccessoryView = nil;
	
	[_map setCenterCoordinate:self.annotation.coordinate animated:YES];

	[_map deselectAnnotation:self.annotation animated:NO];
	[_map selectAnnotation:self.annotation animated:NO];		
}

- (void)moveToCenterCoordinate {
	
	CLLocationCoordinate2D centerCoordinate = _map.centerCoordinate;
	
	DAAnnotation *placemark = self.annotation;
	[placemark setUpdatingAddress:YES];
	
	[placemark changeCoordinate:centerCoordinate];
	[_map setCenterCoordinate:centerCoordinate];
	[self getAddressWithCoordinate:placemark.coordinate];
}

@end
