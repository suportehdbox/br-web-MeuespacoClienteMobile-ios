//
//  ClaimBeans.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 13/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClaimBeans : NSObject

@property (nonatomic,strong) NSString* number;
@property (nonatomic) int claimType;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *policy;
@property (nonatomic,strong,getter=getStatusClaim) NSString *statusClaim;


- (id)initWithDictionary:(NSDictionary*) dic;
- (id)initWithHomeDictionary:(NSDictionary*) dic;
- (id)initWithClaimDictionary:(NSDictionary*) dic;

-(int) getStatusClaimCode;
@end
