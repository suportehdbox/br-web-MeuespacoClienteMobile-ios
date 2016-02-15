//
//  DAAutomakerPolicy.h
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 8/3/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAAutomotivePolicy.h" 

@interface DAAutomakerPolicy : DAAutomotivePolicy {
@private
	NSInteger _carID;
	NSString *_saleDateString;

}

@property (nonatomic, assign) NSInteger carID;
@property (nonatomic, strong) NSString *saleDateString;

@end
