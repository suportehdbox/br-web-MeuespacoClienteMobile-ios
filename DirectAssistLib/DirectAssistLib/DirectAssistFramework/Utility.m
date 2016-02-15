//
//  Utility.m
//  DirectAssistHyundai
//
//  Created by Danilo Salvador on 10/30/12.
//  Copyright (c) 2012 Mondial Assistance. All rights reserved.
//

#import "Utility.h"

@implementation Utility
/*
+(void)initCustomNavigationBar:(UINavigationBar *)customNavigationBar
{
    UIImage *image = [UIImage imageNamed:@"bar-header.png"];
    [customNavigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
  
}
*/

+(UIBarButtonItem *) addCustomButtonNavigationBar:(id)target action:(SEL)action imageName:(NSString *)imageName title:(NSString *)title
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIImage *image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
    //    UIImage *image = [UIImage imageNamed:imageName];
    
    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    face.bounds = CGRectMake(0, 0, 70, 60);
    [face setImageEdgeInsets:UIEdgeInsetsMake(15, 0, 0, 0)];
    [face setImage:image forState:UIControlStateNormal];
    [face setTitle:title forState:UIControlStateNormal];
    face.titleEdgeInsets = UIEdgeInsetsMake(15, -image.size.width, 0, 0);
    [face addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    UIFont *font = [UIFont boldSystemFontOfSize:12];
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
    [face.titleLabel setFont:font];
    UIBarButtonItem *Button = [[UIBarButtonItem alloc] initWithCustomView:face];
    
    return Button;
}

+(UIBarButtonItem *) addCustomButtonNavigationBar:(id)target action:(SEL)action imageName:(NSString *)imageName
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIImage *image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
//    UIImage *image = [UIImage imageNamed:imageName];
    
    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    face.bounds = CGRectMake(0, 0, 70, 60);
    [face setImageEdgeInsets:UIEdgeInsetsMake(15, 0, 0, 0)];
    [face setImage:image forState:UIControlStateNormal];
    [face addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *Button = [[UIBarButtonItem alloc] initWithCustomView:face];
    
    return Button;
}
+(void) addBackButtonNavigationBar:(id)target action:(SEL)action
{
    // Botão Voltar - Seta
    UIImage *image = [UIImage imageNamed:@"seta.png"];
    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    face.bounds = CGRectMake(0, 0, 30, 30);
    [face setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [face setImage:image forState:UIControlStateNormal];
    [face addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:face] ;
    ((UIViewController*)target).navigationItem.leftBarButtonItem = closeButton;
}

+(UIImage *)imageWithImage:(NSString*)imageName scale:(NSInteger)scale
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIImage *scaledImage = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
//    UIImage *originalImage = [UIImage imageNamed:imageName];
    scaledImage = [UIImage imageWithCGImage:[scaledImage CGImage] scale:scale orientation:UIImageOrientationUp];
    
    return scaledImage;
}

+(BOOL)hasInternet {
    
	//NetworkStatus netStatus = [hostReachability currentReachabilityStatus];
	return YES;
	//return (netStatus == ReachableViaWWAN || netStatus == ReachableViaWiFi);
}

+(void)showNoInternetWarning {
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:DALocalizedString(@"NoInternetWarning", nil)
												   delegate:nil
										  cancelButtonTitle:nil
										  otherButtonTitles:DALocalizedString(@"OK", nil), nil];
	[alert show];
}

@end
