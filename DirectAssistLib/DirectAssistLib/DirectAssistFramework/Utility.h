//
//  Utility.h
//  DirectAssistHyundai
//
//  Created by Danilo Salvador on 10/30/12.
//  Copyright (c) 2012 Mondial Assistance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

//+(void)initCustomNavigationBar:(UINavigationBar *)customNavigationBar;
+(UIBarButtonItem *) addCustomButtonNavigationBar:(id)target action:(SEL)action imageName:(NSString *)imageName title:(NSString *)title;
+(UIBarButtonItem *) addCustomButtonNavigationBar:(id)target action:(SEL)action imageName:(NSString *)imageName;
+(void) addBackButtonNavigationBar:(id)target action:(SEL)action;
+(UIImage *)imageWithImage:(NSString*)imageName scale:(NSInteger)scale;
+(BOOL)hasInternet;
+(void)showNoInternetWarning;

@end
