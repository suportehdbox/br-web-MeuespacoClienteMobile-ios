//
//  ContactBeans.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 12/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ContactBeans.h"

@implementation ContactBeans
@synthesize title,phone,hours, brokerCode, email, policy;

- (id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        title = [dic objectForKey:@"description"];
        phone = [dic objectForKey:@"phone"];
        email = [dic objectForKey:@"email"];
        brokerCode = [dic objectForKey:@"code"];
        policy = [dic objectForKey:@"policy"];
    }
    return self;
}
@end
