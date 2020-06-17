//
//  SearchPopUpView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 31/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "SearchPopUpView.h"
#import "BaseView.h"

@implementation SearchPopUpView
@synthesize delegate;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) loadPopUp{

    [_lblTitlePopUp setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblTitlePopUp setText:NSLocalizedString(@"TituloBuscaCEP",@"")];
    [_lblTitlePopUp setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    
    [_lblOr setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblOr setText:NSLocalizedString(@"Ou",@"")];
    [_lblOr setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    
    [_txtZipCode setPlaceholder:NSLocalizedString(@"ZipCodePlaceholder",@"")];
    [_txtZipCode setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtZipCode setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtZipCode setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtZipCode setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtZipCode setKeyboardType:UIKeyboardTypeNumberPad];
    
    [_txtZipCode setDelegate:self];
    
    [_txtAddress setPlaceholder:NSLocalizedString(@"AddressPlaceholder",@"")];
    [_txtAddress setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtAddress setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtAddress setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtAddress setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    
    
    [_btSearch setTitle:NSLocalizedString(@"BotaoLocalizar", @"") forState:UIControlStateNormal];
    [_btSearch.titleLabel setFont:[BaseView getDefatulFont:Small bold:false]];
    [_btSearch setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
    [_btSearch customizeBackground:[BaseView getColor:@"Branco"]];
    [_btSearch customizeBorderColor:[BaseView getColor:@"CorBotoes"] borderWidth:1 borderRadius:7];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self addGestureRecognizer:tap];
    [self registerForKeyboardNotifications];

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
    [_txtAddress unloadView];
    [_txtZipCode unloadView];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    float posY = self.frame.size.height - kbSize.height - 15;
    
    CustomTextField *currentText;
    if(_txtAddress.isEditing){
        currentText = _txtAddress;
    }else if(_txtZipCode.isEditing){
        currentText = _txtZipCode;
    }
    
    if(CGRectGetMaxY(currentText.frame) > posY){
        [UIView animateWithDuration:0.1f animations:^{
//            self.frame = CGRectOffset(self.frame, 0, -(CGRectGetMaxY(currentText.frame) - posY) - 10
//                                      );
            _constTop.constant = - (CGRectGetMaxY(currentText.frame) - posY + 10);
        }];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if(textField == _txtZipCode){
        
        if(range.length == 0){
            if(range.location == 4){
                
                textField.text = [NSString stringWithFormat:@"%@%@-",textField.text,string];
                
                return NO;
            }else if(range.location == 5){
                if(![textField.text containsString:@"-"]){
                    textField.text = [NSString stringWithFormat:@"%@-%@",textField.text,string];
                    return NO;
                }
            }else if(range.location >= 9){
                return NO;
            }else{
                if([string length] > 1){
                    NSString *finalString = [[NSString stringWithFormat:@"%@%@",textField.text,string] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    
                    
                    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
                    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:finalString];
                    if(![alphaNums isSupersetOfSet:inStringSet]){
                        return NO;
                    }
                    
                        
                    if([finalString length] > 8){
                        finalString = [finalString substringToIndex:8];
                    }
                    
                    if([finalString length] >= 5){
                        [textField setText:[NSString stringWithFormat:@"%@-%@", [finalString substringToIndex:5],[finalString substringFromIndex:5] ]];
                    }else{
                        [textField setText:finalString];
                    }
                    return NO;
                    
                }else if([string length] == 1){
                    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
                    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:string];
                    if(![alphaNums isSupersetOfSet:inStringSet]){
                        return NO;
                    }
                }
            }
        }
    }
    
    
    return YES;

}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.5f animations:^{
        _constTop.constant = 0;
    }];
}

-(void) hideKeyboard{
    [self tapTexts];
}

-(void) setTitleText:(NSString*)title{
    [_lblTitlePopUp setText:title];
}
-(void) tapTexts{
    if(_txtAddress.isEditing){
        [_txtAddress resignFirstResponder];
    }else if(_txtZipCode.isEditing){
        [_txtZipCode resignFirstResponder];
    }
}
-(void)tapView:(UITapGestureRecognizer *)recognizer{
    UIView* view = recognizer.view;
    CGPoint loc = [recognizer locationInView:view];
    UIView* subview = [view hitTest:loc withEvent:nil];
    if(![subview isEqual:self]){
        [self tapTexts];
        return;
    }
    if(_txtAddress.isEditing || _txtZipCode.isEditing){
        [self tapTexts];
    }else{
        [self hide];
    }
}
-(void) show{
    [self setHidden:NO];
 }

-(void) hide{
    [self setHidden:YES];
}


-(IBAction)btSearchClicked:(id)sender{
    [self tapTexts];
    if(delegate != nil && [delegate respondsToSelector:@selector(searchClicked:zipCode:)]){
        [delegate searchClicked:[_txtAddress text] zipCode:[_txtZipCode text]];
    }
}
@end
