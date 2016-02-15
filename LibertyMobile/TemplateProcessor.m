//
//  TemplateProcessor.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TemplateProcessor.h"


@implementation TemplateProcessor

@synthesize templateDictionary;

- (NSString *) processTemplateNamed: (NSString *) templateName withObject: (NSObject *) anObject {
	return [self processTemplate:[templateDictionary valueForKey:templateName] withObject:anObject];
}

- (NSString *) processTemplate: (NSString *) template withObject: (NSObject *) anObject {
	return [self processValueForKey: template withObject: anObject];
}

- (NSString *) stringValue:(NSObject *) anObject {
	if (anObject == nil) {
		return @"";
	}
	else if ([anObject isKindOfClass:[NSDate class]]) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		
		NSString *returnString = [dateFormatter stringFromDate:(NSDate *) anObject];
		[dateFormatter release];
		return returnString;
	}
	else {
		return [NSString stringWithFormat:@"%@", anObject];
	}
}

- (NSObject *) objectValueForKey:(NSString *) key withObject:(NSObject *) anObject {
	NSObject *returnObject;
	@try {
		returnObject = [anObject valueForKey:key];
	}
	@catch (NSException * e) {
		// Gracefully report failure how?
		returnObject = nil;
	}
	
	return returnObject;
}

- (NSString *) stringValueForKey:(NSString *) key withObject:(NSObject *) anObject {
	NSString *returnString;
	@try {
		returnString = [self stringValue:[anObject valueForKey:key]];
	}
	@catch (NSException * e) {
		returnString = @"";
	}
	
	return returnString;
}

- (NSString *) processValueForKey: (NSString *) template withArray: (NSArray *) anArray {
	NSMutableString *returnString = [NSMutableString stringWithCapacity:4096];
	
	NSEnumerator *enumerator = [anArray objectEnumerator];
	NSObject *anObject;
	
	while ((anObject = [enumerator nextObject])) {
		[returnString appendString:[self processValueForKey:template withObject: anObject]];
	}
	return returnString;
}

- (NSString *) processValueForKey: (NSString *) template withSet: (NSSet *) aSet {
	NSMutableString *returnString = [NSMutableString stringWithCapacity:4096];
	
	NSEnumerator *enumerator = [aSet objectEnumerator];
	NSObject *anObject;
	
	while ((anObject = [enumerator nextObject])) {
		[returnString appendString:[self processValueForKey:template withObject: anObject]];
	}
	return returnString;
}

- (NSString *) processValueForKey: (NSString *) template withObject: (NSObject *) anObject {
	
	if (template == nil) {
		return @"";
	}
	
	if ([anObject isKindOfClass:[NSSet class]]) {
		return [self processValueForKey: template withSet: (NSSet *) anObject];
	}
    
	if ([anObject isKindOfClass:[NSArray class]]) {
		return [self processValueForKey: template withArray: (NSArray *) anObject];
	}
	
	NSMutableString *returnString = [NSMutableString stringWithCapacity:4096];
	
	NSString *part;
	NSString *actionName;
	NSString *keyName;
	
	NSString *token = @"::token::";
	NSString *valueForKeyAction = @"valueForKey";
	NSString *templateForObjectAction = @"templateForObject";
	NSString *templateName;
	
	NSScanner *scanner = [NSScanner scannerWithString:template];
	[scanner setCharactersToBeSkipped:nil];
	
	BOOL vfkAtStart = FALSE;
	
	NSRange atBeginning = {0, [token length]};
	NSRange foundRange = [template rangeOfString: token];
	if (NSEqualRanges(atBeginning, foundRange)) {
		vfkAtStart = TRUE;
	}
	
	while ([scanner scanUpToString:token intoString:&part] || vfkAtStart) {
		if (vfkAtStart) {
			vfkAtStart = FALSE;
		}
		else {
			[returnString appendString:part];
		}
		if ([scanner isAtEnd]) {
			// We're good
		}
		else {
			// Advance past the token
			[scanner setScanLocation:[scanner scanLocation] + [token length]];
		}
		
		if ([scanner scanUpToString:@"::" intoString:&actionName]) {
			// Advance past ::
			[scanner setScanLocation:[scanner scanLocation] + 2];
			
			if ([valueForKeyAction isEqualToString:actionName]) {
				if ([scanner scanUpToString:@"::" intoString:&keyName]) {
					// Advance past ::
					[scanner setScanLocation:[scanner scanLocation] + 2];
					
					[returnString appendString:[self stringValueForKey:keyName withObject:anObject]];
				}
			}
			else if ([templateForObjectAction isEqualToString:actionName]) {
				if ([scanner scanUpToString:@"::" intoString:&templateName]) {
					// Advance past ::
					[scanner setScanLocation:[scanner scanLocation] + 2];
					
					if ([scanner scanUpToString:@"::" intoString:&keyName]) {
						// Advance past ::
						[scanner setScanLocation:[scanner scanLocation] + 2];
						NSObject *subObject = [self objectValueForKey:keyName withObject:anObject];
						if (subObject) {
							[returnString appendString:[self processTemplateNamed: templateName withObject:subObject]];
						}
					}
				}
			}
			else {
				//no key name found
			}
		}
		else {
			//No action found
		}
	}
	// Grab the rest, if any
	
	if ([scanner scanUpToString:@"" intoString:&part]) {
		[returnString appendString:part];
	}
	else {
		//Nothing to do
	}
	
	return returnString;
}

- (void) dealloc {
	[super dealloc];
	[templateDictionary release];
}

@end
