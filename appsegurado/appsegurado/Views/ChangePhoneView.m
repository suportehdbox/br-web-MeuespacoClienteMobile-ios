//
//  ChangePhone
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 10/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ChangePhoneview.h"
@interface ChangePhoneView(){
    UITextField * currentTextField;
}
@end
@implementation ChangePhoneView

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
    
    [_txtPhone setPlaceholder:NSLocalizedString(@"EnterPhone", @"")];
    [_txtPhone setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtPhone setTextColor:[BaseView getColor:@"CinzaEscuro"]];    
    [_txtPhone setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtPhone setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtPhone setKeyboardType:UIKeyboardTypePhonePad];
    [_txtPhone setDelegate:self];
    
//
//    NSMutableAttributedString *instructionsPWD = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"InstrucoesPassword", @"")];
//
//    [instructionsPWD addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"CinzaEscuro"] range:NSRangeFromString(NSLocalizedString(@"InstrucoesPassword", @""))];
//    [instructionsPWD addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:NO] range:NSRangeFromString(NSLocalizedString(@"InstrucoesPassword", @""))];
    
//    [instructionsPWD addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:YES] range:NSMakeRange(0, 8)];
    
//    [_lblInstructionsPassword setAttributedText:instructionsPWD];
//    [_lblInstructionsPassword setAdjustsFontSizeToFitWidth:YES];
//    [_lblInstructionsPassword setMinimumScaleFactor:0.3];
//    [_lblInstructionsPassword setNumberOfLines:3];
//

    [_txtCellPhone setPlaceholder:NSLocalizedString(@"Cellphone", @"")];
    [_txtCellPhone setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtCellPhone setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtCellPhone setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtCellPhone setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtCellPhone setKeyboardType:UIKeyboardTypePhonePad];
    [_txtCellPhone setSecureTextEntry:NO];
    [_txtCellPhone setDelegate:self];
    
    [_txtExtension setPlaceholder:NSLocalizedString(@"Extension", @"")];
    [_txtExtension setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtExtension setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtExtension setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtExtension setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtExtension setKeyboardType:UIKeyboardTypePhonePad];
    [_txtExtension setSecureTextEntry:NO];
    [_txtExtension setDelegate:self];
    


    
    [_lblTitle setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblTitle setTextColor:[BaseView getColor:@"AzulEscuro"]];
    [_lblTitle setText:NSLocalizedString(@"UpdatePhone", @"")];
    
    
    [_btSend setTitle:NSLocalizedString(@"Enviar", @"") forState:UIControlStateNormal];
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
     [_lblSuccess setText:NSLocalizedString(@"PhoneAlterado", @"")];
    
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
    if(textField == _txtPhone){
        [_txtExtension becomeFirstResponder];
    }else if(textField == _txtExtension){
        [_txtCellPhone becomeFirstResponder];
    }else{
        [_btSend sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    return true;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    currentTextField =textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(currentTextField == _txtExtension){
        if(currentTextField.text.length < 4 || range.length > 0 )
            return YES;
        else
            return NO;
    }
    
    int length = (int) [[self formatNumber:[textField text]] length];
    
    int max = (currentTextField == _txtCellPhone) ? 11 : 10;
    
    if (length == max) {
        if(range.length == 0) {
            return NO;
        }
    }
    
    if (length == 2) {
        NSString *num = [self formatNumber:[textField text]];
        textField.text = [NSString stringWithFormat:@"(%@) ",num];
        if (range.length > 0) {
            [textField setText:[NSString stringWithFormat:@"%@",[num substringToIndex:2]]];
        }
    }
    else if (length == 3 && max == 11) {
        NSString *num = [self formatNumber:[textField text]];
        [textField setText:[NSString stringWithFormat:@"(%@) %@ ",[num  substringToIndex:2],[num substringFromIndex:2]]];
        if (range.length > 0) {
            [textField setText:[NSString stringWithFormat:@"(%@) %@",[num substringToIndex:2],[num substringFromIndex:2]]];
        }
    }
    else if (length == 6 && max == 10) {
        NSString *num = [self formatNumber:[textField text]];
        [textField setText:[NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:2],[num substringFromIndex:2]]];
        if (range.length > 0) {
            [textField setText:[NSString stringWithFormat:@"(%@) %@",[num substringToIndex:2],[num substringFromIndex:2]]];
        }
        
     
    }
    else if (length == 7 && max == 11) {
        NSString *num = [self formatNumber:[textField text]];
        
        NSLog(@"%C", [num characterAtIndex:2]);
        [textField setText:[NSString stringWithFormat:@"(%@) %C %@-",[num  substringToIndex:2], [num characterAtIndex:2], [num substringFromIndex:3]]];
        if (range.length > 0) {
            [textField setText:[NSString stringWithFormat:@"(%@) %C %@",[num substringToIndex:2],[num characterAtIndex:2],[num substringFromIndex:3]]];
        }

        
    }
    
    return YES;
}

- (NSString*)formatNumber:(NSString*)mobileNumber {
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
//    int length = (int) [mobileNumber length];
//
//    if (length > 10) {
//        mobileNumber = [mobileNumber substringFromIndex: length-10];
//    }
    
    return mobileNumber;
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
    [_txtPhone unloadView];
    [_txtExtension unloadView];
    [_txtCellPhone unloadView];
    
}


-(void) showLoading{
    [self hideKeyboard];
    [_activityIndicator setHidden:NO];
    [_activityIndicator startAnimating];
    [_viewFields setHidden:YES];
    [_viewPassword setHidden:YES];
    [_btSend setHidden:YES];
    [self scrollToTop];
}
-(void) stopLoading{
    [_activityIndicator setHidden:YES];
    [_activityIndicator stopAnimating];
    [_viewFields setHidden:NO];
    [_viewPassword setHidden:NO];
    [_btSend setHidden:NO];
}


-(void) showSuccessMessage{
    [_popupSucess setHidden:NO];
}


-(NSString*) getPhone{
    return [self formatNumber:_txtPhone.text];
}

-(NSString*) getExtension{
    return [self formatNumber:_txtExtension.text];
}
-(NSString*) getCellPhone{
    return [self formatNumber:_txtCellPhone.text];
}

-(void) setPhone:(NSString*)value{
    [_txtPhone setText:value];
}

-(void) setExtension:(NSString*)value{
    [_txtExtension setText:value];
}

-(void) setCellPhone:(NSString*)value{
   [_txtCellPhone setText:value];
}

-(void) showCellPhoneError:(NSString*)message{
    [_txtCellPhone showErrorField:message color:[BaseView getColor:@"Vermelho"]];

}
-(void) showExtensionError:(NSString*)message{
    [_txtExtension showErrorField:message color:[BaseView getColor:@"Vermelho"]];

}
-(void) showPhoneError:(NSString*)message{
    [_txtPhone showErrorField:message color:[BaseView getColor:@"Vermelho"]];

}

@end
