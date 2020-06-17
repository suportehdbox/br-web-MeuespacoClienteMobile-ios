//
//  BrokerBeans.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 13/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrokerBeans : NSObject

@property (nonatomic) long brokerCode;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *phone;


- (id)initWithDictionary:(NSDictionary*) dic;

@end
