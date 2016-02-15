//
//  DAProgressHUD.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/16/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAProgressHUD.h"


@implementation DAProgressHUD

- (id)initWithLabel:(NSString *)text {
    if (self = [super init]) {

        alert = [[UIAlertView alloc] initWithTitle:text
                                           message:nil
                                          delegate:nil
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil, nil];
//        progressMessage = [[UILabel alloc] initWithFrame:CGRectZero];
//        progressMessage.textColor = [UIColor whiteColor];
//        progressMessage.backgroundColor = [UIColor clearColor];
//        progressMessage.text = text;
//        [self addSubview:progressMessage];
//		
//        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        [activityIndicator startAnimating];
//        [self addSubview:activityIndicator];
//		
//        self.backgroundImage = [UIImage imageNamed:@"DAProgressHUDBackground.png"];
    }
	
    return self;
}
		
//- (void)drawRect:(CGRect)rect {
//    CGSize backGroundImageSize = self.backgroundImage.size;
//    [backgroundImage drawInRect:CGRectMake(0, 0, backGroundImageSize.width, backGroundImageSize.height) blendMode:kCGBlendModeNormal alpha:0.8];
//}

//- (void)layoutSubviews {
//    [progressMessage sizeToFit];
//	
//    CGRect textRect = progressMessage.frame;
//    textRect.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(textRect)) / 2;
//    textRect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(textRect)) / 2;
//    textRect.origin.y += 30.0;
//	
//    progressMessage.frame = textRect;
//	
//    CGRect activityRect = activityIndicator.frame;
//    activityRect.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(activityRect)) / 2;
//    activityRect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(activityRect)) / 2;
//    activityRect.origin.y -= 10.0;
//	
//    activityIndicator.frame = activityRect;
//    [self bringSubviewToFront:activityIndicator];
//}

- (void)show {
    [alert show];
//    CGSize backGroundImageSize = self.backgroundImage.size;
//    self.bounds = CGRectMake(0, 0, backGroundImageSize.width, backGroundImageSize.height);
}

- (void)showWithNetworkActivityStatus {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[alert show];
}

- (void)dismiss {
    [alert dismissWithClickedButtonIndex:0 animated:NO];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [alert dismissWithClickedButtonIndex:0 animated:NO];
}


@end
