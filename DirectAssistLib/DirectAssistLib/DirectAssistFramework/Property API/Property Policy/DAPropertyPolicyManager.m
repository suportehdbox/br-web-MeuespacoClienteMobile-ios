//
//  DAPropertyPolicyManager.m
//  DirectAssistItau
//
//  Created by Ricardo Ramos on 8/11/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAPropertyPolicyManager.h"
#import "DAPropertyPolicyListWS.h"

@implementation DAPropertyPolicyManager

- (void)listPolicies {
	
	DAPropertyPolicyListWS *policyListWS = [[DAPropertyPolicyListWS alloc] init];
	[policyListWS setDelegate:self];
	[policyListWS listPolicies];
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
