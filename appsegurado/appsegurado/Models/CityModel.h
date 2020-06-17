//
//  CityModel.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 03/01/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "BaseModel.h"
#import "CityBeans.h"

@interface CityModel : BaseModel


-(NSMutableArray *) getCityFromState:(NSString*) state;
@end
