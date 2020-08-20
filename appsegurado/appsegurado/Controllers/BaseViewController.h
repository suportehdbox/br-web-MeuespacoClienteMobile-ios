//
//  BaseViewController.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 23/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"


@interface BaseViewController : UIViewController
@property (nonatomic,strong) NSString *analyticsTitle;
@property (nonatomic) BOOL showsContactButton;
-(void) addLeftMenu;
-(void) addContactButton;
-(void) showContactViewController;
-(void) sendActionEvent:(NSString*) action label:(NSString*)label;
-(void) openTerms;
-(IBAction)openLGPDSite:(id)sender;
@end
