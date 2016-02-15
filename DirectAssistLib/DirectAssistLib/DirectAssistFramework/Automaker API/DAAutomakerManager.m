//
//  DAAutomakerManager.m
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 7/28/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAAutomakerManager.h"
#import "DADevice.h"

@implementation DAAutomakerManager

const DAAutomakerManager *automakerManager;

@synthesize modules, causesList, problemsList, servicesList;

- (id)init {

	if (self = [super init]) {
	
		self.causesList = [[NSArray alloc] initWithObjects:
						   [[DAKeyValue alloc] initWithKey:@"30" withValue:DALocalizedString(@"Accident", nil) withTag:@""],
						   [[DAKeyValue alloc] initWithKey:@"31" withValue:DALocalizedString(@"BreakDown", nil) withTag:@""], nil]; 
		
        if([DAConfiguration settings].applicationClient.clientID == 51) {
            self.problemsList = [[NSArray alloc] initWithObjects:
                             [[DAKeyValue alloc] initWithKey:@"124" withValue:DALocalizedString(@"Battery", nil) withTag:@"R40"], nil];
        } else {
            self.problemsList = [[NSArray alloc] initWithObjects:
							 [[DAKeyValue alloc] initWithKey:@"124" withValue:@"Bateria" withTag:@"R40"],
							 [[DAKeyValue alloc] initWithKey:@"19" withValue:@"Motor não pega" withTag:@"R40"],
							 [[DAKeyValue alloc] initWithKey:@"127" withValue:@"Pane elétrica" withTag:@"R40"],
							 [[DAKeyValue alloc] initWithKey:@"127" withValue:@"Motor" withTag:@"R40"],
							 [[DAKeyValue alloc] initWithKey:@"122" withValue:DALocalizedString(@"Others", nil) withTag:@""], nil];
        }
        
        if([DAConfiguration settings].applicationClient.clientID == 30)
        {
            self.servicesList = [[NSArray alloc] initWithObjects:
                             [[DAKeyValue alloc] initWithKey:@"R41" withValue:DALocalizedString(@"TowTruck", nil) withTag:@""], nil]; 
        }
        else {
            self.servicesList = [[NSArray alloc] initWithObjects:
                                 [[DAKeyValue alloc] initWithKey:@"R40" withValue:DALocalizedString(@"RoadsideRepair", nil) withTag:@""],
                                 [[DAKeyValue alloc] initWithKey:@"R41" withValue:DALocalizedString(@"TowTruck", nil) withTag:@""], nil]; 
        }
            
		
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
		
		// Dealers list option
		[modules addObject:[[DAKeyValue alloc] initWithKey:@"DealersList" 
													withValue:DALocalizedString(@"DealersList", nil) 
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
