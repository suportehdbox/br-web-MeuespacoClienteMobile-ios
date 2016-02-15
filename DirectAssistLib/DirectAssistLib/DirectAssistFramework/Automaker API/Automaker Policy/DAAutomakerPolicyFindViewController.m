//
//  DAAutomakerPolicyFindViewController.m
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 8/18/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAAutomakerPolicyFindViewController.h"
#import "DAAutomakerPolicyFindWS.h"

@implementation DAAutomakerPolicyFindViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.assistanceType = kDAAssistanceTypeAutomaker;
	
	self.policyKeyText = [DALocalizedString(@"VehicleChassis", nil) lowercaseString];
	self.policyKeyKeyboardType = UIKeyboardTypeAlphabet;
	
}

- (void)findPolicyWithPolicyKey:(NSString *)policyKey userDocument:(NSString *)userDocument {
	[super findPolicyWithPolicyKey:policyKey userDocument:userDocument];
	
	DAAutomakerPolicyFindWS *policyFindWS = [[DAAutomakerPolicyFindWS alloc] init];
	[policyFindWS setDelegate:self];
	[policyFindWS findPolicyWithPolicyKey:policyKey userDocument:userDocument];
}

- (void)findPolicyWS:(id)findPolicyWS didFindPolicy:(DAPolicyBase *)policyFound {
	
	[self didFindPolicy:policyFound];
}

- (void)findPolicyWS:(id)findPolicyWS didFailWithErrorMessage:(NSString *)errorMessage {	
	
	[self didFailWithErrorMessage:errorMessage];
}

@end
