//
//  AutoWorkShopView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 31/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
#import <MapKit/MapKit.h>
#import "CustomButton.h"
#import "SearchPopUpView.h"

@interface AutoWorkShopView : BaseView
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet CustomButton *btOtherPlace;
@property (strong, nonatomic) IBOutlet CustomButton *btOrdering;
@property (strong, nonatomic) IBOutlet SearchPopUpView *popupView;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet SearchPopUpView *popupGPSOff;

@property (strong, nonatomic) IBOutlet UIView *popupInfo;
@property (strong, nonatomic) IBOutlet CustomButton *btOkPopUpInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblInfo;

@property (strong, nonatomic) IBOutlet UILabel *lblDescription;



-(void) loadView;
-(void) unloadView;
-(void) hideKeyboard;
-(void) showPopUpSearch;
-(void) hidePopUpSearch;
-(void) showMessage:(NSString *)message;
-(UIAlertController *) showLocationNotFound;
-(UIAlertController *) showErrorSearch;
-(UIAlertController *) showNetworkError;
-(void) showAutoWorksMap:(NSMutableArray*) autoWorks;
-(UIAlertController *) showErrorApp:(NSString*) appName;
-(void) centerMapToUser;

-(void) showPopUpInfo;
-(void) hidePopUpInfo;
-(float) rowHeight;
-(void) reloadTable;
-(void) setNearest;
-(void) setScore;

@end
