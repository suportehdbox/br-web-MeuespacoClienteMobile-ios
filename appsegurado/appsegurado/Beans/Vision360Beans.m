//
//  Vision360Beans.m
//  appsegurado
//
//  Created by RODRIGO MACEDO on 28/05/19.
//  Copyright © 2019 Liberty Seguros. All rights reserved.
//
#import "Vision360Beans.h"
#import "Vision360EventBeans.h"

@implementation Vision360Beans
@synthesize message,totalPre,totalDesc, success, isEvent, event, assists;
- (id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        message = [dic objectForKey:@"message"];
        totalPre = [[dic objectForKey:@"totalPremio"]  floatValue];
        totalDesc = [[dic objectForKey:@"totalDesconto"] floatValue];
        success = [[dic objectForKey:@"success"] boolValue];
        isEvent = [[dic objectForKey:@"possuiEvento"] boolValue];

        event = [[NSMutableArray alloc] init];
        
       if([dic objectForKey:@"eventos"] != nil && [dic objectForKey:@"eventos"] != [NSNull null]){
            for (NSDictionary *dicEvent in [dic objectForKey:@"eventos"]) {
                Vision360EventBeans * eventBeans = [[Vision360EventBeans alloc] initWithDictionary:dicEvent];
                [eventBeans setType:NSEvent];
                [event addObject:eventBeans];
            }
        }
        
        assists = [[NSMutableArray alloc] init];
         
        if([dic objectForKey:@"assistencias"] != nil && [dic objectForKey:@"assistencias"] != [NSNull null]){
             for (NSDictionary *dicEvent in [dic objectForKey:@"assistencias"]) {
                 Vision360EventBeans * assist = [[Vision360EventBeans alloc] initWithDictionary:dicEvent];
                 [assist setType:NSAssist];
                 [assists addObject:assist];
             }
         }
        
    }
    return self;
}
@end



