//
//  DADateExtension.h
//  DirectAssistItau
//
//  Created by Ricardo Ramos on 8/7/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (DADateExtension) 

+ (NSDate *)dateWithoutTime;
- (NSDate *)dateByAddingDays:(NSInteger)numDays;
- (NSDate *)dateByAddingHours:(NSInteger)numHours;
- (NSDate *)setMinutes:(NSInteger)numMinutes;
- (NSDate *)dateBySettingHours:(NSInteger)numHours andMinutes:(NSInteger)numMinutes;
- (NSDate *)dateAsDateWithoutTime;
- (int)differenceInDaysTo:(NSDate *)toDate;
- (NSString *)formattedDateString;
- (NSString *)formattedStringUsingFormat:(NSString *)dateFormat;

@end
