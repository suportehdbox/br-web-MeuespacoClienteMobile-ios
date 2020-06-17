//
//  ContactBeans.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 12/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactBeans : NSObject

@property (nonatomic,strong) NSString* brokerCode;
@property (nonatomic,strong) NSString* title;
@property (nonatomic,strong) NSString* email;
@property (nonatomic,strong) NSString* phone;
@property (nonatomic,strong) NSString* hours;
@property (nonatomic,strong) NSString* policy;

- (id)initWithDictionary:(NSDictionary*)dic;
@end
