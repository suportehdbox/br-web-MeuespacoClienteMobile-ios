//
//  NotificationBeans.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 14/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationBeans : NSObject

@property (nonatomic) int idNotification;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *alert;


- (id)initWithDictionary:(NSDictionary*)dic;


@end
