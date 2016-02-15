//
//  EventPhoto.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventPhoto.h"
#import "Event.h"


@implementation EventPhoto
@dynamic imagePosition;
@dynamic imageName;
@dynamic imageSection;
@dynamic fullSizeImage;
@dynamic thumbnailImage;
@dynamic event;


@end

@implementation ImageToDataTransformer

+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}

- (id)transformedValue:(id)value {
	NSData *data = UIImagePNGRepresentation(value);
	return data;
}

- (id)reverseTransformedValue:(id)value {
	return [UIImage imageWithData:value];
}

@end