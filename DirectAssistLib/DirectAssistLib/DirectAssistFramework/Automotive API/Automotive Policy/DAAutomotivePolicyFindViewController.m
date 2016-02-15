//
//  DAAutomotivePolicyFindViewController.m
//  DirectAssistItau
//
//  Created by Ricardo Ramos on 8/12/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAAutomotivePolicyFindViewController.h"
#import "DAAutomotivePolicyFindWS.h"

@implementation DAAutomotivePolicyFindViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
    self.assistanceType = kDAAssistanceTypeAutomotive;
    self.title = DALocalizedString(@"SearchPolicyAutomotive", nil);
    
	self.policyKeyText = [DALocalizedString(@"VehicleLicense", nil) lowercaseString];
	self.policyKeyKeyboardType = UIKeyboardTypeAlphabet;
	
}

- (void)findPolicyWithPolicyKey:(NSString *)policyKey userDocument:(NSString *)userDocument {
	//[super findPolicyWithPolicyKey:policyKey userDocument:userDocument];
	
	DAAutomotivePolicyFindWS *policyFindWS = [[DAAutomotivePolicyFindWS alloc] init];
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
