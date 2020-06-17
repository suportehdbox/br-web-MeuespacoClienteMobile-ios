//
//  BrokerBeans.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 13/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BrokerBeans.h"

@implementation BrokerBeans
@synthesize brokerCode, desc, email, phone;

- (id)initWithDictionary:(NSDictionary*) dic
{
    self = [super init];
    if (self) {
        brokerCode = [[dic objectForKey:@"code"]  longValue];
        desc = ([dic objectForKey:@"description"] == [NSNull null] ? @"" : [dic objectForKey:@"description"]);
        email = ([dic objectForKey:@"email"] == [NSNull null] ? @"" : [dic objectForKey:@"email"] );
        phone = ([dic objectForKey:@"phone"] == [NSNull null] ? @"" : [dic objectForKey:@"phone"] );
    }
    return self;
}


@end
