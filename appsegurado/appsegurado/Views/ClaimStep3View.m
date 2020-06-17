//
//  ClaimStep3View.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 15/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ClaimStep3View.h"
@interface ClaimStep3View(){
    UITextField *currentTextField;
    UIPickerView *pickerView;
    NSMutableArray *arrayStates;
    int selectedIndex;
}
@end
@implementation ClaimStep3View

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) loadView{
    selectedIndex = -1;
    [_widthSpace setConstant:self.frame.size.width - 40];
    [_betweenSpace setConstant: 15];
    [self setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];

    
    [_lblTitle setFont:[BaseView getDefatulFont:Medium bold:YES]];
    [_lblTitle setTextColor:[BaseView getColor:@"AzulEscuro"]];
    [_lblTitle setTextAlignment:NSTextAlignmentLeft];
    [_lblTitle setText:NSLocalizedString(@"ClaimTitle3", @"")];
    
    
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
    
    [_txtDate setPlaceholder:NSLocalizedString(@"Data", @"")];
    [_txtDate setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtDate setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtDate setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtDate setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtDate setKeyboardType:UIKeyboardTypeNumberPad];
    [_txtDate setReturnKeyType:UIReturnKeyNext];
    _txtDate.mask = @"##/##/####";
    [_txtDate setDelegate:self];
    
    [_txtTime setPlaceholder:NSLocalizedString(@"Hora", @"")];
    [_txtTime setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtTime setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtTime setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtTime setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtTime setKeyboardType:UIKeyboardTypeNumberPad];
    [_txtTime setReturnKeyType:UIReturnKeyNext];
    _txtTime.mask = @"##:##";
    [_txtTime setDelegate:self];
    
    [_txtAddress setPlaceholder:NSLocalizedString(@"Local", @"")];
    [_txtAddress setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtAddress setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtAddress setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtAddress setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtAddress setKeyboardType:UIKeyboardTypeDefault];
    [_txtAddress setReturnKeyType:UIReturnKeyNext];
    [_txtAddress setDelegate:self];
    
    [BaseView addDropShadow:_bgView];
    
    [_txtNumber setPlaceholder:NSLocalizedString(@"Numero", @"")];
    [_txtNumber setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtNumber setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtNumber setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtNumber setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtNumber setKeyboardType:UIKeyboardTypeDefault];
    [_txtNumber setReturnKeyType:UIReturnKeyNext];
    [_txtNumber setDelegate:self];
    

    [_txtRef setPlaceholder:NSLocalizedString(@"Referencia", @"")];
    [_txtRef setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtRef setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtRef setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtRef setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtRef setKeyboardType:UIKeyboardTypeDefault];
    [_txtRef setReturnKeyType:UIReturnKeyNext];
    [_txtRef setDelegate:self];
    
    [_txtCity setPlaceholder:NSLocalizedString(@"Cidade", @"")];
    [_txtCity setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtCity setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtCity setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtCity setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtCity setKeyboardType:UIKeyboardTypeDefault];
    [_txtCity setReturnKeyType:UIReturnKeyNext];
    [_txtCity setDelegate:self];
    
    [_txtNeighborhood setPlaceholder:NSLocalizedString(@"Bairro", @"")];
    [_txtNeighborhood setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtNeighborhood setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtNeighborhood setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtNeighborhood setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtNeighborhood setKeyboardType:UIKeyboardTypeDefault];
    [_txtNeighborhood setReturnKeyType:UIReturnKeyDone];
    [_txtNeighborhood setDelegate:self];
    
    [_txtState setPlaceholder:NSLocalizedString(@"Estado", @"")];
    [_txtState setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtState setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtState setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtState setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtState setDelegate:self];
    
    [_datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    [_datePicker setBackgroundColor:[BaseView getColor:@"Branco"]];
    [_datePicker setHidden:YES];
    [_datePicker setDate:[NSDate date]];
    

    
    arrayStates = [[NSMutableArray alloc] init];
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Acre",@"stateValue",@"AC", @"serverValue", nil]];
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Alagoas",@"stateValue",@"AL", @"serverValue", nil]];
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Amapá",@"stateValue",@"AP", @"serverValue", nil]];
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Amazonas",@"stateValue",@"AM", @"serverValue", nil]];
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Bahia",@"stateValue",@"BA", @"serverValue", nil]];
    
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Ceará",@"stateValue",@"CE", @"serverValue", nil]];
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Distrito Federal",@"stateValue",@"DF", @"serverValue", nil]];
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Espírito Santo",@"stateValue",@"ES", @"serverValue", nil]];
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Goiás",@"stateValue",@"GO", @"serverValue", nil]];
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Maranhão",@"stateValue",@"MA", @"serverValue", nil]];
    
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Mato Grosso",@"stateValue",@"MT", @"serverValue", nil]];
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Mato Grosso do Sul",@"stateValue",@"MS", @"serverValue", nil]];
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Minas Gerais",@"stateValue",@"MG", @"serverValue", nil]];
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Pará",@"stateValue",@"PA", @"serverValue", nil]];
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Paraíba",@"stateValue",@"PB", @"serverValue", nil]];
    
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Paraná",@"stateValue",@"PR", @"serverValue", nil]];
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Pernambuco",@"stateValue",@"PE", @"serverValue", nil]];
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Piauí",@"stateValue",@"PI", @"serverValue", nil]];
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Rio de Janeiro",@"stateValue",@"RJ", @"serverValue", nil]];
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Rio Grande do Norte",@"stateValue",@"RN", @"serverValue", nil]];
    
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Rio Grande do Sul",@"stateValue",@"RS", @"serverValue", nil]];
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Rondônia",@"stateValue",@"RO", @"serverValue", nil]];
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Roraima",@"stateValue",@"RR", @"serverValue", nil]];
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Santa Catarina",@"stateValue",@"SC", @"serverValue", nil]];
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"São Paulo",@"stateValue",@"SP", @"serverValue", nil]];
    
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Sergipe",@"stateValue",@"SE", @"serverValue", nil]];
    [arrayStates addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Tocantins",@"stateValue",@"TO", @"serverValue", nil]];

    [self updateConstraints];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self addGestureRecognizer:tap];
    [self registerForKeyboardNotifications];
    
    
    //setting current date
    currentTextField = _txtDate;
    [self datePickerChanged:_datePicker];
    
    currentTextField = _txtTime;
    [self datePickerChanged:_datePicker];
    
    
}
#pragma mark PickerViewDelegate/Source

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [arrayStates count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    return [[arrayStates objectAtIndex:row] objectForKey:@"stateValue"];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    selectedIndex = row;
    NSString *newState = [[arrayStates objectAtIndex:row] objectForKey:@"stateValue"];
    if(![newState isEqualToString:_txtState.text]){
        [_txtCity setText:@""];
    }
    [_txtState setText:newState];
    [_txtState didChangeTextViewText];
}
#pragma mark TextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [_datePicker setHidden:YES];
    if(textField == _txtDate){
        [_txtTime becomeFirstResponder];
    }else if(textField == _txtTime){
        [_txtAddress becomeFirstResponder];
    }else if(textField == _txtAddress){
        [_txtNumber becomeFirstResponder];
    }else if(textField == _txtNumber){
        [_txtRef becomeFirstResponder];
    }else if(textField == _txtRef){
        [_txtCity becomeFirstResponder];
    }else if(textField == _txtCity){
        [_txtNeighborhood becomeFirstResponder];
    }else{
        [_btNext sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    return true;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if(textField == _txtDate){
       return [_txtDate shouldChangeCharactersInRange:range replacementString:string];

    }else if(textField == _txtTime){
        return [_txtTime shouldChangeCharactersInRange:range replacementString:string];
        
    }else if(textField == _txtAddress){
        NSUInteger newLength = (textField.text.length - range.length) + string.length;
        if(newLength <= 50)
        {
            return YES;
        } else {
            NSUInteger emptySpace = 50 - (textField.text.length - range.length);
            textField.text = [[[textField.text substringToIndex:range.location]
                              stringByAppendingString:[string substringToIndex:emptySpace]]
                             stringByAppendingString:[textField.text substringFromIndex:(range.location + range.length)]];
            return NO;
        }
    }
    return YES;
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    
    if(textField == _txtDate){
        [self tapView:nil];
        [_datePicker setHidden:NO];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        [_datePicker setMaximumDate:[NSDate date]];
        currentTextField = textField;
        return NO;
    }else if(textField == _txtTime){
        [self tapView:nil];
        [_datePicker setHidden:NO];
        [_datePicker setDatePickerMode:UIDatePickerModeTime];
        currentTextField = textField;
        return NO;
    }else if(textField == _txtState){
        [self tapView:nil];
        if(pickerView == nil){
            pickerView = [[UIPickerView alloc] initWithFrame:_datePicker.frame];
            [pickerView setDelegate:self];
            [pickerView setOpaque:YES];
            [pickerView setBackgroundColor:[BaseView getColor:@"Branco"]];
            [self addSubview:pickerView];
        }
        [pickerView setHidden:NO];
        currentTextField = textField;
        return NO;
    }
    [_datePicker setHidden:YES];
    currentTextField = textField;
    return YES;
    
}
-(void) updateCity:(NSString*)cityName{
    [_txtCity didChangeTextViewText];
    [_txtCity setText:cityName];
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
        CGPoint scrollPoint = CGPointMake(0.0, kbSize.height - (CGRectGetMaxY(currentTextField.frame)- kbSize.height));
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
    if(currentTextField != nil && currentTextField.isEditing){
        [self tapTexts];
    }
    [pickerView setHidden:YES];
    [_datePicker setHidden:YES];
}
- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if(currentTextField == _txtDate){
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
        [_txtDate setText:strDate];
        [_txtDate didChangeTextViewText];
    }else if(currentTextField == _txtTime){
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
        [_txtTime setText:strDate];
        [_txtTime didChangeTextViewText];
    }
}
-(NSString*) getDate{
    return _txtDate.text;
}
-(NSString*) getTime{
    return _txtTime.text;
}

-(NSString*) getDateTime{
    NSArray *arrayString = [[[_txtDate.text  componentsSeparatedByString:@"/"] reverseObjectEnumerator] allObjects];
    NSString *dateFinal = [arrayString componentsJoinedByString:@"-"];
    return [NSString stringWithFormat:@"%@ %@",dateFinal,_txtTime.text];
}
-(NSString*) getAddress{
    return _txtAddress.text;
}
-(NSString*) getReference{
    return _txtRef.text;
}
-(NSString*) getCity{
    return _txtCity.text;
}
-(NSString*) getNeighborhood{
    return _txtNeighborhood.text;
}
-(NSString*) getNumber{
    return _txtNumber.text;
}
-(NSString*) getState{
    if(pickerView == nil || [pickerView selectedRowInComponent:0] < 0 || selectedIndex < 0){
        return @"";
    }
    return [[arrayStates objectAtIndex:[pickerView selectedRowInComponent:0]]objectForKey:@"serverValue"];

}
-(void) showNumberError:(NSString*) msg{
    [_txtNumber showErrorField:msg color:[BaseView getColor:@"Vermelho"]];
}
-(void) showDateError:(NSString*) msg{
    [_txtDate showErrorField:msg color:[BaseView getColor:@"Vermelho"]];
}
-(void) showTimeError:(NSString*) msg{
    [_txtTime showErrorField:msg color:[BaseView getColor:@"Vermelho"]];
}
-(void) showAddressError:(NSString*) msg{
    [_txtAddress showErrorField:msg color:[BaseView getColor:@"Vermelho"]];
}
-(void) showReferenceError:(NSString*) msg{
    [_txtRef showErrorField:msg color:[BaseView getColor:@"Vermelho"]];
}
-(void) showCityError:(NSString*) msg{
    [_txtCity showErrorField:msg color:[BaseView getColor:@"Vermelho"]];
}
-(void) showNeighborhoodError:(NSString*) msg{
    [_txtNeighborhood showErrorField:msg color:[BaseView getColor:@"Vermelho"]];
}
-(void) showStateError:(NSString*) msg{
    [_txtState showErrorField:msg color:[BaseView getColor:@"Vermelho"]];
}

-(void) unloadView{
    [self unRegisterKeyboard];
    [_txtDate unloadView];
    [_txtTime unloadView];
    [_txtAddress unloadView];
    [_txtRef unloadView];
    [_txtCity unloadView];
    [_txtNeighborhood unloadView];
    [_txtNumber unloadView];
    [_txtState unloadView];
    
}



@end
