//
//  OpenClaimBeans.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 21/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityBeans.h"

@interface OpenClaimBeans : NSObject

@property (nonatomic,strong) NSString * policy;
@property (nonatomic) int claimType;
@property (nonatomic, strong) NSString *licensePlate;
@property (nonatomic, strong) NSString *claimDateTime;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic) int itemCode;
@property (nonatomic) long contractCode;
@property (nonatomic) int issueCode;
@property (nonatomic) int ciaCode;
@property (nonatomic) int issuingAgency;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userPhone;
@property (nonatomic) BOOL userIsDriver;
@property (nonatomic, strong) NSString *addressLine1;
@property (nonatomic, strong) NSString *addressLine2;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *addressSupport;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *district;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *driverName;
@property (nonatomic, strong) NSString *driverBirthDate;
@property (nonatomic, strong) NSString *driverPhone;
@property (nonatomic, strong) CityBeans *cityBeans;

@end
