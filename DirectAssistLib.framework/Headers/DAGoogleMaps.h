//
//  DAGoogleMaps.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/15/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class DAAddress;

@interface DAGoogleMaps : NSObject {

}

+ (void)gotoAddress:(DAAddress *)address;
+ (void)getDirectionsFromAddress:(DAAddress *)source toAddress:(DAAddress *)destination;
+ (void)getDirectionsFromCoordinate:(CLLocationCoordinate2D)source toAddress:(DAAddress *)destination;

@end
