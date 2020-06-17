//
//  InsuranceBeans.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 13/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BrokerBeans.h"
#import "ClaimBeans.h"
#import "PaymentBeans.h"
#import "CoverageBeans.h"
@interface InsuranceStatus : NSObject
@property (nonatomic,strong) NSString *dataEndPolicy;
@property (nonatomic,strong) NSString *dataStartPolicy;
@property (nonatomic,strong) NSString *licensePlate;
@property (nonatomic) int status;

@property (nonatomic) int totalDuration;
@property (nonatomic) int daysRemaining;

- (id)initWithDictionary:(NSDictionary*) dic;

@end

@interface InsuranceItensBeans : NSObject
@property (nonatomic,strong) BrokerBeans *broker;
@property (nonatomic,strong) ClaimBeans *claim;
@property (nonatomic) int ciaCode;
@property (nonatomic) int itemCode;
@property (nonatomic) long contract;
@property (nonatomic) long cifCode;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) InsuranceStatus *insuranceStatus;
@property (nonatomic,strong) PaymentBeans *payment;
@property (nonatomic) int issuance;
@property (nonatomic) int issuingAgency;
@property (nonatomic,strong) NSString *policy;
@property (nonatomic,strong) NSString *policyBranch;
@property (nonatomic,strong) NSString *insuranceCoverages;
@property (nonatomic,strong) NSArray *coveragesArray;
@property (nonatomic) int ipvaRemaining;
@property (nonatomic) int licensingRemaining;

@property (nonatomic,strong) NSString *branchName;
@property (nonatomic,strong) NSString *branchImageName;




- (id)initWithDictionary:(NSDictionary*) dic;
- (id)initWithHomeDictionary:(NSDictionary*) dic;
-(BOOL) isAutoPolicy;
@end
