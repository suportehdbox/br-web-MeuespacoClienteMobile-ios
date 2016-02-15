//
//  DAPropertyPolicyFindViewController.m
//  DirectAssistItau
//
//  Created by Ricardo Ramos on 8/11/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAPropertyPolicyFindViewController.h"
#import "DAPropertyPolicyFindWS.h"

@implementation DAPropertyPolicyFindViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.assistanceType = kDAAssistanceTypeProperty;
    self.title = DALocalizedString(@"SearchPolicy", nil);
	self.policyKeyText = DALocalizedString(@"Zipcode", nil);
	self.policyKeyKeyboardType = UIKeyboardTypeNumberPad;
	
}

- (void)findPolicyWithPolicyKey:(NSString *)policyKey userDocument:(NSString *)userDocument {
	[super findPolicyWithPolicyKey:policyKey userDocument:userDocument];
	
	DAPropertyPolicyFindWS *policyFindWS = [[DAPropertyPolicyFindWS alloc] init];
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
