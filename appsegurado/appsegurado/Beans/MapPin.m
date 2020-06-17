//
//  MapPin.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 26/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "MapPin.h"

@implementation MapPin

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize autoWork;

- (id)initWithAutoWorkShop:(AutoWorkShopBeans*) autoWorkShop {
    self = [super init];
    if (self != nil) {
        coordinate = autoWorkShop.coordinate;
        title = autoWorkShop.name;
        subtitle = @"";//autoWorkShop.address;
        autoWork = autoWorkShop;
    }
    return self;
}
@end
