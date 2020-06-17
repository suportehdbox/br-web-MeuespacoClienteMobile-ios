//
//  BaseView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 23/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"
#import "Tools.h"
@interface BaseView(){
    UILabel *lblError;
}
@end
@implementation BaseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)btOpenContacts:(id)sender {


}

- (IBAction)btOpenWithoutLogin:(id)sender {
    
}




+(UIColor *) getColor:(NSString*) nameColor{
    return [Tools colorFromHexString:NSLocalizedString(nameColor, @"")];
}

+(UIFont*) getDefatulFont:(FontSize) size bold:(BOOL)bold{
    NSString *fontName = @"ArialMT";
    if(bold){
        fontName = @"Arial-BoldMT";
    }
    return [UIFont fontWithName:fontName size:(int) size];
}

-(void) showMessage:(NSString*) title message:(NSString*)message{
    
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:NSLocalizedString(@"BtPopUpSucesso",@"") otherButtonTitles:nil, nil] show];
}
+(void)addDropShadow:(UIView *)view{
    [view.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
    [view.layer setShadowOffset:CGSizeMake(3, 3)];
    [view.layer setShadowRadius:2];
    [view.layer setShadowOpacity:0.85f];
}

-(UIAlertController*) showSuccessMessageTitle:(NSString *)title message:(NSString*) message handler:(void (^ __nullable)(UIAlertAction *action))handler{
    //
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"BtPopUpSucesso", "") style:UIAlertActionStyleDefault handler:handler];
    //BtPopUpSucesso
    [controller addAction:action];
    
    return controller;

}
-(UIAlertController*) showTryAgainTitle:(NSString*)title message:(NSString*)message handler:(void (^ __nullable)(UIAlertAction *action))handlerYes handlerNo:(void (^ __nullable)(UIAlertAction *actionNo))handlerNo {
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Sim", "") style:UIAlertActionStyleDefault handler:handlerYes];
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:NSLocalizedString(@"Nao", "") style:UIAlertActionStyleCancel handler:handlerNo];
    
    [controller addAction:action];
    [controller addAction:actionNo];
    
    return controller;
    
}
-(UIAlertController*) showTryAgainMessageHandler:(void (^ __nullable)(UIAlertAction *action))handlerYes handlerNo:(void (^ __nullable)(UIAlertAction *actionNo))handlerNo {
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ErroConexaoTitulo",@"") message:NSLocalizedString(@"ErroConexaoMsg",@"") preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Sim", "") style:UIAlertActionStyleDefault handler:handlerYes];
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:NSLocalizedString(@"Nao", "") style:UIAlertActionStyleCancel handler:handlerNo];
    
    [controller addAction:action];
    [controller addAction:actionNo];
    
    return controller;

}

-(void) showErrorLoadingMessage{
    if(lblError != nil){
        [lblError removeFromSuperview];
    }
    lblError = [[UILabel alloc] initWithFrame:CGRectMake(15, (self.frame.size.height/2) - 50, self.frame.size.width-30, 100)];
    [lblError setText:NSLocalizedString(@"ErroNoSerivdor", @"")];
    [lblError setFont:[BaseView getDefatulFont:Small bold:NO]];
    [lblError setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [lblError setTextAlignment:NSTextAlignmentCenter];
//    [lblError setCenter:self.center];
    [lblError setNumberOfLines:0];
    [self addSubview:lblError];
}
-(void) showLoadingMessage:(NSString*)message{
    if(lblError != nil){
        [lblError removeFromSuperview];
    }
    lblError = [[UILabel alloc] initWithFrame:CGRectMake(15, (self.frame.size.height/2) - 50, self.frame.size.width-30, 100)];
    [lblError setText:message];
    [lblError setFont:[BaseView getDefatulFont:Small bold:NO]];
    [lblError setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [lblError setTextAlignment:NSTextAlignmentCenter];
    //    [lblError setCenter:self.center];
    [lblError setNumberOfLines:0];
    [self addSubview:lblError];
}
-(void) removeErrorMessage{
    if(lblError != nil){
        [lblError removeFromSuperview];
    }
}
@end


