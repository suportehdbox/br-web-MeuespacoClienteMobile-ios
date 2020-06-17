//
//  AutoWorkShopBeans.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 26/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "AutoWorkShopBeans.h"

@implementation AutoWorkShopBeans
@synthesize name,address,city,coordinate,distance,phone,type, weekEnd, weekStart, saturdayEnd, saturdayStart, indication, available;

- (id)initWithDicionary:(NSDictionary*) dic
{
    self = [super init];
    if (self) {
        if(dic != nil && [dic isKindOfClass:[NSDictionary class]]){
            name = [dic objectForKey:@"name"];
            address = [dic objectForKey:@"address"];
            city = [dic objectForKey:@"city"];
            coordinate = CLLocationCoordinate2DMake([[dic objectForKey:@"latitude"] doubleValue], [[dic objectForKey:@"longitude"] doubleValue]);
            distance = [NSString stringWithFormat:@"%.2lf Km",[[dic objectForKey:@"distance"] doubleValue]];
            phone = [dic objectForKey:@"phone"];
            type = [dic objectForKey:@"type"];
            weekStart = ([dic objectForKey:@"weekStart"] != [NSNull null] ? [dic objectForKey:@"weekStart"] : @"");
            weekStart = [self removeSeconds:weekStart];
            weekEnd = ([dic objectForKey:@"weekEnd"] != [NSNull null] ? [dic objectForKey:@"weekEnd"] : @"");
            weekEnd = [self removeSeconds:weekEnd];
            saturdayStart = ([dic objectForKey:@"saturdayStart"] != [NSNull null] ? [dic objectForKey:@"saturdayStart"] : @"");
            saturdayStart = [self removeSeconds:saturdayStart];
            saturdayEnd = ([dic objectForKey:@"saturdayEnd"] != [NSNull null] ? [dic objectForKey:@"saturdayEnd"] : @"");
            saturdayEnd = [self removeSeconds:saturdayEnd];
            
            indication = ([dic objectForKey:@"indication"] != [NSNull null] ? [[dic objectForKey:@"indication"] boolValue] : false);
            available = ([dic objectForKey:@"available"] != [NSNull null] ? [[dic objectForKey:@"available"] boolValue] : true);
            
        }
    }
    return self;
}

-(NSString*) getWorkingHoursPhrase{
    
    if(![weekStart isEqualToString:@""]){
        
        if(![saturdayStart isEqualToString:@""]){
            //HoraAtendimentoFull
            return [NSString stringWithFormat:NSLocalizedString(@"HoraAtendimentoFull", @""),weekStart,weekEnd,saturdayStart,saturdayEnd];
        }else{
            //HoraAtendimentoWeek
            return [NSString stringWithFormat:NSLocalizedString(@"HoraAtendimentoWeek", @""),weekStart,weekEnd];
        }
    }
    return @"";
    
}

-(NSString*) removeSeconds:(NSString*) time{
    if([time isEqualToString:@""]){
        return @"";
    }
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:[time componentsSeparatedByString:@":"]];
    
    while([mArray count] >= 3){
        [mArray removeLastObject];
    }
    return [mArray componentsJoinedByString:@":"];
}

@end
