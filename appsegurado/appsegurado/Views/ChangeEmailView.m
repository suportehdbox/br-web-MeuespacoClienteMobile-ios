//
//  ChangeEmailView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 11/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ChangeEmailView.h"

@interface ChangeEmailView(){

    UITextField *currentTextField;
}

@end
@implementation ChangeEmailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void) loadView{
    
    [_widthBox setConstant:CGRectGetMaxX(self.frame)- 16];
    [_heightScrollView setConstant:25];
    
    [self setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    [BaseView addDropShadow:_viewFields];
    
    
    [self stopLoading];
    
    [_txtEmail setPlaceholder:NSLocalizedString(@"NovoEmail", @"")];
    [_txtEmail setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtEmail setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtEmail setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtEmail setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtEmail setKeyboardType:UIKeyboardTypeEmailAddress];
    [_txtEmail setDelegate:self];
    
    
    [_txtRepeatEmail setPlaceholder:NSLocalizedString(@"ConfirmarNovoEmail", @"")];
    [_txtRepeatEmail setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtRepeatEmail setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtRepeatEmail setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtRepeatEmail setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtRepeatEmail setKeyboardType:UIKeyboardTypeEmailAddress];
    [_txtRepeatEmail setSecureTextEntry:NO];
    [_txtRepeatEmail setDelegate:self];
    
    
    [_lblTitle setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblTitle setTextColor:[BaseView getColor:@"AzulEscuro"]];
    [_lblTitle setText:NSLocalizedString(@"TrocarEmail", @"")];
    
    
    [_btSend setTitle:NSLocalizedString(@"BtEnviarEmail", @"") forState:UIControlStateNormal];
    [_btSend setBorderColor:[BaseView getColor:@"CorBotoes"]];
    if(![Config isAliroProject]){
        [_btSend setBorderColor:[BaseView getColor:@"Amarelo"]];
        [_btSend setBackgroundColor:[BaseView getColor:@"Amarelo"]];
    }
    [_btSend setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self addGestureRecognizer:tap];
    [self registerForKeyboardNotifications];
    
    
    [_lblSuccess setFont:[BaseView getDefatulFont:XLarge bold:NO]];
    [_lblSuccess setTextColor:[BaseView getColor:@"Verde"]];
    [_lblSuccess setText:NSLocalizedString(@"EmailAlteradoLogado", @"")];
    
    [_btSucess setTitle:NSLocalizedString(@"BtPopUpSucesso", @"") forState:UIControlStateNormal];
    if(![Config isAliroProject]){
        [_btSucess setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
        [_btSucess setBackgroundColor:[BaseView getColor:@"Verde"]];
        [_btSucess setBorderColor:[BaseView getColor:@"Verde"]];
        [_btSucess customizeBorderColor:[BaseView getColor:@"Verde"] borderWidth:1 borderRadius:7];
    }
    [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(loadInfo) userInfo:nil repeats:NO];
    
}
-(void) loadInfo{
    [_userInfoView loadView];
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if(textField == _txtEmail){
        [_txtRepeatEmail becomeFirstResponder];
    }else{
        [_btSend sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    return true;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    currentTextField =textField;
}

- (void)registerForKeyboardNotifications
{
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

-(void) unRegisterKeyboard{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    float posY = self.frame.size.height - kbSize.height - 15;
    
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    //    CGRect aRect = self.frame;
    //    aRect.size.height -= kbSize.height - _scrollView.contentOffset.y;
    if(CGRectGetMaxY(currentTextField.frame) > posY){
        //    if (!CGRectContainsPoint(aRect, currentTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, currentTextField.frame.origin.y-kbSize.height);
        if(scrollPoint.y > 0 ){
            [_scrollView setContentOffset:scrollPoint animated:YES];
        }
    }
    
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}
-(void) scrollToTop{
    [_scrollView setContentOffset:CGPointZero animated:YES];
}
-(void) hideKeyboard{
    [self tapTexts];
}

-(void) tapTexts{
    [currentTextField resignFirstResponder];
}

-(void)tapView:(UITapGestureRecognizer *)recognizer{
    if(currentTextField.isEditing){
        [self tapTexts];
    }
}

-(void) unloadView{
    [self unRegisterKeyboard];
    [_txtEmail unloadView];
    [_txtRepeatEmail unloadView];
    
    
}


-(void) showLoading{
    [self hideKeyboard];
    [_activityIndicator setHidden:NO];
    [_activityIndicator startAnimating];
    [_viewFields setHidden:YES];
    [_btSend setHidden:YES];
    [self scrollToTop];
}
-(void) stopLoading{
    [_activityIndicator setHidden:YES];
    [_activityIndicator stopAnimating];
    [_viewFields setHidden:NO];
    [_btSend setHidden:NO];
}


-(void) showSuccessMessage{
    [_popupSucess setHidden:NO];
}
-(NSString*) getEmail{
    return [_txtEmail text];
}
-(NSString*) getRepeatEmail{
    return [_txtRepeatEmail text];
}
-(void) showEmailError:(NSString*)message{
    [_txtEmail showErrorField:message color:[BaseView getColor:@"Vermelho"]];
}
-(void) showRepeatEmailError:(NSString*)message{
    [_txtRepeatEmail showErrorField:message color:[BaseView getColor:@"Vermelho"]];
}

@end
