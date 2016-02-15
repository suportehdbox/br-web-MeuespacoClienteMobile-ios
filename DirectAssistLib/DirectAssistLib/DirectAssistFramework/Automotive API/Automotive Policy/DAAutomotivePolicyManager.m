//
//  ContractWS.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 24/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DAAutomotivePolicyManager.h"
#import "DAAutomotivePolicyListWS.h"


@implementation DAAutomotivePolicyManager

- (void)listPolicies {
	
	DAAutomotivePolicyListWS *policyListWS = [[DAAutomotivePolicyListWS alloc] init];
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
