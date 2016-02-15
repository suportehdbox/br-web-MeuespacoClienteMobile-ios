//
//  LoginViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "CallWebServices.h"
#import "DadosLoginSegurado.h"
#import "LibertyMobileViewController.h"

@protocol LoginViewControllerDelegate;

@interface LoginViewController : LibertyMobileViewController <UITextFieldDelegate, CallWebServicesDelegate, UITableViewDelegate, UITableViewDataSource>
{
	id<LoginViewControllerDelegate> delegate;
    
    UIActivityIndicatorView *indicator;
    
    UIButton                *btnLogin;
    
    NSMutableArray          *arrayFields;
    
    BOOL                    isLogin;
    BOOL                    isRecuperarSenha;
    BOOL                    manterLogado;
    
    NSString                *userName;
    NSString                *password;
    
    DadosLoginSegurado      *dadosLoginSegurado;
}

//Property

@property (nonatomic, assign) id<LoginViewControllerDelegate>   delegate;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView  *indicator;

@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *password;

@property (nonatomic, retain)   DadosLoginSegurado *dadosLoginSegurado;

-(id)initWithLogin:(id)target;

//Actions
//- (IBAction)btnCancelar:(id)sender;
- (IBAction)btnLogin_Click:(id)sender;

@end


@protocol LoginViewControllerDelegate <NSObject>

@optional

- (void)loginViewController:(LoginViewController *)controller loginView:(BOOL)isLogin;

@end
