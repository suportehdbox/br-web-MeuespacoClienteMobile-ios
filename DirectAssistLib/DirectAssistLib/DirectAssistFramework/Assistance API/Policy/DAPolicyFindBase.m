//
//  DAPolicyFindBase.m
//  DirectAssistItau
//
//  Created by Ricardo Ramos on 8/11/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAPolicyFindBase.h"


@implementation DAPolicyFindBase

@synthesize delegate;

- (void)findPolicyWithPolicyKey:(NSString *)policyKey userDocument:(NSString *)userDocument {

}

- (void)didFindPolicy:(DAPolicyBase *)policyFound {

	if ([delegate respondsToSelector:@selector(findPolicyWS:didFindPolicy:)])
		[delegate findPolicyWS:self didFindPolicy:policyFound];
}

- (void)didFailWithErrorMessage:(NSString *)errorMessage {
	
	if ([delegate respondsToSelector:@selector(findPolicyWS:didFailWithErrorMessage:)])
		[delegate findPolicyWS:self didFailWithErrorMessage:errorMessage];
}

@end
