//
//  FBUserBeans.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 30/09/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "FBUserBeans.h"

@implementation FBUserBeans
@synthesize idUser,name,email,picture, type;

- (id)initWithDicitonary:(NSDictionary*) dic
{
    self = [super init];
    if (self) {
        idUser = [dic objectForKey:@"id"];
        name = [dic objectForKey:@"name"];
        email = [dic objectForKey:@"email"];
        if([[dic objectForKey:@"picture"] isKindOfClass:[NSDictionary class]]){
            picture = [[[dic objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
        }else{
            picture = [dic objectForKey:@"picture"];
        }
        type = Facebook;
    }
    return self;
}
@end
