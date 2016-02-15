//
//  PoliceReport.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface PoliceReport : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * reportNumber;
@property (nonatomic, retain) Event * policeReportEvent;

@end
