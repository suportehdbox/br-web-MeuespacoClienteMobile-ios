//
//  DAStringExtension.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/27/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAStringExtension.h"


@implementation NSString (DAStringExtension)

- (NSString *)wordCapitalizedString {

	NSArray *words = [[self lowercaseString] componentsSeparatedByString:@" "];
	NSMutableString *resultString = [[NSMutableString alloc] init];
	
	for (NSString *word in words) {
	
		NSString *capitalizedWord;
		if ([word length] > 0) {
			if ([word length] == 1)
				capitalizedWord = [word uppercaseString];
			else if ([word length] == 2)
				capitalizedWord = [word lowercaseString];
			else 
				capitalizedWord = [NSString stringWithFormat:@"%@%@", 
								   [[word substringToIndex:1] capitalizedString], 
								   [word substringFromIndex:1]];				
			
			[resultString appendFormat:@"%@ ", capitalizedWord];
		}
	}
	
	return [resultString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
