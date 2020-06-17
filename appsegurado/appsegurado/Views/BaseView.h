//
//  BaseView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 23/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface BaseView : UIView
@property (strong, nonatomic) IBOutlet CustomButton *btPhone;
@property (strong, nonatomic) IBOutlet CustomButton *btLoginLater;

- (IBAction)btOpenContacts:(id)sender;
- (IBAction)btOpenWithoutLogin:(id)sender;

typedef enum {
    Nano = 10,
    Micro = 13,
    Small = 15,
    Medium = 18,
    Large = 20,
    XLarge = 24,
    Menu = 72,
} FontSize;


+(UIColor *) getColor:(NSString*) nameColor;
+(UIFont*) getDefatulFont:(FontSize) size bold:(BOOL)bold;
+(void) addDropShadow:(UIView*) view;
-(void) showMessage:(NSString*) title message:(NSString*)message;
-(UIAlertController*) showSuccessMessageTitle:(NSString *)title message:(NSString*) message handler:(void (^ __nullable)(UIAlertAction *action))handler;

-(UIAlertController*) showTryAgainMessageHandler:(void (^ __nullable)(UIAlertAction *action))handlerYes handlerNo:(void (^ __nullable)(UIAlertAction *actionNo))handlerNo;
-(UIAlertController*) showTryAgainTitle:(NSString*)title message:(NSString*)message handler:(void (^ __nullable)(UIAlertAction *action))handlerYes handlerNo:(void (^ __nullable)(UIAlertAction *actionNo))handlerNo;
-(void) removeErrorMessage;
-(void) showErrorLoadingMessage;
-(void) showLoadingMessage:(NSString*)message;
@end
