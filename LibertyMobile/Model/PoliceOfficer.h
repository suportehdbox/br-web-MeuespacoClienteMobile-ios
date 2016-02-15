//
//  PoliceOfficer.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Contact.h"

@class Event;

@interface PoliceOfficer : Contact {
@private
}
@property (nonatomic, retain) NSString * locality;
@property (nonatomic, retain) NSString * entityName;
@property (nonatomic, retain) Event * policeOfficerEvent;

@end
