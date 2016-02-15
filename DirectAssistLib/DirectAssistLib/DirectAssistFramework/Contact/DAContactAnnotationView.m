//
//  DAContactAnnotationView.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/15/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAContactAnnotationView.h"


@implementation DAContactAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation {
	
    if (self = [super initWithAnnotation:annotation reuseIdentifier:@"DAContactAnnotationView"]) {
		self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        UIImage *image = [UIImage imageNamed:@"ContactPin.png" inBundle:bundle compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
        self.image = image;
		self.canShowCallout = YES;
		self.centerOffset = CGPointMake(0, -28);

	
	}
    return self;
}

@end
