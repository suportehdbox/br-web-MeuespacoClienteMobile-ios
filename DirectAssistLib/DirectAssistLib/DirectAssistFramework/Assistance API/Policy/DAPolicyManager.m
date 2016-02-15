//
//  DAPolicyManager.m
//  DirectAssistFramework
//
//  Created by Ricardo Ramos on 7/20/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAPolicyManager.h"
#import "DASavePolicyWS.h"
#import "DADeletePolicyWS.h"

@implementation DAPolicyManager

static id cachePolicyManager;

@synthesize delegate, policies;

- (void)savePolicy:(DAPolicyBase *)policy {
	DASavePolicyWS *savePolicyWS = [[DASavePolicyWS alloc] init];
	[savePolicyWS setDelegate:self.delegate];
	[savePolicyWS savePolicy:policy];
}

- (void)deletePolicy:(DAPolicyBase *)policy {
	DADeletePolicyWS *deletePolicyWS = [[DADeletePolicyWS alloc] init];
	[deletePolicyWS setDelegate:self.delegate];
	[deletePolicyWS deletePolicy:policy];
}

- (void)listPolicies {	
}

+ (id)cache {
	
	if (nil == cachePolicyManager)
		cachePolicyManager = [[self alloc] init];
	
	return cachePolicyManager;
}

@end
