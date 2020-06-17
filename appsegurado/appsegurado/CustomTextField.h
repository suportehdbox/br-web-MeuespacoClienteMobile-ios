//
//  CustomTextField.h
//  trocaimoveis
//
//  Created by Luiz othavio H Zenha on 13/01/16.
//  Copyright © 2016 intuitivea Appz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VMaskTextField.h"

@interface CustomTextField : VMaskTextField
@property (nonatomic, strong) IBOutlet UILabel *lblError;
-(void)setBottomBorderColor:(UIColor*)color;
-(void)setPlaceholderColor:(UIColor*)color;
-(void) showErrorField:(NSString *) errorMsg color:(UIColor*)color;
-(void) unloadView;
-(void)registerEvents;
- (void) didChangeTextViewText;
@end
