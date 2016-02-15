//
//  EventPhoto.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface EventPhoto : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * imagePosition;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSNumber * imageSection;
@property (nonatomic, retain) id fullSizeImage;
@property (nonatomic, retain) id thumbnailImage;
@property (nonatomic, retain) Event * event;

@end

@interface ImageToDataTransformer : NSValueTransformer {
}
@end