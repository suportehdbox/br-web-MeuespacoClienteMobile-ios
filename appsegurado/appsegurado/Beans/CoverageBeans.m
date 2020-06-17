//
//  CoverageBeans.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 26/04/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "CoverageBeans.h"

@implementation CoverageBeans
@synthesize coverageDescription,detail,type,value;

- (id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        
                
        if([dic objectForKey:@"description"] != [NSNull null] && [dic objectForKey:@"description"] != nil){
            coverageDescription = [dic objectForKey:@"description"];
        }else{
            coverageDescription = @"";
        }

        
        if([dic objectForKey:@"detail"] != [NSNull null] && [dic objectForKey:@"detail"] != nil){
            detail = [dic objectForKey:@"detail"];
        }else{
            detail = @"";
        }
        
        
        if([dic objectForKey:@"value"] != [NSNull null] && [dic objectForKey:@"value"] != nil){
            value = [dic objectForKey:@"value"];
        }else{
            value = @"";
        }
        
        
        switch ([[dic objectForKey:@"type"] intValue]) {
            case 1:
                type = CT_COVERAGE;
                break;
            case 2:
                type = CT_ASSIST;
                break;
            default:
                type = CT_UNKNOWN;
                break;
        }
        
    }
    return self;
}

@end
