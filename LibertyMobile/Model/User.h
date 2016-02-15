//
//  User.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Contact.h"


@interface User : Contact {
@private
}
@property (nonatomic, retain) NSString * homePolicyNumber;
@property (nonatomic, retain) NSString * autoPolicyNumber;

@end
