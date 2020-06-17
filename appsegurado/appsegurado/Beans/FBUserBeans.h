//
//  FBUserBeans.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 30/09/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Facebook = 0,
    Google = 1
} SocialType;

@interface FBUserBeans : NSObject

@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSDecimalNumber * idUser;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * picture;
@property (nonatomic) SocialType type;

- (id)initWithDicitonary:(NSDictionary*) dic;
@end
