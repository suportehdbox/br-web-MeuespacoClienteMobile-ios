//
//  RegisterBeans.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 04/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBUserBeans.h"
@interface RegisterBeans : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *policy;
@property (nonatomic,strong) NSString *cpf;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *CIFCode;
@property (nonatomic,strong) FBUserBeans *facebookInfo;
@property (nonatomic) int typePolice; // 0 AUTO | 1 HOME | 2 LIFE
@end
