//
//  NotificationBeans.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 14/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "NotificationBeans.h"

@implementation NotificationBeans
@synthesize idNotification, date,alert;

- (id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {

        date = [dic objectForKey:@"date"];
        alert = [dic objectForKey:@"alert"];
             
    }
    return self;
}

@end
