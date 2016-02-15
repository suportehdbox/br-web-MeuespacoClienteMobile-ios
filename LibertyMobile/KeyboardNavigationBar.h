//
//  KeyboardNavigationBar.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardNavigationBar : UIViewController {
    
	UIView *keyboardNavigationBarView;
	UIToolbar *keyboardNavigationBar;
	UIBarButtonItem *keyboardPreviousButton;
	UIBarButtonItem *keyboardNextButton;
}

@property (nonatomic, retain) IBOutlet UIView *keyboardNavigationBarView;
@property (nonatomic, retain) IBOutlet UIToolbar *keyboardNavigationBar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *keyboardPreviousButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *keyboardNextButton;

- (IBAction)keyboardNavigationBarPreviousPressed:(id)sender;
- (IBAction)keyboardNavigationBarNextPressed:(id)sender;
- (IBAction)keyboardNavigationBarDonePressed:(id)sender;

@end
