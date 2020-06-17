//
//  ClaimBeans.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 13/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ClaimBeans.h"
@interface ClaimBeans(){
    int statusCode;
}
@end
@implementation ClaimBeans
@synthesize claimType,statusClaim,date, number,policy;
- (id)initWithDictionary:(NSDictionary*) dic
{
    self = [super init];
    if (self) {
        claimType = [[dic objectForKey:@"claimType"]  intValue];
        statusClaim = [dic objectForKey:@"statusClaim"];
        statusCode = [statusClaim intValue];
        date = ([dic objectForKey:@"date"] != [NSNull null] ? [dic objectForKey:@"date"] : @"");
    }
    return self;
}
- (id)initWithHomeDictionary:(NSDictionary*) dic
{
    self = [super init];
    if (self) {
        number = [dic objectForKey:@"number"];
        claimType = ([dic objectForKey:@"type"] != [NSNull null] ? [[dic objectForKey:@"type"] intValue] : 0);
        statusClaim = ([dic objectForKey:@"status"] != [NSNull null] ? [dic objectForKey:@"status"] : @"");
        statusCode = [statusClaim intValue];
        date = ([dic objectForKey:@"date"] != [NSNull null] ? [dic objectForKey:@"date"] : @"");
    }
    return self;
}
- (id)initWithClaimDictionary:(NSDictionary*) dic
{
    self = [super init];
    if (self) {
        number = [NSString stringWithFormat:@"%d", (int)[[dic objectForKey:@"number"] intValue]];
        claimType = ([dic objectForKey:@"type"] != [NSNull null] ? [[dic objectForKey:@"type"] intValue] : 0);
        policy = ([dic objectForKey:@"policy"] != [NSNull null] ? [dic objectForKey:@"policy"] : @"");
        statusClaim = ([dic objectForKey:@"status"] != [NSNull null] ? [dic objectForKey:@"status"] : @"");
        statusCode = [statusClaim intValue];
        date = ([dic objectForKey:@"date"] != [NSNull null] ? [dic objectForKey:@"date"] : @"");
    }
    return self;
}
-(int) getStatusClaimCode{
    return statusCode;
}
-(NSString*)getStatusClaim{
    switch (statusCode) {
        case 10:
        case 20:
        case 30:
        case 40:
        case 50:
        case 100:{
            NSString *status = [NSString stringWithFormat:@"Status%d",statusCode];
            return NSLocalizedString(status, @"");
        }
            break;
        default:
             return NSLocalizedString(@"StatusDesconhecido", @"");
        break;
    }
}
@end
