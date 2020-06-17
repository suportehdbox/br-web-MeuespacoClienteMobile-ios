//
//  PolicyBeans.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 01/06/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InsuranceBeans.h"
#import "PaymentBeans.h"

@interface PolicyBeans : NSObject

@property (nonatomic,strong) InsuranceBeans *insurance;
@property (nonatomic,strong) NSMutableArray *payments;

- (id)initWithDictionary:(NSDictionary*) dic;
@end
