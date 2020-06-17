//
//  Tools.h
//
//  Created by Rubens on 19/12/13.
//  Copyright (c) 2013 Intuitive Appz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Tools : NSObject

+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIColor *)colorFromHexString:(NSString *)corHexa alpha:(float)alpha;
+ (BOOL) isValidateDate:(NSString *) dateOfBirth format:(NSString*)formatDate;
+ (NSString*) formatDate:(NSString *) date;
+ (NSString*) formatDateToServer:(NSString *) date;
+(float) getLabelHeightSize:(NSString *)font size:(float)size text:(NSString*)text widthLabel:(float) widthLabel;
NSMutableString *filteredPhoneStringFromStringWithFilter(NSString *string, NSString *filter);
+ (BOOL) emailIsValid: (NSString *) emailCheck;
@end
