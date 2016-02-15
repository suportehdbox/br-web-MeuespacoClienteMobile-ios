//
//  DAServiceMonitoringAnnotationView.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/16/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAServiceMonitoringAnnotationView.h"
#import "DAProviderAnnotation.h"
#import "DAVehicleAnnotation.h"

#define PIN_PROVIDER @"TrackingDot.png"
#define PIN_VEHICLE @"Pin.png"

@implementation DAServiceMonitoringAnnotationView

@synthesize pinType, map;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation {
	
    if (self = [super initWithAnnotation:annotation reuseIdentifier:@"DAServiceMonitoringAnnotationView"]) {

		self.canShowCallout = YES;
		
		if ([annotation isKindOfClass:[DAProviderAnnotation class]]) {
			pinType = DAServiceMonitoringPinProvider;
			[self setSelected:YES];
		}
		else {
			pinType = DAServiceMonitoringPinVehicle;
			self.calloutOffset = CGPointMake(-10, 0);
		}
        NSString *imageName = (pinType == DAServiceMonitoringPinProvider ? PIN_PROVIDER : PIN_VEHICLE);
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        UIImage *image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
		pinImageView = [[UIImageView alloc] initWithImage:image];
		pinImageView.frame = CGRectMake(0, 0, pinImageView.image.size.width, pinImageView.image.size.height);
		self.bounds = pinImageView.frame;
		
		[self addSubview:pinImageView];
	}
    return self;
}

@end
