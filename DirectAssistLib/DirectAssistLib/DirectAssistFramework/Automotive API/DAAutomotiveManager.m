//
//  DAAutomotiveManager.m
//  DirectAssistMondial
//
//  Created by Ricardo Ramos on 8/6/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAAutomotiveManager.h"
#import "DADevice.h"

@implementation DAAutomotiveManager

@synthesize modules, causesList, problemsList, servicesList;

- (id)init {
	
	if (self = [super init]) {
        
        Client *client = [[Client  alloc] init];
        /* HELIAR */
        if (client.clientID == 173) {
            
            self.causesList = [[NSArray alloc] initWithObjects:
                               [[DAKeyValue alloc] initWithKey:@"31" withValue:DALocalizedString(@"BreakDown", nil) withTag:@""], nil];
            
            self.problemsList = [[NSArray alloc] initWithObjects:
                                 [[DAKeyValue alloc] initWithKey:@"124" withValue:DALocalizedString(@"Battery", nil) withTag:@"R40"],
                                 [[DAKeyValue alloc] initWithKey:@"127" withValue:@"Pane elétrica" withTag:@"R40"],
                                  nil];
            
            self.servicesList = [[NSArray alloc] initWithObjects:
                                 [[DAKeyValue alloc] initWithKey:@"R40"     withValue:DALocalizedString(@"RoadsideRepair", nil) withTag:@""],
                                 [[DAKeyValue alloc] initWithKey:@"R41" withValue:DALocalizedString(@"TowTruck", nil) withTag:@""], nil];
           
        /* TOYOTA */
        } else if (client.clientID == 51 ) {
        
            self.causesList = [[NSArray alloc] initWithObjects:
                               [[DAKeyValue alloc] initWithKey:@"30" withValue:DALocalizedString(@"Accident", nil   ) withTag:@""],
                               [[DAKeyValue alloc] initWithKey:@"31" withValue:DALocalizedString(@"BreakDown", nil) withTag:@""], nil];
		
            self.problemsList = [[NSArray alloc] initWithObjects:
                                 [[DAKeyValue alloc] initWithKey:@"124" withValue:DALocalizedString(@"Battery", nil) withTag:@"R40"], nil];
		
            self.servicesList = [[NSArray alloc] initWithObjects:
                                 [[DAKeyValue alloc] initWithKey:@"R40"     withValue:DALocalizedString(@"RoadsideRepair", nil) withTag:@""],
                                 [[DAKeyValue alloc] initWithKey:@"R41" withValue:DALocalizedString(@"TowTruck", nil) withTag:@""], nil];
        } else {
            
            self.causesList = [[NSArray alloc] initWithObjects:
                               [[DAKeyValue alloc] initWithKey:@"30" withValue:DALocalizedString(@"Accident", nil   ) withTag:@""],
                               [[DAKeyValue alloc] initWithKey:@"31" withValue:DALocalizedString(@"BreakDown", nil) withTag:@""], nil];
            
            
            self.problemsList = [[NSArray alloc] initWithObjects:
                                 [[DAKeyValue alloc] initWithKey:@"124" withValue:DALocalizedString(@"Battery", nil) withTag:@"R40"],
                                 [[DAKeyValue alloc] initWithKey:@"19" withValue:@"Motor não pega" withTag:@"R40"],
                                 [[DAKeyValue alloc] initWithKey:@"127" withValue:@"Pane elétrica" withTag:@"R40"],
                                 [[DAKeyValue alloc] initWithKey:@"127" withValue:@"Motor" withTag:@"R40"],
                                 [[DAKeyValue alloc] initWithKey:@"122" withValue:DALocalizedString(@"Others", nil) withTag:@""], nil];
            
            self.servicesList = [[NSArray alloc] initWithObjects:
                                 [[DAKeyValue alloc] initWithKey:@"R40"     withValue:DALocalizedString(@"RoadsideRepair", nil) withTag:@""],
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
		
		if (client.automotiveServiceAccreditedGaragesEnabled) {
			// Accredited Garages list option
			[modules addObject:[[DAKeyValue alloc] initWithKey:@"MechanicNetwork" 
												   withValue:DALocalizedString(@"AccreditedGarages", nil) 
													 withTag:@""]];
		}
		
		// Call to Assistance Centre option
		if ([DADevice currentDevice].canMakeCalls)
			[modules addObject:[[DAKeyValue alloc] initWithKey:@"Call" 
												   withValue:DALocalizedString(@"CallToAssistanceCentre", nil) 
													 withTag:@""]];
	}
	return self;
}

@end
