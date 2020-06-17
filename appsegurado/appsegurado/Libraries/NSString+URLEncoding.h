//
//  NSString+URLEncoding.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 20/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)
- (nullable NSString *)stringByAddingPercentEncodingForRFC3986;
@end
