//
//  DAKeyValue.h
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 8/3/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DAKeyValue : NSObject {
	NSString *key;
	NSString *value;
	NSString *tag;
}

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *tag;

- (DAKeyValue *) initWithKey:(NSString *)newKey withValue:(NSString *)newValue withTag:(NSString *)newTag;

@end
