//
//  DAPolicyListBase.m
//  DirectAssistItau
//
//  Created by Ricardo Ramos on 8/12/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAPolicyListBase.h"

@implementation DAPolicyListBase

@synthesize delegate;

- (void)listPolicies {
	
}

- (void)didListPolicies:(NSArray *)policiesFound {
	
	if ([delegate respondsToSelector:@selector(policyListWS:didListPolicies:)])
		[delegate policyListWS:self didListPolicies:policiesFound];
}

- (void)didFailWithErrorMessage:(NSString *)errorMessage {
	
	if ([delegate respondsToSelector:@selector(policyListWS:didFailWithErrorMessage:)])
		[delegate policyListWS:self didFailWithErrorMessage:errorMessage];
}

@end
