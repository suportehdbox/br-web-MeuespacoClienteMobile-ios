//
//  DAPolicyListBase.h
//  DirectAssistItau
//
//  Created by Ricardo Ramos on 8/12/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DAPolicyListDelegate;
@class DAPolicyBase;

@interface DAPolicyListBase : NSObject {

	id <DAPolicyListDelegate> delegate;
}

@property (nonatomic, strong) id <DAPolicyListDelegate> delegate;

- (void)listPolicies;
- (void)didListPolicies:(NSArray *)policiesFound;
- (void)didFailWithErrorMessage:(NSString *)errorMessage;

@end

@protocol DAPolicyListDelegate <NSObject> 
@optional

- (void)policyListWS:(id)policyListWS didListPolicies:(NSArray *)policiesFound;
- (void)policyListWS:(id)policyListWS didFailWithErrorMessage:(NSString *)errorMessage;


@end