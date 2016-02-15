//
//  DAAutomakerPolicyManager.m
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 8/3/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAAutomakerPolicyManager.h"
#import "DAAutomakerPolicyListWS.h"

@implementation DAAutomakerPolicyManager

- (void)listPolicies {

	DAAutomakerPolicyListWS *listWS = [[DAAutomakerPolicyListWS alloc] init];
	[listWS setDelegate:self];
	[listWS listPolicies];
}

#pragma mark DAPolicyListDelegate methods

- (void)policyListWS:(id)policyListWS didListPolicies:(NSArray *)policiesFound {
	
	if ([delegate respondsToSelector:@selector(policyManager:didListPolicies:)])
		[delegate policyManager:self didListPolicies:policiesFound];
}

- (void)policyListWS:(id)policyListWS didFailWithErrorMessage:(NSString *)errorMessage {
	
	if ([delegate respondsToSelector:@selector(policyManager:listPoliciesDidFailWithErrorMessage:)])
		[delegate policyManager:self listPoliciesDidFailWithErrorMessage:errorMessage];
}

@end