//
//  HomeOffView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 24/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
#import <MapKit/MapKit.h>
#import "AutoWorkShopDetailView.h"
#import "CircleButton.h"

@interface HomeOffView : BaseView
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet AutoWorkShopDetailView *AutoWorkShopView;
@property (strong, nonatomic) IBOutlet CircleButton *btAccident;
@property (strong, nonatomic) IBOutlet CircleButton *btAutoWorkShops;
@property (strong, nonatomic) IBOutlet CircleButton *btClub;
@property (strong, nonatomic) IBOutlet CustomButton *btLogin;
@property (strong, nonatomic) IBOutlet CustomButton *btRegister;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIImageView *imgLogo;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mapViewWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *spaceBtsToLogin;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *spaceBotToBts;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *posXButtonAssist;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *posXButtonAutoWork;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *posXButtonClub;

-(void) loadView;
-(void) showMessage:(NSString *)message;
-(void) hideMessage;
-(void) showAutoWorksMap:(NSMutableArray*) autoWorks;
-(UIAlertController *) showLocationNotFound;
@end
