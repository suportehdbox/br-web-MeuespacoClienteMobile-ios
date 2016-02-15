//
//  AccessInfo.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AccessInfo : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * cpfNumber;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * passwordRemeber;
@property (nonatomic, retain) NSString * policyNumber;

@end
