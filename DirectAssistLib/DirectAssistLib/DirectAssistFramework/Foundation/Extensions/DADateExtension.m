//
//  DADateExtension.m
//  DirectAssistItau
//
//  Created by Ricardo Ramos on 8/7/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DADateExtension.h"


@implementation NSDate (DADateExtension)

+ (NSDate *)dateWithoutTime
{
    return [[NSDate date] dateAsDateWithoutTime];
}
-(NSDate *)dateByAddingDays:(NSInteger)numDays
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:numDays];

    NSDate *date = [gregorian dateByAddingComponents:comps toDate:self options:0];
    return date;
}

-(NSDate *)dateByAddingHours:(NSInteger)numHours
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setHour:numHours];
	
    NSDate *date = [gregorian dateByAddingComponents:comps toDate:self options:0];
    return date;
}

- (NSDate *)setMinutes:(NSInteger)numMinutes {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  
	NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:self];

    [comps setMinute:numMinutes];
	
    return [gregorian dateFromComponents:comps];
}

-(NSDate *)dateBySettingHours:(NSInteger)numHours andMinutes:(NSInteger)numMinutes
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:self];
	
    [comps setHour:numHours];
    [comps setMinute:numMinutes];
	
    NSDate *date = [gregorian dateFromComponents:comps];
    return date;
}


- (NSDate *)dateAsDateWithoutTime
{
    NSString *formattedString = [self formattedDateString];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy"];
    NSDate *ret = [formatter dateFromString:formattedString];
    return ret;
	
}
- (int)differenceInDaysTo:(NSDate *)toDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [gregorian components:NSDayCalendarUnit
                                                fromDate:self
                                                  toDate:toDate
                                                 options:0];
    NSInteger days = [components day];
    return days;
}

- (NSString *)formattedDateString
{
    return [self formattedStringUsingFormat:@"MMM dd, yyyy"];
}

- (NSString *)formattedStringUsingFormat:(NSString *)dateFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSString *ret = [formatter stringFromDate:self];
    return ret;
}

@end
