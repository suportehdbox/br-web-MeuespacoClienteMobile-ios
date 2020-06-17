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
#import "InsuranceItensBeans.h"

@interface ItemInsurance : NSObject
@property (nonatomic, strong) ClaimBeans *claim;
@property (nonatomic) int code;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSArray *coveragesArray;
@property (nonatomic) int issuance;
@property (nonatomic,strong) NSString *licensePlate;
- (id)initWithDictionary:(NSDictionary*) dic;


@end

@interface InsuranceBeans : NSObject
@property (nonatomic,strong) BrokerBeans *broker;
@property (nonatomic) int ciaCode;
@property (nonatomic) long contract;
@property (nonatomic) long cifCode;
@property (nonatomic) bool allowPHS;


//@property (nonatomic,strong) NSMutableArray *payments;
@property (nonatomic,strong) NSMutableArray *itens;
@property (nonatomic,strong) NSArray *issuances;
@property (nonatomic) int issuingAgency;
@property (nonatomic,strong) NSString *policy;
@property (nonatomic,strong) NSString *policyBranch;
@property (nonatomic,strong) NSString *insuranceCoverages;

@property (nonatomic) int ipvaRemaining;
@property (nonatomic) int licensingRemaining;

@property (nonatomic,strong) NSString *branchName;
@property (nonatomic,strong) NSString *branchImageName;

@property (nonatomic,strong) NSString *dataEndPolicy;
@property (nonatomic,strong) NSString *dataStartPolicy;
@property (nonatomic,strong) NSString *licensePlate;
@property (nonatomic) int status;

@property (nonatomic) int totalDuration;
@property (nonatomic) int daysRemaining;



- (id)initWithDictionaryV2:(NSDictionary*) dic;
-(id) initWithInsuranceIten:(InsuranceItensBeans*) bean;
-(BOOL) isAutoPolicy;
@end
