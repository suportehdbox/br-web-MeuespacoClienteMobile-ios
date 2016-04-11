//
//  ClubeLibertyViewController.h
//  LibertyMobile
//
//  Created by evandroo on 8/04/15.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ClubeLibertyViewController : UIViewController <UIWebViewDelegate>{
    UIWebView *webInfo;
    UIActivityIndicatorView *indicator;
}

@property (nonatomic, retain) IBOutlet UIWebView *webInfo;
@property (nonatomic, retain) NSString *sessionId;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView  *indicator;

@end
