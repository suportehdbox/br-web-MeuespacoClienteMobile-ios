//
//  AppDelegate.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 22/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseView.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import <RMessage/RMessage.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "DetailNotificationViewController.h"
#import "ActivationViewController.h"


@interface AppDelegate (){
    
    UserBeans *currentUser;
    DetailNotificationViewController *detail;
    ActivationViewController *activation;
//    NSString * gcm;
    
}
    @property(nonatomic, strong) void (^registrationHandler)(NSString *registrationToken, NSError *error);
    @property(nonatomic, assign) BOOL connectedToGCM;
    @property(nonatomic, strong) NSString* registrationToken;
    @property(nonatomic, assign) BOOL subscribedToTopic;

@end

NSString *const SubscriptionTopic = @"global";

@implementation AppDelegate
@synthesize openingExternalProgram,gotoLoginView, shouldShowRMessage, currentSr, mainPolicyNumber, loggedWithFacebook, has_auto_policy, current_controller;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    

#pragma mark Analytics
    [FIRApp configure];
    //Configuring FIR Messaging | Google Messaging
    [FIRMessaging messaging].delegate = self;
    [FIRAnalytics setAnalyticsCollectionEnabled:YES];
    [Fabric with:@[[Crashlytics class]]];

    [[FIRInstanceID instanceID] instanceIDWithHandler:^(FIRInstanceIDResult * _Nullable result,
                                                        NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error fetching remote instance ID: %@", error);
        } else {
            _registrationToken = result.token;
        }
    }];
    
    // Call the Datami API at the beginning of didFinishLaunchingWithOptions, before other initializations.
    // IMPORTANT: If Datami API is not the first API called in the application then any network
    // connection made before Datami SDK initialization will be non-sponsored and will be
    // charged to the user.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedStateChage:)
                                                 name:SDSTATE_CHANGE_NOTIF object:nil];
    
    
    if(PRODUCTION){
        [SmiSdk initSponsoredData:@"e8bb99bf7d16c1441333d125433fecc8d6d4801e" userId: [self getEmailUser] showSDMessage:NO];
    }
    
    
    
#pragma mark Customization
   CGRect windowRect = [[[[UIApplication sharedApplication] delegate] window] frame];
    
    if(windowRect.size.height <= 568){
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[BaseView getColor:@"Branco"], NSForegroundColorAttributeName, [BaseView getDefatulFont:Small bold:YES], NSFontAttributeName, nil]];
    }else{
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[BaseView getColor:@"Branco"], NSForegroundColorAttributeName, [BaseView getDefatulFont:Medium bold:YES], NSFontAttributeName, nil]];
    }

    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:[BaseView getColor:@"NavBarCollor"]];
    
    // Navigation bar buttons appearance
    [[UIBarButtonItem appearance] setTintColor:[BaseView getColor:@"Branco"]];
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[BaseView getColor:@"Branco"], NSForegroundColorAttributeName, [BaseView getDefatulFont:Medium bold:YES], NSFontAttributeName, nil] forState:UIControlStateNormal];
        
    
#pragma mark Facebook SDK
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    self.openingExternalProgram  = NO;
    
    
#pragma mark Notifications
 
    
        dispatch_async(dispatch_get_main_queue(), ^{
            if (@available(iOS 10, *)) {
                // set the UNUserNotificationCenter delegate - the delegate must be set here in didFinishLaunchingWithOptions
                [UNUserNotificationCenter currentNotificationCenter].delegate = self;
                
                [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge
                                                                                    completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                                                                        if (error == nil) {
                                                                                            if (granted == YES) {
                                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                                                                                                });
                                                                                            }
                                                                                        }
                                                                                    }];
            } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 100000
                UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound |
                                                        UIUserNotificationTypeAlert
                                                                                         categories:nil];
                [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        });

    

    return YES;
}

-(BOOL)application:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray * _Nullable))restorationHandler
{
    
    if (userActivity.webpageURL != nil) {
        NSLog(userActivity.webpageURL.absoluteString);
        //handle url and open whatever page you want to open.
        NSURLComponents *componetns = [[NSURLComponents alloc] initWithString:userActivity.webpageURL.absoluteString];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (NSURLQueryItem *item in componetns.queryItems) {
            [params setObject:item.value forKey:item.name];
        }
        
        activation = [[ActivationViewController alloc] initWithDictionary:params];
        
        [current_controller.navigationController pushViewController:activation animated:YES];
        
    }
    return true;
    
}


#pragma mark DataMiSDK
-(void)receivedStateChage:(NSNotification*)notif {
    SmiResult* sr =  notif.object;
    
    NSLog(@"receivedStateChage, sdState: %ld", (long)sr.sdState);
    NSString *sdStateStr = @"";

    if(sr.sdState == SD_AVAILABLE) {
        if(currentSr == nil || currentSr.sdState != sr.sdState){
            if(shouldShowRMessage){
                [RMessage showNotificationWithTitle:NSLocalizedString(@"NavegandoGratis",@"")
                                           subtitle:@""
                                               type:RMessageTypeNormal
                                     customTypeName:nil
                                           callback:nil];
            }
        }
        sdStateStr = @"SD_AVAILABLE";
    } else if(sr.sdState == SD_NOT_AVAILABLE) {
        // do nothing
        sdStateStr = @"SD_NOT_AVAILABLE";
    } else if(sr.sdState == SD_WIFI) {
        // wifi connection
        sdStateStr = @"SD_WIFI";
    }
    
    currentSr = sr;

    
    [FIRAnalytics logEventWithName:@"SD_STATUS_CHANGE" parameters:@{
                                                                    kFIRParameterValue: sdStateStr
                                                                    }];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
  
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    self.openingExternalProgram = YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Connect to the GCM server to receive non-APNS notifications
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    
    if([url.absoluteString containsString:@"google"]){
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:sourceApplication                                     annotation:annotation];
    }

    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
}

//- (BOOL)application:(nonnull UIApplication *)application
//            openURL:(nonnull NSURL *)url
//            options:(nonnull NSDictionary<NSString *, id> *)options {
//    
//    if([url.absoluteString containsString:@"google"]){
//        return [[GIDSignIn sharedInstance] handleURL:url
//                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
//    }
//    
//    [[FBSDKApplicationDelegate sharedInstance] app
//    return NO;
//}
//


#pragma mark - Notifications pt2
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [FIRMessaging messaging].APNSToken = deviceToken;

}


-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error{
    NSLog(@"Error %@",error.description);
    

}

// The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {

    
    if (completionHandler != nil) {
        completionHandler();
    }
}

// This method is REQUIRED for correct functionality of the SDK.
// This method will be called on the delegate when the application receives a silent push

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    UNMutableNotificationContent *theSilentPushContent = [[UNMutableNotificationContent alloc] init];
    theSilentPushContent.userInfo = userInfo;
    UNNotificationRequest *theSilentPushRequest = [UNNotificationRequest requestWithIdentifier:[NSUUID UUID].UUIDString content:theSilentPushContent trigger:nil];
    
    
    
    if([userInfo objectForKey:@"aps"] != nil){
        __block NSString *body = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"];
        
        
        
        if([application applicationState] == UIApplicationStateActive){
            
            [RMessage showNotificationWithTitle:@"Nova notificação"
                                       subtitle:body
                                      iconImage:nil
                                           type:RMessageTypeWarning
                                 customTypeName:nil
                                       duration:5.0f
                                       callback:nil
                                    buttonTitle:@"Abrir" buttonCallback:^{
                                        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                                            [RMessage dismissActiveNotification];
                                            
                                            detail  = [[DetailNotificationViewController alloc] initWithText:body];
                                            [current_controller.navigationController pushViewController:detail animated:YES];
                                            
                                        }];
                                        
                                    } atPosition:RMessagePositionNavBarOverlay canBeDismissedByUser:YES];
            
        }
        
        
        int badge = 1;//[[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] intValue];
        [application setApplicationIconBadgeNumber:[application applicationIconBadgeNumber] + badge];
    }
    
    
    
    completionHandler(UIBackgroundFetchResultNewData);
}



#pragma mark top view controller util

- (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

#pragma mark  - GCM Stuffs
- (void)subscribeToTopic {
    // If the app has a registration token and is connected to GCM, proceed to subscribe to the topic
    [[FIRMessaging messaging] subscribeToTopic:SubscriptionTopic];
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    _registrationToken = fcmToken;
    [self subscribeToTopic];
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
}

-(void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage{
//    [ setApplicationIconBadgeNumber:[application applicationIconBadgeNumber] + 1];
    NSLog(@"Received %@", remoteMessage.description);
}

-(void)messaging:(FIRMessaging *)messaging didRefreshRegistrationToken:(NSString *)fcmToken{
    NSLog(@"FCM registration token: %@", fcmToken);
    _registrationToken = fcmToken;
    [self subscribeToTopic];
}

-(NSString*)getGCM{
    return _registrationToken;
}
-(NSString*)getOldRegistrationToken{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    NSString *token = [defaults objectForKey:@"notificationToken"];
    return (token == nil ? @"" : token);
}

-(void) setTokenNotificacao:(NSString*)token{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    [defaults setObject:token forKey:@"notificationToken"];
    [defaults synchronize];
}

#pragma mark - Control logged User & data persist
-(bool)isUserLogged{
    return (currentUser != nil ? true : false);
}

-(void) setLoggedUser:(UserBeans*)user stayLogged:(BOOL)logged{
    currentUser = user;

    
    [CrashlyticsKit setUserEmail:currentUser.emailCpf];
    


    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    
    [defaults setObject:currentUser.cpfCnpj forKey:@"cpf"];
    [defaults setObject:_registrationToken forKey:@"notificationToken"];
    if(logged){
        [defaults setObject:currentUser.authToken forKey:@"authToken"];
    }
    [defaults synchronize];
    
}

-(void) setEmailUser:(NSString*)email{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    [defaults setObject:email forKey:@"emailUser"];
    [defaults synchronize];

}

-(NSString*) getEmailUser{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    NSString *emailUser = [defaults objectForKey:@"emailUser"];
    return emailUser;
    
}


-(void) logoutUser{
    currentUser = nil;
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    [defaults setObject:@"" forKey:@"authToken"];
    [defaults setObject:@"" forKey:@"cpf"];
    [defaults setBool:FALSE forKey:@"useTouchID"];
    [defaults synchronize];

}

-(NSString*) getAuthToken{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    NSString *token = [defaults objectForKey:@"authToken"];
    return (token == nil ? @"" : token);
}

-(NSString*) getCPF{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    NSString *token = [defaults objectForKey:@"cpf"];
    return (token == nil ? @"" : token);
}

-(UserBeans*) getLoggeduser{
    return currentUser;
}

-(void) setUsesTouchID:(BOOL)use{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    [defaults setBool:use forKey:@"useTouchID"];
    [defaults synchronize];
    
}
-(BOOL) usesTouchIDLogin{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    BOOL use = [defaults boolForKey:@"useTouchID"];
    return use;

}




@end
