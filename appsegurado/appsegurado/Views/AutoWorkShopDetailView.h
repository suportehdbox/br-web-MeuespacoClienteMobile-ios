//
//  AutoWorkShopDetailView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 24/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoWorkShopDetailView : UIView
-(void) loadView:(BOOL) isIndication;
-(void) addBoxTitle:(NSString *) title;
-(void) setName:(NSString*) name;
-(void) setAddress:(NSString*) address;
-(void) setPhoneNumber:(NSString*) phone;
-(void) setDistance:(NSString*) distance;
-(void) setOfficeHours:(NSString*) hoursPhrase;
-(void) setUnavailable;


@property (nonatomic,strong) NSString *latitude;
@property (nonatomic,strong) NSString *longitude;


@end
