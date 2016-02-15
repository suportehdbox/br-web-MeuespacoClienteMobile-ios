//
//  GoogleAnalyticsManager.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/29/13.
//
//

#import "GoogleAnalyticsManager.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation GoogleAnalyticsManager

//static id<GAITracker> tracker;

+ (void) initialize
{
    /*
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];
    tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-3257253-38"];
     */
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-3257253-38"];
    
    // Enable IDFA collection.
    [[[GAI sharedInstance] defaultTracker] setAllowIDFACollection:YES];
}

+ (void)send:(NSString *)screen
{
    
    /*
    [tracker set:kGAIScreenName value:screen];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
     */
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:screen];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

@end
