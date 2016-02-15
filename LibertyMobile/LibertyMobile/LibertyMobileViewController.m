//
//  LibertyMobileViewController.m
//  LibertyMobile
//
//  Created by EvandroO on 19/09/13.
//
//

#import "LibertyMobileViewController.h"
#import "Util.h"

@implementation LibertyMobileViewController

@synthesize camposTableView;
@synthesize activeTextField;

@synthesize keyboardNavigationBarView, keyboardNavigationBar, keyboardPreviousButton, keyboardNextButton;

#define MAX_FIELD_TAG                   13

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    //Register for keyboard notification
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Keyboard Observation methods

-(void) keyboardWasShown:(NSNotification*) notification
{
    // antes de alterar a table verifica se já não alterou:
    if(!_haskeyboard) {
        _initialTVHeight = camposTableView.frame.size.height;
        
        CGRect initialFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect convertedFrame = [self.view convertRect:initialFrame fromView:nil];
        CGRect tvFrame = camposTableView.frame;
        tvFrame.size.height = convertedFrame.origin.y;
        camposTableView.frame = tvFrame;
        _haskeyboard = YES;
    } else {
        _haskeyboard = YES;
    }
}

-(void) keyboardWillBeHidden:(NSNotification*) notification
{
    if(_haskeyboard) {
        CGRect tvFrame = camposTableView.frame;
        tvFrame.size.height = _initialTVHeight;
        [UIView beginAnimations:@"TableViewDown" context:NULL];
        [UIView setAnimationDuration:0.3f];
        camposTableView.frame = tvFrame;
        [UIView commitAnimations];
        _haskeyboard = NO;
    } else {
        _haskeyboard = NO;
    }
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return YES;
}

#pragma mark - IBAction do teclado

- (IBAction) keyboardNavigationBarPreviousPressed:(id)sender
{
    if (! [Util changeResponder:-1 forTextField:activeTextField withTagRange:NSMakeRange(0, MAX_FIELD_TAG)]) {
        [Util makeTableCellControlVisible:activeTextField];
    }
}

- (IBAction) keyboardNavigationBarNextPressed:(id)sender
{
    if (! [Util changeResponder:+1 forTextField:activeTextField withTagRange:NSMakeRange(0, MAX_FIELD_TAG)]) {
        [Util makeTableCellControlVisible:activeTextField];
    }
}


- (IBAction) keyboardNavigationBarDonePressed:(id)sender
{
    if ([activeTextField respondsToSelector:@selector(resignFirstResponder)]) {
        [activeTextField resignFirstResponder];
    }
}


#pragma mark - Custom Keyboard Navigation Bar Methods

- (UIView *)inputAccessoryView
{
    if (!self.keyboardNavigationBarView) {
        [[NSBundle mainBundle] loadNibNamed:@"KeyboardNavigationBar" owner:self options:nil];
        [self.keyboardNavigationBar setTranslucent:YES];
    }
    
    return self.keyboardNavigationBarView;
}


#pragma mark - Text Field Delegate Methods

- (void) textFieldDidBeginEditing:(UITextField *)theTextField
{
    UITextField *myTextField = [theTextField retain];
    self.activeTextField = myTextField;
    [myTextField release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    //make the keyboard go away
	[theTextField resignFirstResponder];
	return YES;
}

@end
