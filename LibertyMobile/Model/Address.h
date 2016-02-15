//
//  Address.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact, Event;

@interface Address : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * crossStreet;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * streetAddress;
@property (nonatomic, retain) NSString * zipCode;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) Contact * addressContact;
@property (nonatomic, retain) Event * addressEvent;

@end
