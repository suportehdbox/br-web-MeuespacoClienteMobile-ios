//
//  DAPropertyManager.m
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 8/6/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAPropertyManager.h"
#import "DADevice.h"

@implementation DAPropertyManager

@synthesize modules, causesList, servicesList;

- (id)init {
	
	if (self = [super init]) {
		
		self.causesList = [[NSArray alloc] initWithObjects:
						   [[DAKeyValue alloc] initWithKey:@"HR01" withValue:DALocalizedString(@"EmergencyRepair", nil) withTag:@""], nil]; 
		
		self.servicesList = [[NSArray alloc] initWithObjects:
							 [[DAKeyValue alloc] initWithKey:@"CHR1" withValue:DALocalizedString(@"Locksmith", nil) withTag:@""],
							 [[DAKeyValue alloc] initWithKey:@"EL01" withValue:DALocalizedString(@"Electrician", nil) withTag:@""],
							 [[DAKeyValue alloc] initWithKey:@"EN01" withValue:DALocalizedString(@"Plumber", nil) withTag:@""], nil]; 
		
	}	
	return self;
}

- (id)initWithClient:(DAClientBase *)client {
	
	if (self = [self init]) {
		
		modules = [[NSMutableArray alloc] init];
		
		// New Case option
		[modules addObject:[[DAKeyValue alloc] initWithKey:@"NewFile" 
											   withValue:DALocalizedString(@"NewCase", nil) 
												 withTag:@""]];
		
		// My Cases option
		[modules addObject:[[DAKeyValue alloc] initWithKey:@"MyFiles" 
											   withValue:DALocalizedString(@"MyFiles", nil) 
												 withTag:@""]];
		
		// Call to Assistance Centre option
		if ([DADevice currentDevice].canMakeCalls)
			[modules addObject:[[DAKeyValue alloc] initWithKey:@"Call" 
												   withValue:DALocalizedString(@"CallToAssistanceCentre", nil) 
													 withTag:@""]];
	}
	return self;
}

@end
