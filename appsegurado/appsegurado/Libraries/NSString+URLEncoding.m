//
//  NSString+URLEncoding.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 20/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)
- (nullable NSString *)stringByAddingPercentEncodingForRFC3986 {
    NSString *unreserved = @"-._~?/";
    NSMutableCharacterSet *allowed = [NSMutableCharacterSet
                                      alphanumericCharacterSet];
    [allowed addCharactersInString:unreserved];
    return [self
            stringByAddingPercentEncodingWithAllowedCharacters:
            allowed];
}
@end
