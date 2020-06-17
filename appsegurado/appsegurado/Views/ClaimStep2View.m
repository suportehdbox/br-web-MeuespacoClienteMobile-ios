//
//  ClaimStep2View.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 15/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ClaimStep2View.h"
@interface ClaimStep2View(){
    UITextField *currentTextField;
    UIButton *selectedDriver;
}

@end

@implementation ClaimStep2View

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) loadView:(UserBeans*) loggedUser{
    [_widthSpace setConstant:self.frame.size.width - 40];
    [_betweenSpace setConstant: 15];
    [self setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    
    
    [self configureButton:_btChoice1 title:NSLocalizedString(@"Sim", @"")];
    [_btChoice1 setTag:0];
    [_btChoice1 setSelected:YES];
    selectedDriver = _btChoice1;
    [self configureButton:_btChoice2 title:NSLocalizedString(@"Nao", @"")];
    [_btChoice2 setTag:1];
    
    [_lblTitle setFont:[BaseView getDefatulFont:Medium bold:YES]];
    [_lblTitle setTextColor:[BaseView getColor:@"AzulEscuro"]];
    [_lblTitle setTextAlignment:NSTextAlignmentLeft];
    [_lblTitle setText:NSLocalizedString(@"ClaimTitle2", @"")];
    
    
    NSMutableAttributedString *title1 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"EstouComDuvidas", @"")];
    
    [title1 addAttribute:NSForegroundColorAttributeName
                   value:[BaseView getColor:@"CinzaEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"EstouComDuvidas", @"") length])];
    
    
    //    [_btDoubts setTintColor:[BaseView getColor:@"AzulEscuro"]];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FaleComLiberty", @"")];
    
    [title addAttribute:NSForegroundColorAttributeName
                  value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"FaleComLiberty", @"") length])];

    [title addAttribute:NSUnderlineColorAttributeName
                  value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"FaleComLiberty", @"") length])];
    [title addAttribute:NSUnderlineStyleAttributeName
                  value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, [NSLocalizedString(@"FaleComLiberty", @"") length])];
    
    [title1 appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "]];
    [title1 appendAttributedString:title];
    
    [_btDoubts setAttributedTitle:title1 forState:UIControlStateNormal];
    [_btDoubts.titleLabel setFont:[BaseView getDefatulFont:Micro bold:NO]];
    
    
    [_lblTitle2 setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblTitle2 setTextColor:[BaseView getColor:@"AzulEscuro"]];
    [_lblTitle2 setTextAlignment:NSTextAlignmentLeft];
    [_lblTitle2 setText:NSLocalizedString(@"Condutor", @"")];
    
    [_btNext setTitle:NSLocalizedString(@"Avancar", @"") forState:UIControlStateNormal];
    [_btNext.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_btNext setBorderRound:7];
    [_btNext setBorderWidth:1];
    [_btNext setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    [_btNext setBorderColor:[BaseView getColor:@"CorBotoes"]];
    [_btNext setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
    
    if(![Config isAliroProject]){
        [_btNext setBorderColor:[BaseView getColor:@"Amarelo"]];
        [_btNext setBackgroundColor:[BaseView getColor:@"Amarelo"]];
    }
    
    [_txtName setPlaceholder:NSLocalizedString(@"Nome", @"")];
    [_txtName setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtName setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtName setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtName setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtName setKeyboardType:UIKeyboardTypeDefault];
    [_txtName setReturnKeyType:UIReturnKeyNext];
    if(loggedUser != nil){
        [_txtName setText:[loggedUser userName]];
    }
    [_txtName setDelegate:self];
    
    [_txtPhone setPlaceholder:NSLocalizedString(@"Telefone", @"")];
    [_txtPhone setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtPhone setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtPhone setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtPhone setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtPhone setKeyboardType:UIKeyboardTypeNumberPad];
    [_txtPhone setReturnKeyType:UIReturnKeyNext];
    _txtPhone.mask = @"(##) # ####-####";
    [_txtPhone setDelegate:self];
    
    [_txtEmail setPlaceholder:NSLocalizedString(@"Email", @"")];
    [_txtEmail setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtEmail setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtEmail setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtEmail setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtEmail setKeyboardType:UIKeyboardTypeEmailAddress];
    [_txtEmail setReturnKeyType:UIReturnKeyDone];
    
    if(loggedUser != nil){
        [_txtEmail setText:[loggedUser emailCpf]];
    }
    [_txtEmail setDelegate:self];

    [BaseView addDropShadow:_bgView];
    [BaseView addDropShadow:_bgView2];

    [_txtDriverName setPlaceholder:NSLocalizedString(@"Nome", @"")];
    [_txtDriverName setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtDriverName setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtDriverName setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtDriverName setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtDriverName setKeyboardType:UIKeyboardTypeDefault];
    [_txtDriverName setReturnKeyType:UIReturnKeyNext];
    [_txtDriverName setDelegate:self];
    
    [_txtDriverPhone setPlaceholder:NSLocalizedString(@"Telefone", @"")];
    [_txtDriverPhone setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtDriverPhone setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtDriverPhone setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtDriverPhone setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtDriverPhone setKeyboardType:UIKeyboardTypeNumberPad];
    [_txtDriverPhone setReturnKeyType:UIReturnKeyNext];
    _txtDriverPhone.mask = @"(##) # ####-####";
    [_txtDriverPhone setDelegate:self];
    
    [_txtDriverBirthdate setPlaceholder:NSLocalizedString(@"DataNascimento", @"")];
    [_txtDriverBirthdate setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtDriverBirthdate setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtDriverBirthdate setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtDriverBirthdate setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtDriverBirthdate setKeyboardType:UIKeyboardTypeNumberPad];
    [_txtDriverBirthdate setReturnKeyType:UIReturnKeyDone];
    _txtDriverBirthdate.mask = @"##/##/####";
    [_txtDriverBirthdate setDelegate:self];

    
    [_datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    [_datePicker setBackgroundColor:[BaseView getColor:@"Branco"]];
    [_datePicker setHidden:YES];
    
    [self updateConstraints];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self addGestureRecognizer:tap];
    [self registerForKeyboardNotifications];

    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if(textField == _txtName){
        [_txtEmail becomeFirstResponder];
    }else if(textField == _txtEmail){
        [_txtPhone becomeFirstResponder];
    }else if(textField == _txtDriverName){
        [_txtDriverBirthdate becomeFirstResponder];
    }else if(textField == _txtDriverBirthdate){
        [_txtDriverPhone becomeFirstResponder];
    }
    
    return true;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if(textField == _txtPhone){
        [_txtPhone didChangeTextViewText];
        return [_txtPhone shouldChangeCharactersInRange:range replacementString:string];
        
    }else if(textField == _txtDriverBirthdate){
        [_txtDriverBirthdate didChangeTextViewText];
        return [_txtDriverBirthdate shouldChangeCharactersInRange:range replacementString:string];
        
    }else if(textField == _txtDriverPhone){
        [_txtDriverPhone didChangeTextViewText];
        return [_txtDriverPhone shouldChangeCharactersInRange:range replacementString:string];
        
    }
    return YES;
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    
    if(textField == _txtDriverBirthdate){
        [self tapView:nil];
        [_datePicker setHidden:NO];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        [_datePicker setMaximumDate:[NSDate date]];
        currentTextField = textField;
        
        CGSize kbSize = _datePicker.frame.size;
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        _scrollView.contentInset = contentInsets;
        _scrollView.scrollIndicatorInsets = contentInsets;
        
        
        [_scrollView setContentOffset:CGPointMake(0, _scrollView.contentSize.height - kbSize.height - 50) animated:YES];
     
        return NO;
    }
    [_datePicker setHidden:YES];
    currentTextField = textField;
    return YES;
    
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
    [_txtEmail registerEvents];
    [_txtName registerEvents];
    [_txtPhone registerEvents];
    [_txtDriverName registerEvents];
    [_txtDriverPhone registerEvents];
    [_txtDriverBirthdate registerEvents];
    
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
    if(currentTextField == _txtDriverBirthdate){
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        _scrollView.contentInset = contentInsets;
        _scrollView.scrollIndicatorInsets = contentInsets;
    }
    
    if(currentTextField.isEditing){
        [self tapTexts];
    }
    
    [_datePicker setHidden:YES];
}

- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if(currentTextField == _txtDriverBirthdate){
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
        [_txtDriverBirthdate setText:strDate];
        [_txtDriverBirthdate didChangeTextViewText];
    }
}

-(void) configureButton:(UIButton*)button title:(NSString*)title{
    [button.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    [button.titleLabel setNumberOfLines:2];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[BaseView getColor:@"AzulEscuro"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(selectDriver:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void) unloadView{
    [self unRegisterKeyboard];
    [_txtEmail unloadView];
    [_txtPhone unloadView];
    [_txtName unloadView];
    [_txtDriverName unloadView];
    [_txtDriverPhone unloadView];
    [_txtDriverBirthdate unloadView];

}

- (IBAction)selectDriver:(id)sender{
    if(selectedDriver != nil){
        [selectedDriver setSelected:NO];
    }
    selectedDriver = (UIButton*) sender;
    [selectedDriver setSelected:YES];
    
    BOOL open = NO;
    if(selectedDriver == _btChoice2){
        [_heightDriver setConstant:240];
        open = YES;
    }else{
        [_heightDriver setConstant:95];
        open = NO;
        [_txtDriverName setHidden:!open];
        [_txtDriverName didChangeTextViewText];
        [_txtDriverPhone setHidden:!open];
        [_txtDriverPhone didChangeTextViewText];
        [_txtDriverBirthdate setHidden:!open];
        [_txtDriverBirthdate didChangeTextViewText];
    }
    [UIView animateWithDuration:0.5
                     animations:^{
                   
                     }];
    
    [UIView animateWithDuration:0.5 animations:^{
              [self layoutIfNeeded]; // Called on parent view
    } completion:^(BOOL finished) {
        [_txtDriverName setHidden:!open];
        [_txtDriverPhone setHidden:!open];
        [_txtDriverBirthdate setHidden:!open];
    }];

}


-(NSString*) getName{
    return [_txtName text];
}

-(NSString*) getEmail{
    return [_txtEmail text];
}

-(NSString*) getPhone{
    return [[[[[_txtPhone text] stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
}
-(int) getDriver{
    if(selectedDriver == nil){
        return -1;
    }
    if(selectedDriver == _btChoice1){
        return 1;
    }
    return 0;
}

-(NSString*) getDriverName{
    return [_txtDriverName text];
}
-(NSString*) getDriverBirthDate{
    NSArray *arrayString = [[[_txtDriverBirthdate.text  componentsSeparatedByString:@"/"] reverseObjectEnumerator] allObjects];
    NSString *dateFinal = [arrayString componentsJoinedByString:@"-"];
    return dateFinal;
}
-(NSString*) getDriverPhone{
    return [_txtDriverPhone text];
}

-(void) showNameError:(NSString*) msg{
    [_txtName showErrorField:msg color:[BaseView getColor:@"Vermelho"]];
}
-(void) showEmailError:(NSString*) msg{
    [_txtEmail showErrorField:msg color:[BaseView getColor:@"Vermelho"]];
}
-(void) showPhoneError:(NSString*) msg{
    [_txtPhone showErrorField:msg color:[BaseView getColor:@"Vermelho"]];
}
-(void) showDriverNameError:(NSString*) msg{
    [_txtDriverName showErrorField:msg color:[BaseView getColor:@"Vermelho"]];
}
-(void) showDriverBirthdateError:(NSString*) msg{
    [_txtDriverBirthdate showErrorField:msg color:[BaseView getColor:@"Vermelho"]];
}
-(void) showDriverPhoneError:(NSString*) msg{
    [_txtDriverPhone showErrorField:msg color:[BaseView getColor:@"Vermelho"]];
}


@end
