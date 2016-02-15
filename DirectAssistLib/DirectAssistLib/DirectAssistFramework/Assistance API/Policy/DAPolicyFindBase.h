//
//  DAPolicyFindBase.h
//  DirectAssistItau
//
//  Created by Ricardo Ramos on 8/11/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DAPolicyFindDelegate;
@class DAPolicyBase;

@interface DAPolicyFindBase : NSObject {

	id <DAPolicyFindDelegate> delegate;

	NSString *selectedDoc;
	NSString *selectedPolicyKey;
}

@property (nonatomic, strong) id <DAPolicyFindDelegate> delegate;

- (void)findPolicyWithPolicyKey:(NSString *)policyKey userDocument:(NSString *)userDocument;
- (void)didFindPolicy:(DAPolicyBase *)policyFound;
- (void)didFailWithErrorMessage:(NSString *)errorMessage;

@end

@protocol DAPolicyFindDelegate <NSObject> 
@optional

- (void)findPolicyWS:(id)findPolicyWS didFindPolicy:(DAPolicyBase *)policyFound;
- (void)findPolicyWS:(id)findPolicyWS didFailWithErrorMessage:(NSString *)errorMessage;


@end