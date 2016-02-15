//
//  CadastroSeguradoViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LibertyMobileViewController.h"

@interface CadastroSeguradoViewController : LibertyMobileViewController <UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate, UIAlertViewDelegate>
{
    UIActivityIndicatorView *indicator;
    UIAlertView             *uiAlertView;
    NSMutableDictionary     *dicMensagem;
}

//Property
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) IBOutlet UIButton     *btnEnviar;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NSString *policyNumber;
@property (nonatomic, retain) NSString *cpf_cnpj;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *emailConfirm;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *passwordConfirm;
@property (nonatomic) BOOL checkBox;

@property (nonatomic, retain) UIAlertView *uiAlertView;

//Actions
- (IBAction) btnCancelar:(id)sender;
- (IBAction) btnEnviar:(id)sender;

-(void)gotoPoliticaPrivacidade;

-(IBAction)btnCheckBox:(id)sender;

@end
