//
//  Contact.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Address;

@interface Contact : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * emailAddress;
@property (nonatomic, retain) NSString * homePhone;
@property (nonatomic, retain) NSString * mobilePhone;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) Address * contactAddress;

@end
