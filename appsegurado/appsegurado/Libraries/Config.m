//
//  Config.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 06/10/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "Config.h"

@implementation Config
+(BOOL) isAliroProject{
    NSString *app = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"APP"];
    if([app isEqualToString:@"ALIRO"]){
        return YES;
    }
    return NO;
}
+(BOOL) newClaimEnable {
//    if([Config isAliroProject]){
//        return false;
//    }
    return true;
}
@end
