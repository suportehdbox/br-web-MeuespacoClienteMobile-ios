//
//  SinistroNovoEnviarViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Event.h"
#import "User.h"

typedef enum {
    LMSendInfoUIAlertViewTagCall = 0,
	LMSendInfoUIAlertViewTagSendResult,
} LMSendInfoUIAlertTag;

@protocol SinistroNovoEnviarViewControllerDelegate;

@interface SinistroNovoEnviarViewController : UIViewController <MFMailComposeViewControllerDelegate, UIAlertViewDelegate, UIAlertViewDelegate>
{
	
	UIAlertView *uiAlertView;
	
@private
	NSDictionary *contactsDictionary;
}

- (void)displayComposerSheet ;
- (void)composeEmail;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)loadUser;

- (IBAction)sendInfo:(id)sender;
- (IBAction)placeCall:(id) sender;
- (IBAction)btnSinistroNovo:(id)sender;
- (void)applicationEnteredBackground;

- (id)initWithEvent:(Event *)theEvent andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) User *user;

@property (nonatomic, assign) id<SinistroNovoEnviarViewControllerDelegate> delegate;

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIButton *callButton;
@property (nonatomic, retain) IBOutlet UIButton *continueButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIAlertView *uiAlertView;

@property (nonatomic, retain) IBOutlet UIWebView *webInfo;


@end

@protocol SinistroNovoEnviarViewControllerDelegate <NSObject>

- (void)enviarSinistroViewController:(SinistroNovoEnviarViewController *)controller didDismissView:(BOOL)viewDismissed;

@end
