//
//  FlutterController.m
//  appsegurado
//
//  Created by Luiz Othavio H Zenha on 24/03/21.
//  Copyright © 2021 Liberty Seguros. All rights reserved.
//

#import "FlutterController.h"
#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>
#import "BaseModel.h"

@interface FlutterController (){
    FlutterEngine *flutterEngine;
}

@end
@implementation FlutterController

- (id)init
{
    self = [super init];
    if (self) {
        [self prepare];
    }
    return self;
}

-(void) prepare{
    if (flutterEngine == nil){
        [self startEngine];
        [self createChannels];
    }
}

- (void) startEngine {
    flutterEngine = [[FlutterEngine alloc] initWithName:@"default2"];
    // Runs the default Dart entrypoint with a default Flutter route.
    [flutterEngine run];
    [GeneratedPluginRegistrant registerWithRegistry:flutterEngine];
}

- (void) createChannels {
    
    
#pragma mark - Channel Infos
    FlutterMethodChannel* batteryChannel = [FlutterMethodChannel
                                             methodChannelWithName:@"br.com.libertyseguros.flutter/channel"
                                             binaryMessenger:flutterEngine.binaryMessenger];

     [batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
       // Note: this method is invoked on the UI thread.
         if ([@"getInfos" isEqualToString:call.method]) {
             [self returnInfos:result];
           } else {
             result(FlutterMethodNotImplemented);
           }
     }];
}



-(void) returnInfos: (FlutterResult ) result {
//  let device = UIDevice.current
//  device.isBatteryMonitoringEnabled = true
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[Config isAliroProject] ? @"Aliro" : @"Liberty" forKey:@"brandMarketing"];
    [dict setValue: [[NSBundle mainBundle] bundleIdentifier] forKey:@"package"];
    if(PRODUCTION){
        [dict setValue:@"true" forKey:@"prod"];
    }else{
        [dict setValue:@"false" forKey:@"prod"];
    }
    
    result([[NSDictionary alloc] initWithDictionary:dict]);
}



-(FlutterViewController*) getDialogUpdateViewController {
    [self prepare];
    FlutterViewController *flutterViewController =
    [[FlutterViewController alloc] initWithEngine:flutterEngine nibName:nil bundle:nil];
    //[flutterViewController pushRoute:@"dialog-update"];
    return flutterViewController;
}
@end
