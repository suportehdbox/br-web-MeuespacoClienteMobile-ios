//
//  Vision360EventBeans.m
//  appsegurado
//
//  Created by RODRIGO MACEDO on 03/06/19.
//  Copyright © 2019 Liberty Seguros. All rights reserved.
//


#import "Vision360EventBeans.h"

@implementation Vision360EventBeans
@synthesize dateOc, description,valueFranq, value, image, type;
- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        dateOc = [dict valueForKey:@"dataOcorrencia"];
        description = [dict valueForKey:@"descricao"];
        image = [dict valueForKey:@"imagem"] != [NSNull null] ? [[dict valueForKey:@"imagem"] lowercaseString] : @"";
        valueFranq = [[dict objectForKey:@"valorFranquia"] floatValue];
        value = [[dict objectForKey:@"valorPago"] floatValue];
    }
    return self;
}
@end
