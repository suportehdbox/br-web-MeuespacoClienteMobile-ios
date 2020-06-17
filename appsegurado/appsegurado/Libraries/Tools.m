//
//  Tools.m
//
//  Created by Rubens on 19/12/13.
//  Copyright (c) 2013 Intuitive Appz. All rights reserved.
//

#import "Tools.h"

@implementation Tools


+ (UIColor *)colorFromHexString:(NSString *)corHexa {

    if([corHexa length] > 6){
        long index = [corHexa length] - 6;
        corHexa = [corHexa substringFromIndex:index];
    }
    
    corHexa = [NSString stringWithFormat:@"#%@",corHexa];
    unsigned valorRGB = 0;
    
    NSScanner *scanner = [NSScanner scannerWithString:corHexa];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&valorRGB];
    
    return [UIColor colorWithRed:((valorRGB & 0xFF0000) >> 16)/255.0 green:((valorRGB & 0xFF00) >> 8)/255.0 blue:(valorRGB & 0xFF)/255.0 alpha:1.0];
}

+ (UIColor *)colorFromHexString:(NSString *)corHexa alpha:(float)alpha{
    corHexa = [NSString stringWithFormat:@"#%@",corHexa];
    unsigned valorRGB = 0;
    
    NSScanner *scanner = [NSScanner scannerWithString:corHexa];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&valorRGB];
    
    return [UIColor colorWithRed:((valorRGB & 0xFF0000) >> 16)/255.0 green:((valorRGB & 0xFF00) >> 8)/255.0 blue:(valorRGB & 0xFF)/255.0 alpha:alpha];
}


+ (BOOL) isValidateDate:(NSString *) dateOfBirth format:(NSString*)formatDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    [dateFormat setDateFormat:formatDate];
    if ([dateFormat dateFromString:dateOfBirth] == nil){
        return FALSE;
    }
    return TRUE;
}

+ (NSString*) formatDate:(NSString *) date
{
    NSRange range = [date rangeOfString:@"/" options:NSCaseInsensitiveSearch];
    if(range.location != NSNotFound){
        return date;
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = [dateFormat dateFromString:date];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *newDate =[dateFormat stringFromDate:currentDate];
    return newDate;
}

+ (NSString*) formatDateToServer:(NSString *) date
{
    NSRange range = [date rangeOfString:@"-" options:NSCaseInsensitiveSearch];
    if(range.location != NSNotFound){
        return date;
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSDate *currentDate = [dateFormat dateFromString:date];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *newDate =[dateFormat stringFromDate:currentDate];
    return newDate;
}

+(float) getLabelHeightSize:(NSString *)font size:(float)size text:(NSString*)text widthLabel:(float) widthLabel{
    CGSize constrainedSize = CGSizeMake(widthLabel  , 9999);
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:font size:size], NSFontAttributeName,
                                          nil];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:attributesDictionary];
    
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    if (requiredHeight.size.width > widthLabel) {
        requiredHeight = CGRectMake(0,0, widthLabel, requiredHeight.size.height);
    }
    
    return requiredHeight.size.height;
}

NSMutableString *filteredPhoneStringFromStringWithFilter(NSString *string, NSString *filter)
{
    NSUInteger onOriginal = 0, onFilter = 0, onOutput = 0;
    char outputString[([filter length])];
    BOOL done = NO;
    
    while(onFilter < [filter length] && !done)
    {
        char filterChar = [filter characterAtIndex:onFilter];
        char originalChar = onOriginal >= string.length ? '\0' : [string characterAtIndex:onOriginal];
        switch (filterChar) {
            case '#':
                if(originalChar=='\0')
                {
                    // We have no more input numbers for the filter.  We're done.
                    done = YES;
                    break;
                }
                if(isdigit(originalChar))
                {
                    outputString[onOutput] = originalChar;
                    onOriginal++;
                    onFilter++;
                    onOutput++;
                }
                else
                {
                    onOriginal++;
                }
                break;
            default:
                // Any other character will automatically be inserted for the user as they type (spaces, - etc..) or deleted as they delete if there are more numbers to come.
                outputString[onOutput] = filterChar;
                onOutput++;
                onFilter++;
                if(originalChar == filterChar)
                    onOriginal++;
                break;
        }
    }
    outputString[onOutput] = '\0'; // Cap the output string
    return (NSMutableString*)[NSString stringWithUTF8String:outputString];
}


+ (BOOL) emailIsValid: (NSString *) emailCheck{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailCheck];
}
@end
