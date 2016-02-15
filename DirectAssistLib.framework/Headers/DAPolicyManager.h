//
//  DAPolicyManager.h
//  DirectAssistFramework
//
//  Created by Ricardo Ramos on 7/20/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DAPolicyBase;
@protocol DAPolicyManagerDelegate;

@interface DAPolicyManager : NSObject {

	id <DAPolicyManagerDelegate> delegate;
	NSMutableArray *policies;
}

@property (nonatomic, strong) id <DAPolicyManagerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *policies;

- (void)savePolicy:(DAPolicyBase *)policy;
- (void)deletePolicy:(DAPolicyBase *)policy;
- (void)listPolicies;

+ (DAPolicyManager *)cache;

@end

@protocol DAPolicyManagerDelegate <NSObject>
@optional

- (void)policyManager:(DAPolicyManager *)policyManager didSavePolicy:(DAPolicyBase *)savedPolicy;
- (void)policyManager:(DAPolicyManager *)policyManager savePolicyDidFailWithErrorMessage:(NSString *)errorMessage;
- (void)policyManager:(DAPolicyManager *)policyManager didDeletePolicy:(DAPolicyBase *)deletedPolicy;
- (void)policyManager:(DAPolicyManager *)policyManager deletePolicyDidFailWithErrorMessage:(NSString *)errorMessage;
- (void)policyManager:(DAPolicyManager *)policyManager didListPolicies:(NSArray *)policiesFound;
- (void)policyManager:(DAPolicyManager *)policyManager listPoliciesDidFailWithErrorMessage:(NSString *)errorMessage;@end

