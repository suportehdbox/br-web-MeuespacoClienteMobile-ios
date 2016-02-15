//
//  DAProcessingViewController.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 13/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAStatusViewController : UIViewController {
	IBOutlet UILabel *statusText;
	NSString *textToDisplay;
}

- (id)initWithStatus:(NSString *)status;
- (void)showInViewController:(UIViewController *)viewController;
- (void)dismiss;
@end
