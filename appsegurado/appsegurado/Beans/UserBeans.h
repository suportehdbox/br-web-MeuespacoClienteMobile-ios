//
//  UserBeans.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 28/09/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InsuranceBeans.h"
#import "PolicyBeans.h"

@interface UserBeans : NSObject
@property(nonatomic,strong) NSString *access_token;
@property(nonatomic,strong) NSString *token_type;
@property(nonatomic,strong) NSString *expires_in;
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *authToken;
@property(nonatomic,strong) NSString *issued;
@property(nonatomic,strong) NSString *expires;
@property(nonatomic,strong) NSString *emailCpf;
@property(nonatomic,strong) NSString *cpfCnpj;
@property(nonatomic,strong) NSString *photo;
@property(nonatomic,strong) UIImage *photoImg;
@property(nonatomic) BOOL hasFacebook;
@property(nonatomic) BOOL isForceResetPassword;
@property(nonatomic) BOOL hasGooglePlus;
@property (nonatomic,strong) InsuranceBeans *insuranceHome __deprecated_msg("Use policyBeans");
@property (nonatomic,strong) PolicyBeans *policyHome;


- (id)initWithDictionary:(NSDictionary*)dic;
@end
