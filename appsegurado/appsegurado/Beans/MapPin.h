//
//  MapPin.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 26/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AutoWorkShopBeans.h"

@interface MapPin : NSObject<MKAnnotation>

@property (nonatomic,strong) AutoWorkShopBeans *autoWork;

- (id)initWithAutoWorkShop:(AutoWorkShopBeans*) autoWorkShop;

@end
