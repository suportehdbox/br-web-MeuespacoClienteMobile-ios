//
//  PolicyBeans.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 01/06/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "PolicyBeans.h"

@implementation PolicyBeans
@synthesize insurance, payments;

- (id)initWithDictionary:(NSDictionary*) dic{
    self = [super init];
    if (self) {
        
        insurance = [[InsuranceBeans alloc] initWithDictionaryV2:[dic objectForKey:@"insurance"]];
        payments = [[NSMutableArray alloc] init];
        
        if([dic objectForKey:@"payments"] != nil && [dic objectForKey:@"payments"] != [NSNull null]){
            for (NSDictionary *dicPayment in [dic objectForKey:@"payments"]) {
                [payments addObject:[[PaymentBeans alloc] initWithDictionary:dicPayment]];
            }
        }
        
        
        
    }
    return self;

}
@end
