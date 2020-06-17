//
//  DigitableLineBeans.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 22/03/18.
//  Copyright © 2018 Liberty Seguros. All rights reserved.
//

#import "DigitableLineBeans.h"

@implementation DigitableLineBeans
@synthesize dueDate,digitableLine,value, summaryInstructions, completeInstructions;

- (id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        if([dic objectForKey:@"summaryInstructions"] != [NSNull null] && [dic objectForKey:@"summaryInstructions"] != nil){
            summaryInstructions = [dic objectForKey:@"summaryInstructions"];
        }else{
            summaryInstructions = @"";
        }
        
        
        if([dic objectForKey:@"completeInstructions"] != [NSNull null] && [dic objectForKey:@"completeInstructions"] != nil){
            completeInstructions = [dic objectForKey:@"completeInstructions"];
        }else{
            completeInstructions = @"";
        }
        
        
        if([dic objectForKey:@"value"] != [NSNull null] && [dic objectForKey:@"value"] != nil){
            value = [dic objectForKey:@"value"];
        }else{
            value = @"";
        }
        
        if([dic objectForKey:@"digitableLine"] != [NSNull null] && [dic objectForKey:@"digitableLine"] != nil){
            digitableLine = [dic objectForKey:@"digitableLine"];
        }else{
            digitableLine = @"";
        }
        
        if([dic objectForKey:@"dueDate"] != [NSNull null] && [dic objectForKey:@"dueDate"] != nil){
            dueDate = [dic objectForKey:@"dueDate"];
        }else{
            dueDate = @"";
        }

    }
    return self;
}

@end
