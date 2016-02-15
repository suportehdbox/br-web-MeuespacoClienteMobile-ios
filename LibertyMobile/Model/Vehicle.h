//
//  Vehicle.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Driver;

@interface Vehicle : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * make;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * registrationState;
@property (nonatomic, retain) NSString * registrationNumber;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) Driver * vehicleDriver;

@end
