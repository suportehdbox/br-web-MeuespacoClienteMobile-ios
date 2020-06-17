//
//  AutoWorkShopBeans.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 26/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface AutoWorkShopBeans : NSObject


@property (nonatomic, strong) NSString* address;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* distance;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* phone;
@property (nonatomic, strong) NSString* weekStart;
@property (nonatomic, strong) NSString* weekEnd;
@property (nonatomic, strong) NSString* saturdayStart;
@property (nonatomic, strong) NSString* saturdayEnd;
@property (nonatomic, strong) NSString* type;

@property (nonatomic) BOOL indication;
@property (nonatomic) BOOL available;

- (id)initWithDicionary:(NSDictionary*) dic;
-(NSString*) getWorkingHoursPhrase;
@end
