//
//  FBUserBeans.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 30/09/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "FBUserBeans.h"

@implementation FBUserBeans
@synthesize idUser,name,email,picture, type, appleUserId;

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

- (NSString *) getFormattedUserID{
    if(type == Apple){
        return appleUserId;
    }else{
        return [NSString stringWithFormat:@"%@", idUser];
    }
}

- (NSString *) getEncodedPesistenceString{
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendFormat:@"%@|",name];
    [string appendFormat:@"%@|",email];
    [string appendFormat:@"%@|",picture == nil ? @"" : picture];
    [string appendFormat:@"%d",type];

    NSString *encodedString = [[string dataUsingEncoding:NSUTF8StringEncoding]  base64EncodedStringWithOptions:0];
    NSLog(@"%@ - %@", string, encodedString);
    return encodedString;
}

-(void) fillWithEncodedString:(NSString *)encodedStrings{
    if(encodedStrings == nil || [encodedStrings isEqualToString:@""]){
        return;
    }
    NSData *nsData = [[NSData alloc] initWithBase64EncodedString:encodedStrings options:0];
    NSString *plainString = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
    NSArray *array = [plainString componentsSeparatedByString:@"|"];
    name = [array objectAtIndex:0];
    email = [array objectAtIndex:1];
    picture = [array objectAtIndex:2];
    type = [[array objectAtIndex:3] intValue];
}


@end
