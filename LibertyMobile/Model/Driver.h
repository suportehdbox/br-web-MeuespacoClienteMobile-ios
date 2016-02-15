//
//  Driver.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Contact.h"

@class Event, Vehicle;

@interface Driver : Contact {
@private
}
@property (nonatomic, retain) NSString * insuranceCompany;
@property (nonatomic, retain) NSString * policyNumber;
@property (nonatomic, retain) Event * driverEvent;
@property (nonatomic, retain) Vehicle * driverVehicle;

@end
