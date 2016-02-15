//
//  DAContactAnnotation.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/15/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAContactAnnotation.h"
#import "DAContact.h"
#import "DAAddress.h"

@implementation DAContactAnnotation

@synthesize contact, coordinate, distanceFromCenter;

- (NSString *)title{
	
	return [contact.name wordCapitalizedString];
}

- (NSString *)subtitle{
	
	return [NSString stringWithFormat:@"%0.1f km", (distanceFromCenter / 1000)];
}

- (id)initWithContact:(DAContact *)annotationContact {
	
	if (self = [super init]) {
		contact = annotationContact;
		coordinate = annotationContact.address.coordinate;
	}
	return self;
}

@end
