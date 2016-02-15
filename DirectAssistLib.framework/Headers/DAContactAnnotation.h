//
//  DAContactAnnotation.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/15/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class DAContact;

@interface DAContactAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	DAContact *contact;
	double distanceFromCenter;
}

@property (nonatomic, strong) DAContact *contact;
@property (nonatomic, assign) double distanceFromCenter;

- (id)initWithContact:(DAContact *)annotationContact;

@end
