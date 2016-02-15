//
//  Client.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 19/04/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DAClientBase.h"

@implementation DAClientBase

@synthesize clientID;
@synthesize clientName;
@synthesize defaultColor;
@synthesize bannerHomepage;
@synthesize mainPhoneNumber;
@synthesize propertyPhoneNumber;
@synthesize altPhoneNumber;
@synthesize automotiveServiceEnabled;
@synthesize automotiveServiceAccreditedGaragesEnabled;
@synthesize findPolicyDismissUserDocument;
@synthesize automakerServiceEnabled;
@synthesize propertyServiceEnabled;
@synthesize qualitySurveyEnabled;
@synthesize services;
@synthesize multipleBranding;
@synthesize brandingIdentifier;
@synthesize dynamicFooter = _dynamicFooter;

- (DAClientBase *)init {

	if (self = [super init]) {
		
		// default values
		_dynamicFooter = NO;
		
		[self setup];
		
		// Setup client services
		services = [[NSMutableArray alloc] init];
		
		// automotive
		if (automotiveServiceEnabled) {
			[services addObject:[[DAKeyValue alloc] initWithKey:@"Automotive" 
													withValue:DALocalizedString(@"AutomotiveAssistance", nil) 
													  withTag:@"AU"]];
		}

		// automaker
		if (automakerServiceEnabled) {
			[services addObject:[[DAKeyValue alloc] initWithKey:@"Automaker" 
													withValue:DALocalizedString(@"AutomotiveAssistance", nil) 
													  withTag:@"AM"]];
		}
		
		// property
		if (propertyServiceEnabled) 
			[services addObject:[[DAKeyValue alloc] initWithKey:@"Property" 
													  withValue:DALocalizedString(@"PropertyAssistance", nil) 
														withTag:@"PR"]];
	}
	
	return self;
}

-(void) setup {
}


@end
