//
//  SendEvent.m
//  LibertyMutual
//
//  Created by Kevin Ingvalson on 8/31/10.
//  Copyright 2010 Liberty Mutual. All rights reserved.
//

#import "SendEvent.h"

@implementation SendEvent

@synthesize event, user, photoOrder;

- (NSString *) applicationSignature {

	UIDevice *thisPhone = [UIDevice currentDevice];

	NSString *appVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"build_version"];
	return [NSString stringWithFormat:@"Enviado de %@ (%@), Versão da Aplicação: %@", [thisPhone platformString], [thisPhone systemVersion], appVersion];
}

@end
