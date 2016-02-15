//
//  ServiceOnMapViewController.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 18/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAServiceDispatchFinder.h"
#import "DAServiceMonitoringViewController.h"

@class DAAutomotiveFile, DAServiceDispatch;

@interface DAServiceOnMapViewController : DAServiceMonitoringViewController <DAServiceDispatchFinderDelegate, UIAlertViewDelegate, UIWebViewDelegate> {

	DAAutomotiveFile *selectedFile;
	DAServiceDispatch *selectedDispatch;
}

@property (nonatomic, strong) DAAutomotiveFile *selectedFile;
@property (nonatomic, strong) DAServiceDispatch *selectedDispatch;

@end
