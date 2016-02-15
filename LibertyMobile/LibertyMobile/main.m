//
//  main.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LibertyMobileAppDelegate.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([LibertyMobileAppDelegate class]));
    [pool release];
    return retVal;
}
