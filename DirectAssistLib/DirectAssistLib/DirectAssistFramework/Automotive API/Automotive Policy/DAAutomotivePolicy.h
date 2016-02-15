//
//  DAAutomotivePolicy.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 22/04/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DAPolicyBase.h"

@interface DAAutomotivePolicy : DAPolicyBase {
	NSString *vehiclePlate;
	NSString *vehicleModel;
	NSString *vehicleChassis;
	NSString *vehicleYear;
}

@property (nonatomic, copy) NSString *vehiclePlate;
@property (nonatomic, copy) NSString *vehicleModel;
@property (nonatomic, copy) NSString *vehicleChassis;
@property (nonatomic, copy) NSString *vehicleYear;

@end
