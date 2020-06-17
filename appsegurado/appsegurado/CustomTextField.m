//
//  CustomTextField.m
//  trocaimoveis
//
//  Created by Luiz othavio H Zenha on 13/01/16.
//  Copyright © 2016 intuitivea Appz. All rights reserved.
//

#import "CustomTextField.h"
#import "BaseView.h"
@interface CustomTextField(){
    CALayer *bottomBorder;
    UIColor *placeHoderColor;
    UIColor *borderColor;
    UIButton *btShowPassword;
    UILabel *lblPlaceHolder;
    BOOL isSecureText;
    
}
@end
@implementation CustomTextField


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        placeHoderColor = [UIColor whiteColor];
        borderColor = [UIColor whiteColor];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        placeHoderColor = [UIColor whiteColor];
        borderColor = [UIColor whiteColor];
        

    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self configureView];
}
-(void)configureView{
    
    [self setClipsToBounds:NO];
    bottomBorder = [[CALayer alloc] init];
    bottomBorder.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1.0);
    bottomBorder.backgroundColor = [borderColor CGColor];
    [self.layer addSublayer:bottomBorder];
//    [self setValue:placeHoderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    [self registerEvents];
    
    if(!lblPlaceHolder){
        lblPlaceHolder = [[UILabel alloc] initWithFrame:CGRectMake(0, -10, self.frame.size.width, 10)];
        [lblPlaceHolder setFont:[BaseView getDefatulFont:Micro bold:NO]];
        [lblPlaceHolder setTextColor:[BaseView getColor:@"LblCustomText"]];
        [lblPlaceHolder setHidden:YES];
        [self addSubview:lblPlaceHolder];
    }
    [lblPlaceHolder setText:self.placeholder];
    isSecureText = false;
    if(self.isSecureTextEntry){
        isSecureText = true;
        btShowPassword = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame), 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame))];
        [btShowPassword setImage:[UIImage imageNamed:@"password_off"] forState:UIControlStateNormal];
        [btShowPassword setImage:[UIImage imageNamed:@"password_on"] forState:UIControlStateSelected
         ];
        [btShowPassword addTarget:self action:@selector(showPassword) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btShowPassword];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(DidBeginEditingTextView)
//                                                     name:UITextFieldTextDidBeginEditingNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(DidEndEditingTextView)
//                                                     name:UITextFieldTextDidEndEditingNotification object:nil];
    }
     self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{
            NSForegroundColorAttributeName : placeHoderColor
        }];
    
}


-(void) unloadView{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    if(isSecureText){
        [self hidePassword];
    }
//    if(btShowPassword !=nil){
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
//    }
}


-(void)setBottomBorderColor:(UIColor*)color{
    borderColor = color;
    bottomBorder.backgroundColor = [color CGColor];
}

-(void)setPlaceholderColor:(UIColor*)color{
    placeHoderColor = color;
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{
        NSForegroundColorAttributeName : placeHoderColor
    }];
}

-(void) showErrorField:(NSString *) errorMsg color:(UIColor*)color{
    [_lblError setText:errorMsg];
    [_lblError setTextColor:color];
    [_lblError setHidden:NO];
    [bottomBorder setBackgroundColor:[color CGColor]];
    
}

-(void) showPassword{
    [btShowPassword setSelected:self.isSecureTextEntry];
    [self setSecureTextEntry:!self.isSecureTextEntry];
    
}

-(void) hidePassword{
    [btShowPassword setSelected:false];
    [self setSecureTextEntry:true];

}

- (void) didChangeTextViewText {
    //do something
    [_lblError setHidden:YES];
    [bottomBorder setBackgroundColor:[borderColor CGColor]];
    
    
    [lblPlaceHolder setHidden:[self.text isEqualToString:@""]];
    
}

//-(void)DidBeginEditingTextView{
//    if(btShowPassword != nil){
//        [btShowPassword setHidden:NO];
//    
//    }
//}
//-(void)DidEndEditingTextView{
//    if(btShowPassword != nil){
//        [btShowPassword setHidden:YES];
//    }
//
//}

-(void)registerEvents{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeTextViewText)
                                                 name:UITextFieldTextDidChangeNotification object:nil];

}

@end
