//
//  LocateMeViewController.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 12/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DAReverseGeocoder.h"

@class DALocateMeViewController, DAStatusViewController;

@protocol DALocateMeViewControllerDelegate <NSObject>
@optional
- (void)locateMeViewController:(DALocateMeViewController *)viewController didFindAddress:(DAAddress *)address;
- (void)locateMeViewController:(DALocateMeViewController *)viewController didAcceptAddress:(DAAddress *)address;
@end

@interface DALocateMeViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, 
			DAReverseGeocoderDelegate, UIWebViewDelegate> {

	IBOutlet UITextField *txtCity;
	IBOutlet UITextField *txtHouseNumber;
	IBOutlet UITextField *txtDistrict;
	IBOutlet UITextField *txtState;
	IBOutlet UITextField *txtStreetName;
	IBOutlet UIWebView *mapPreview;
	IBOutlet UIActivityIndicatorView *loadingMap;
	
	UIToolbar *toolBar;	
				
	id <DALocateMeViewControllerDelegate> __unsafe_unretained delegate;
	DAReverseGeocoder *reverseGeocoder;
	
	DAStatusViewController *statusView;
}

@property (nonatomic, unsafe_unretained) id <DALocateMeViewControllerDelegate> delegate;

- (void)btnDone_Clicked:(id)sender;
- (void)btnEdit_Clicked:(id)sender;

- (void)loadPreviewMap;
- (UIToolbar *)createLocateMeToolbar:(CGRect)parentBounds;

@end

