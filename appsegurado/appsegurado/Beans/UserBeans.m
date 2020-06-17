//
//  UserBeans.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 28/09/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "UserBeans.h"

@implementation UserBeans
@synthesize access_token,token_type,expires,expires_in,userName,authToken,issued,emailCpf,cpfCnpj, photo, photoImg, insuranceHome, policyHome, hasFacebook,hasGooglePlus;
- (id)initWithDictionary:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        access_token = [dic objectForKey:@"access_token"];
        token_type = [dic objectForKey:@"token_type"];
        expires_in = [dic objectForKey:@"expires_in"];
        userName = [dic objectForKey:@"userName"];
        authToken = [dic objectForKey:@"authToken"];
        issued = [dic objectForKey:@".issued"];
        expires = [dic objectForKey:@".expires"];
        cpfCnpj = [dic objectForKey:@"CpfCnpj"];
        emailCpf = [dic objectForKey:@"Email"];
        photo = [dic objectForKey:@"Photo"];
        if([dic objectForKey:@"hasFacebook"] != [NSNull null] && [dic objectForKey:@"hasFacebook"] != nil){
            hasFacebook = [[dic objectForKey:@"hasFacebook"] boolValue];
        }else{
            hasFacebook = false;
        }
        
        if([dic objectForKey:@"hasGooglePlus"] != [NSNull null] && [dic objectForKey:@"hasGooglePlus"] != nil){
            hasGooglePlus = [[dic objectForKey:@"hasGooglePlus"] boolValue];
        }else{
            hasGooglePlus = false;
        }
        
        
    }
    return self;
}
@end
