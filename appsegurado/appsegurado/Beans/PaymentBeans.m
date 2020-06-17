//
//  Payment.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 19/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "PaymentBeans.h"

@implementation PaymentBeans
@synthesize  amountPayable,canExtend,dueDate,status,nextValue,nextDueDate,number,codigoTipoModalidadeCobranca, issuance, amountOfInstallment, showComponent;

- (id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        if([dic objectForKey:@"value"] != nil && [dic objectForKey:@"value"] != [NSNull null]){
            amountPayable = [[dic objectForKey:@"value"]  floatValue];
        }
        if([dic objectForKey:@"canExtend"] != nil && [dic objectForKey:@"canExtend"] != [NSNull null]){
            canExtend = [[dic objectForKey:@"canExtend"] boolValue];
        }
        if([dic objectForKey:@"dueDate"] != nil && [dic objectForKey:@"dueDate"] != [NSNull null]){
            dueDate = [dic objectForKey:@"dueDate"];
        }
        if([dic objectForKey:@"codigoTipoModalidadeCobranca"] != nil && [dic objectForKey:@"codigoTipoModalidadeCobranca"] != [NSNull null]){
           codigoTipoModalidadeCobranca = [dic objectForKey:@"codigoTipoModalidadeCobranca"];
        }else{
            codigoTipoModalidadeCobranca = @"";
        }
        
//        paidValue = ([dic objectForKey:@"value"] == [NSNull null]) ? 0.0f : [[dic objectForKey:@"value"] floatValue];
        if([dic objectForKey:@"number"] != nil && [dic objectForKey:@"number"] != [NSNull null]){
            number = [[dic objectForKey:@"number"] intValue];

        }else if([dic objectForKey:@"installmentNumber"] != nil && [dic objectForKey:@"installmentNumber"] != [NSNull null]){
            number = [[dic objectForKey:@"installmentNumber"] intValue];

        }else{
            number = 0;
        }

        if([dic objectForKey:@"amountOfInstallment"] != nil && [dic objectForKey:@"amountOfInstallment"] != [NSNull null]){
            amountOfInstallment = [[dic objectForKey:@"amountOfInstallment"] intValue];
        }else{
            amountOfInstallment = 0;
        }
        
        status = [[dic objectForKey:@"status"] intValue];
        nextValue = ([dic objectForKey:@"nextValue"] == [NSNull null]) ? 0.0f : [[dic objectForKey:@"nextValue"] floatValue];
        if([dic objectForKey:@"nextDueDate"]  == nil || [dic objectForKey:@"nextDueDate"] == [NSNull null]){
            nextDueDate = [dic objectForKey:@"nextDate"];
        }else{
            nextDueDate = [dic objectForKey:@"nextDueDate"];
        }
        
        showComponent = [[dic objectForKey:@"showComponent"] intValue];
        
    }
    return self;
}
@end
