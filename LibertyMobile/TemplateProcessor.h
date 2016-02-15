//
//  TemplateProcessor.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface TemplateProcessor : NSObject {
}
@property (nonatomic, retain) NSDictionary *templateDictionary;

- (NSString *) processTemplate: (NSString *) template withObject: (NSObject *) anObject;
- (NSString *) processTemplateNamed: (NSString *) template withObject: (NSObject *) anObject;
- (NSString *) processValueForKey:(NSString *)template withObject:(NSObject *)anObject;
- (NSObject *) objectValueForKey:(NSString *) key withObject:(NSObject *) anObject;
- (NSString *) stringValueForKey:(NSString *) key withObject:(NSObject *) anObject;
- (NSString *) stringValue:(NSObject *) anObject;

@end
