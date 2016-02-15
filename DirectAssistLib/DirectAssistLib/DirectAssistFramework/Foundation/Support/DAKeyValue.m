//
//  DAKeyValue.m
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 8/3/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAKeyValue.h"

@implementation DAKeyValue

@synthesize key, value, tag;

- (DAKeyValue *) initWithKey:(NSString *)newKey withValue:(NSString *)newValue withTag:(NSString *)newTag {
	self.key = newKey;
	self.value = newValue;
	self.tag = newTag;
	return self;
}

@end
