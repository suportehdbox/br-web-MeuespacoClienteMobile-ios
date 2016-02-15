//
//  DisplayMap.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 11/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DisplayMap.h"

@implementation DisplayMap

@synthesize coordinate, title, subtitle;

-(void)dealloc {
    [title release];
    [super dealloc];
}

@end
