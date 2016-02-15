//
//  LibertyMobileViewController.h
//  LibertyMobile
//
//  Created by EvandroO on 19/09/13.
//
//

#import <Foundation/Foundation.h>

@interface LibertyMobileViewController : UIViewController <UITextFieldDelegate>
{
    UITableView     *camposTableView;
    UIControl       *activeTextField;
    
    UIView          *keyboardNavigationBarView;
    UIToolbar       *keyboardNavigationBar;
    UIBarButtonItem *keyboardPreviousButton;
    UIBarButtonItem *keyboardNextButton;
    
    CGFloat         _initialTVHeight;
    BOOL            _haskeyboard;
}

@property (nonatomic, retain) IBOutlet UITableView  *camposTableView;
@property (nonatomic, retain) UIControl              *activeTextField;

@property (readonly, retain) UIView *keyboardNavigationBarView;
@property (nonatomic, retain) IBOutlet UIToolbar *keyboardNavigationBar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *keyboardPreviousButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *keyboardNextButton;

// Actions Keyboard Navigation
- (IBAction) keyboardNavigationBarPreviousPressed:(id)sender;
- (IBAction) keyboardNavigationBarNextPressed:(id)sender;
- (IBAction) keyboardNavigationBarDonePressed:(id)sender;

@end
