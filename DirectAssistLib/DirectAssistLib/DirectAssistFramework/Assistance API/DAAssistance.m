//
//  DAAssistance.m
//  DirectAssistFramework
//
//  Created by Ricardo Ramos on 7/28/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAAssistance.h"

const DAAssistance *sharedApplication;

@implementation DAAssistance

@synthesize automakerManager, automotiveManager, propertyManager;

+ (id)application {
	
	return sharedApplication;
}

+ (void)initialize {
	sharedApplication = [[DAAssistance alloc] init];
}

- (void)initializeClient:(DAClientBase *)client {

	[DAConfiguration settings].applicationClient = client;
	
	if (client.automotiveServiceEnabled)
		automotiveManager = [[DAAutomotiveManager alloc] initWithClient:client];
	
	if (client.automakerServiceEnabled)
		automakerManager = [[DAAutomakerManager alloc] initWithClient:client];

	if (client.propertyServiceEnabled)
		propertyManager = [[DAPropertyManager alloc] initWithClient:client];
}

@end
